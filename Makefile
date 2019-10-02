default_target: all

all: intro.asm
	sjasmplus intro.asm
	xpeccy intro.sna
