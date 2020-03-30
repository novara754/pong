@echo off
pushd .\src\
nasm -f bin -o ..\pong.bin pong.s
popd
