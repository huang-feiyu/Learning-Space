all:
	gcc -c -ffreestanding sh-xv6.c -g -O2
	ld sh-xv6.o -o sh

run: all
	./sh

clean:
	rm sh sh-xv6.o

