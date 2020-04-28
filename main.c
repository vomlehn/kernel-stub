#include "uart_pl011.h"

void my_exit(void);

int main(int argc, char *argv[])
{
	struct UARTpl011 uart;

	uart = uart_new(0x09000000);
	uart_puts(uart, "Stub kernel started\n");
	uart_puts(uart, "Stub kernel exiting\n");
	my_exit();
}
