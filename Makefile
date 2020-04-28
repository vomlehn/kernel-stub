CROSS :=	aarch64-linux-gnu-
CC :=	$(CROSS)gcc
LD :=	$(CROSS)ld

ASFLAGS :=	-g -ggdb

CFLAGS +=	-Wall -Wextra -Werror -Wno-unused-parameter
CFLAGS +=	-g -ggdb

LDFLAGS +=	-static
LDFLAGS +=	-Tarch.lds -nostdlib
LDFLAGS +=	-g -ggdb

all:	stub

crt0.o:	crt0.S

main.o: main.c

uart_pl011.o: uart_pl011.c

stub: crt0.o uart_pl011.o main.o
	$(CC) $(LDFLAGS) -o $@ $^

clean:
	rm -f crt0.o uart_pl011.o main.o
	rm -f stub
