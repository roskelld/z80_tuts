    device	zxspectrum48

    org $8000

    jp start

SCN_MEM_1       = $4000
SCN_MEM_2       = $45FF
SCN_MEM_3       = $4600
COL_MEM_1       = $5800
PIXEL_ROW_16    = $200  ; Number of bytes in 16 rows of pixels
GFX_1           = %11001100
GFX_2           = %10011001
BLU_BLK         = $41

start:
    ld a,GFX_1
    ld de,SCN_MEM_1
    ld (de),a
    ex de,hl
    ld de,SCN_MEM_1+1
    ld bc,PIXEL_ROW_16

bitmap_loop:
    ldi                 ; fill first 16 rows with vertical bars
    ld a,b
    or c
    jr nz,bitmap_loop
    srl (hl)            ; shift pattern to right
    ld bc,PIXEL_ROW_16
    ldir                ; fill the next 16 rows with shifted bars
    srl(hl)             ; shift pattern to right once more
    ld de,SCN_MEM_2
    ldd                 ; copy new pattern to end of next block, dec DE
    ld bc,$1FE          
    ld hl,SCN_MEM_2
    lddr                ; fill in third block backwards
    ld hl,SCN_MEM_3
    ld (hl),GFX_2
    ld de,SCN_MEM_3+1
    ld bc,$1FF
    exx                 ; we'll get back to fourth block later
    ld hl,COL_MEM_1 
    ld (hl),BLU_BLK     ; blue ink on black paper
    ld de,COL_MEM_1+1
    ld bc,$FF
color_loop:
    ldi
    inc (hl)            ; increment ink color
    ld a,$07
    and (hl)            ; check to see if ink is set to zero (black)
    jr nz,next
    ld (hl),BLU_BLK     ; re-initialize color
next:
    ld a,b
    or c
    jr nz,color_loop
    exx                 ; bring back fouth block addresses
    ldir                ; fill in fourth block
    ret

; Deployment: Snapshot
    savesna "data.sna",start