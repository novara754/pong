#! /bin/sh
pushd ./src/
nasm -f bin -o pong.bin ./src/pong.s
popd
