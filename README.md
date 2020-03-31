# Pong

A version of Pong that fits into the boot-sector of x86 systems.
Written in pure x86 assembly.

![screenshot of the game](screenshot.png)

## Game Rules

At the beginning of each round a ball spawns in the middle of the screen and
will move diagonally towards the left or right side of the screen.

Once the ball hits a wall or one of the player's paddles the ball will bounce and change
its direction of movement.

When the ball touches the left or right side of the screen without bouncing from one of the paddles
the player whose wall was hit loses the round and the other player gains a point.

**Note:** There is no ingame score display.

## Controls

This is a two player game, each player gets one paddle.  
The left paddle belongs to player 1 and is controlled using `W` and `S`, while
the right paddle belongs to player 2 and is controlled using `I` and `K`.

Due to the way keyboards work pressing multiple keys at once will make the
game register only one of those keys. This means when two players try to move at the same time
only one of them may end up moving until this player stops pressing a key.

## Building & Running

**Requirements:** [NASM](https://nasm.us/).

Using the `build.sh` or `build.bat` scripts the game can be compiled into a binary file.
The resulting `pong.bin` file can be used as a disk image for the boot sector, which
will then be loaded by the computer's BIOS.

An easy way to play the game is to load the game using an x86 pc emulator like
[QEMU](https://www.qemu.org/):
```
$ qemu-system-i386 -fda pong.bin
```

## License

Licensed under the [MIT License](LICENSE).
