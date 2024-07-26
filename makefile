.POSIX:
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.PHONY: clean compare

BIN_OUTPUT   := dx9_rom_rebuild.bin
INPUT_ASM    := yamaha_dx9_rom.asm
LISTING_TXT  := listing.txt
SYMBOLS_TXT  := symbols.txt
ROM_CHECKSUM := "842f55a4def1a48ae85ddcea7dc86829"

all: ${BIN_OUTPUT}

${BIN_OUTPUT}:
	dasm ${INPUT_ASM} -f3 -v4 -o${BIN_OUTPUT} -l${LISTING_TXT} -s${SYMBOLS_TXT}

compare: ${BIN_OUTPUT}
	@if [ "$$(md5sum ${BIN_OUTPUT} | awk '{print $$1}')" = "${ROM_CHECKSUM}" ]; then \
		echo "Build is correct!"; \
	else \
		echo "Build is not correct!"; \
		exit 1; \
	fi

clean:
	rm -f ${BIN_OUTPUT}
