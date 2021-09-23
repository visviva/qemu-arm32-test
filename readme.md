
# Run ARM32 executables in qemu

## Prerequisites

Install the following dependencies on Ubunut. Everything here was tested on Ubuntu 20.04:
```bash
$ sudo apt install g++-9-multilib-arm-linux-gnueabihf \ 
                   gcc-arm-linux-gnueabihf \
                   g++-arm-linux-gnueabihf \
                   binutils-arm-linux-gnueabihf \
                   binutils-arm-linux-gnueabihf-dbg \
                   qemu-user \
                   qemu-user-static
```

## Option 1 - let qemu-user select the architecture

To run executables directly from the shell, we can use qemu-user. We only need to compile everythin statically.
``` bash
$ arm-linux-gnueabihf-g++ -static -O0 -ggdb main.cpp -o app_static
```
Debugging complicated, gdb-multiarch has problems detecting and choosing the correct architecture and sysroot.

## Option 2 - use qemu-arm

The executables are run in a well defined environment. Simply compile:
``` bash
$ arm-linux-gnueabihf-g++ -O0 -ggdb main.cpp -o app_dynamic
```
And then run it like:
``` bash
$ qemu-arm -L /usr/arm-linux-gnueabihf -g 1234 ./app_dynamic
```
Where ``-g`` defines the port of the gdbserver.

To connect with gdb, open gdb-multiarch:

```bash
$ gdb-multiarch ./app_dynamic
```

Then in gdb set the architecture and the sysroot:
``` gdb
>>> set architecture arm
>>> set sysroot /usr/arm-linux-gnueabihf
>>> set so-lib-search-path /usr/arm-linux-gnueabihf/lib
```

Then you can set breakpoints and run the executable:
``` gdb
>>> b main
>>> target remote :1234
>>> c
```
