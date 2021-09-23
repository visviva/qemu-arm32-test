all: static dynamic

static:
	arm-linux-gnueabihf-g++ -static -O0 -ggdb main.cpp -o app_static

dynamic:
	arm-linux-gnueabihf-g++ -O0 -ggdb main.cpp -o app_dynamic

clean:
	rm app_static app_dynamic

qemu-arm-gdb: dynamic
	qemu-arm -L /usr/arm-linux-gnueabihf -g 1234 ./app_dynamic