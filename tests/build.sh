#!/bin/bash

echo "Starting Borders compilation...."
java -jar ~/bin/KickAss.jar borders.asm

echo "Launching Commodore 64 emulator (VICE)..."
open borders.prg