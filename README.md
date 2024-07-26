# Yamaha DX9 ROM Disassembly
This repository contains an annotated disassembly of the Yamaha DX9 Firmware ROM.
My fully annotated disassembly of the DX7 Firmware ROM can be found [here](https://github.com/ajxs/yamaha_dx7_rom_disassembly).

## Overview
Like the DX7, the DX9 runs on a Hitachi HD63B03RP CPU. Among other things, the DX9's firmware is responsible for handling user input, MIDI I/O, and processing the synth's LFO, pitch, and operator amplitude envelopes. Unlike the DX7, the DX9 has no sub-CPU, and polls the synthesizer's peripherals directly from the CPU. This project provides a complete, annotated disassembly of the firmware ROM, with the aim to provide a resource for people researching the functionality of this iconic synthesiser.

## Building the ROM
The project's `makefile` includes a recipe for building the binary from source using the [dasm](https://dasm-assembler.github.io/ "dasm") assembler. If you have dasm and GNU Make installed, you can run `make` in the source directory to assemble the binary.

A `make compare` script is provided, which will run a script comparing the MD5 checksum of the newly built binary against the checksum of the original.

## Leftover Development Artifacts in the DX9 ROM
The DX9 mask ROM contains several blocks of unused data: A large block of orphaned 6303 code located at offset `0xC84D`, and two fragments of strange ASCII data, located at `0xEE7E`, and `0xFF85`. 
The two fragments of ASCII data appear in conspicuous places, one at the end of the ROM's main string table, and the other between the end of the code and the start of the vector table, located at the end of the binary. The ASCII data appears to be fragments of a symbol table, leftover from the ROM's development. 

More information on these development artifacts can be found [here](https://ajxs.me/blog/Hacking_the_Yamaha_DX9_To_Turn_It_Into_a_DX7.html#leftover_data).

