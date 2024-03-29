	device zxspectrum128
	org #8000
SnaStart:
	ld sp,#7fff

	call clear
	call spritegen

loop:
	ei
	halt
	call drawSin
	jr loop

drawSin:
	ld l, 0
	ld c, 3				; Repeat wave 3 times
	ld de, #400e		; Initial screen coordinate

.draw0
	ld h, high sprite
						; Draw 64 lines of sprite
	ld b, 64
.draw1
	push bc
	ldi
	ldi
	ldi
	ldi
	dec e
	dec e
	dec e
	dec e
	call down
	pop bc
	djnz .draw1

	dec c
	jr nz, .draw0

	ld a, (drawSin + 1)
	add a, 4
	ld (drawSin + 1), a
	ret

clear:					; Clear screen
	ld hl, #4000
    ld de, #4001
    ld bc, 6143
    ld (hl), l
    ldir

someone:
	ld a,%00111000
	ld hl,#5800
	ld c,48
.l0	ld b,16
.l1	ld (hl),a
	inc hl
	djnz .l1
	xor %00111111
	dec c
	jr nz,.l0
	ret

down:					; Move 1 line down
	inc d
	ld a, d
	and 7
	ret nz
	ld a, e
	add a, 32
	ld e, a
	ret c
	ld a, d
	add a, -8
	ld d, a
	ret

spritegen:				; We have only 1/4 of sine wave hardcoded, so here we expand it to full period
	ld hl, sprite + 60
	ld b, 16
	ld de, sprite + 64

.spg1
	push bc
	ld bc, #4
	ldir
	ld bc, 8
	sub hl, bc
	pop bc
	djnz .spg1

	ld de,sprite+127
	ld hl,sprite+128
	ld c,128
.spg2
	ld a,(de)
	ld b,8
.spg3
	rrca
	rl (hl)
	djnz .spg3
	dec de
	inc hl
	dec c
	jr nz,.spg2

	ld hl, sprite
	ld de, sprite + 256
	ld bc, 256
	ldir
	ret

	align #100
sprite:					; Sine wave sprite
	db #0, #0, #80, #0
	db #0, #0, #80, #0
	db #0, #0, #80, #0
	db #0, #0, #c0, #0
	db #0, #0, #c0, #0
	db #0, #0, #e0, #0
	db #0, #0, #f8, #0
	db #0, #0, #fc, #0
	db #0, #0, #ff, #0
	db #0, #0, #ff, #c0
	db #0, #0, #ff, #e0
	db #0, #0, #ff, #f0
	db #0, #0, #ff, #fc
	db #0, #0, #ff, #fc
	db #0, #0, #ff, #fe
	db #0, #0, #ff, #fe

	display $-SnaStart
	savesna "intro.sna",SnaStart
	savebin "intro.C",SnaStart,$-SnaStart