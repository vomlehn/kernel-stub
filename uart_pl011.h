#ifndef _UARTPL011_H_
#define _UARTPL011_H_

#include <stdint.h>

struct UARTpl011 {
	void	*dev;
};

struct UARTpl011 uart_new(uint64_t dev);
struct UARTpl011 uart_default(void);
uint8_t uart_getchar(struct UARTpl011 self);
void uart_putchar(struct UARTpl011 self, uint8_t c);
void uart_puts(struct UARTpl011 uart, const char *str);
#endif /* _UARTPL011_H_ */
