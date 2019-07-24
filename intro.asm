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
	ld ix, offset
	ld hl, (ix)
	ld bc, 128
	add hl, bc
	ld (ix), hl
	jr loop

drawSin:
	ld c, 3
	ld de, #400d

.draw0	
	ld a, (offset + 1)
	and a, 63
	rlca
	rlca
	ld hl, sprite 
	push bc
	xor b
	ld c, a
	add hl, bc
	pop bc
	ld b, 64
.draw1
	push bc
	ld bc, 4
	ldir
	dec de
	dec de
	dec de
	dec de
	call down
	pop bc
	djnz .draw1

	dec c
	jr nz, .draw0

	ret

clear:
	ld hl, #4000         
    ld de, #4001        
    ld bc, 6143         
    ld (hl), l          
    ldir

    inc hl
    inc de
	ld bc, 767
	ld (hl), #7
	ldir
	ret

down:
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

spritegen:
	ld hl, sprite + 60
	ld b, 16
	ld de, sprite + 64
	
.spg1
	push bc
	ld bc, #4
	ldir
	dec hl
	dec hl
	dec hl
	dec hl
	dec hl
	dec hl
	dec hl
	dec hl
	pop bc	
	djnz .spg1

	ld ix, sprite
	ld iy, sprite + 128
	ld b, 32
.spg2
	ld a, (ix + 2)
	call reverse
	ld (iy +1), a
	ld a, (ix + 3)
	call reverse
	ld (iy), a
	xor a
	ld (iy + 2), a
	ld (iy + 3), a
	inc ix
	inc ix
	inc ix
	inc ix
	inc iy
	inc iy
	inc iy
	inc iy
	djnz .spg2

	ld hl, sprite
	ld de, sprite + 256
	ld bc, 256
	ldir
	ret

reverse:
	push hl
	push bc
	ld b,8
	ld l,a
.rev1
 	rl l
	rra
	djnz .rev1
	pop bc
	pop hl
	ret

offset:
	db 0
	db 0

sprite:
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