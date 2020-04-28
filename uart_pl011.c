#include <stdlib.h>

#include "uart_pl011.h"

#define  UARTFR_RI		1 << 8
#define  UARTFR_TXFE		1 << 7
#define  UARTFR_RXFF		1 << 6
#define  UARTFR_TXFF		1 << 5
#define  UARTFR_RXFE		1 << 4
#define  UARTFR_BUSY		1 << 3
#define  UARTFR_DCD		1 << 2
#define  UARTFR_DSR		1 << 1
#define  UARTFR_CTS		1 << 0

#define  UARTLCR_SPS		1 << 7
#define  UARTLCR_WLEN_8		0x3 << 5
#define  UARTLCR_FEN		1 << 4
#define  UARTLCR_STP2_1		0 << 3
#define  UARTLCR_EPS		1 << 2
#define  UARTLCR_PEN		1 << 1
#define  UARTLCR_BRK		2 << 0

#define  UARTDR			0x0
#define  UARTRSR		0x4
#define  UARTFR			0x18
#define  UARTIBRD		0x24
#define  UARTFBRD		0x28
#define  UARTLCR_H		0x2c
#define  UARTCR			0x30

#define write_volatile(ptr, value)	do {		\
		*(volatile typeof(ptr))ptr = value;	\
	} while (0)
#define read_volatile(ptr) ({				\
		*(volatile typeof(ptr))ptr;		\
	})

struct UARTpl011 uart_new(uint64_t dev)
{
	uint32_t clock_frequency, data_rate, divisor;
	uint32_t lcr;
	uint32_t *uartibrd, *uartfbrd, *uartlcr_h;
	struct UARTpl011 uart;

        clock_frequency = 24000000;
        data_rate = 115200;
        divisor = clock_frequency / (16 * data_rate);

	uartibrd = (uint32_t *)(dev + UARTIBRD);
	uartfbrd = (uint32_t *)(dev + UARTFBRD);
	uartlcr_h = (uint32_t *)(dev + UARTLCR_H);

	write_volatile(uartibrd, divisor);
	write_volatile(uartfbrd, 0);
	lcr = UARTLCR_WLEN_8 | UARTLCR_FEN | UARTLCR_STP2_1;
	write_volatile(uartlcr_h, lcr);

	uart.dev = (void *)dev;
	return uart;
}

struct UARTpl011 uart_default(void)
{
	struct UARTpl011 uart;
	uart.dev = NULL;
	return uart;
}

static void uart_wait_for_received_char(struct UARTpl011 self)
{
	uint32_t *uartfr;
	uint32_t val;

	uartfr = (uint32_t *)(self.dev + UARTFR);
	do {
		val = read_volatile(uartfr);
	} while ((val & UARTFR_RXFE) != 0);
}

static void uart_wait_for_transmitter_ready(struct UARTpl011 self)
{
	uint32_t *uartfr;
	uint32_t val;

	uartfr = (uint32_t *)(self.dev + UARTFR);
	do {
		val = read_volatile(uartfr);
	} while ((val & UARTFR_RXFE) != 0);
}

uint8_t uart_getchar(struct UARTpl011 self)
{
	uint32_t *uartdr;
	uint8_t c;

	uart_wait_for_received_char(self);
	uartdr = (uint32_t *)(self.dev + UARTDR);
	c = read_volatile(uartdr);
	return c;
}

void uart_putchar(struct UARTpl011 self, uint8_t c)
{
	uint32_t *uartdr;

	uartdr = (uint32_t *)(self.dev + UARTDR);

	if (c == 0xd) {
		uart_wait_for_transmitter_ready(self);
		write_volatile(uartdr, 0xa);
	}

	uart_wait_for_transmitter_ready(self);
	write_volatile(uartdr, c);
}

void uart_puts(struct UARTpl011 uart, const char *str)
{
	while (*str != '\0') {
		uart_putchar(uart, *str);
		str++;
	}
}
