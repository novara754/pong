# Pong

A version of Pong that fits into the boot-sector of x86 systems.
Written in pure x86 assembly.

## Controls

This is a two player game, each player gets one paddle.  
The left paddle belongs to player 1 and is controlled using `W` and `S`, while
the right paddle belongs to player 2 and is controlled using `I` and `K`.

Due to the way keyboards work pressing multiple keys at once will make the
game register only one of those keys. This means when two players try to move at the same time
only one of them may end up moving until this player stops pressing a key.

## Building

**Requirements:** [NASM](https://nasm.us/).

Using the `build.sh` or `build.bat` scripts the game can be compiled into a binary file.
The resulting `pong.bin` file can be used as a disk image for the boot sector, which
will then be loaded by the computer's BIOS.

## License

Licensed under the [MIT License](LICENSE).
