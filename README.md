# Pong

A version of Pong that fits into the boot-sector of x86 systems.
Written in pure x86 assembly.

## Building

**Requirements:** [NASM](https://nasm.us/).

Using the `build.sh` or `build.bat` scripts the game can be compiled into a binary file.
The resulting `pong.bin` file can be used as a disk image for the boot sector, which
will then be loaded by the computer's BIOS.

## License

Licensed under the [MIT License](LICENSE).
