#!/bin/bash

echo "Starting 51 Pegasus compilation...."
java -jar ~/bin/KickAss.jar 51pegasus.asm

echo "Launching Commodore 64 emulator (VICE)..."
open 51pegasus.prg