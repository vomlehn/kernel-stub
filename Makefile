CROSS :=	aarch64-linux-gnu-
CC :=	$(CROSS)gcc
LD :=	$(CROSS)ld

CFLAGS +=	-Wall -Wextra -Werror -Wno-unused-parameter
LDFLAGS +=	-static
LDFLAGS +=	-Tarch.lds -nostdlib

all:	stub

crt0.o:	crt0.S

main.o: main.c

stub: crt0.o main.o
	$(CC) $(LDFLAGS) -o $@ $^

clean:
	rm -f crt0.o main.o
	rm -f stub
