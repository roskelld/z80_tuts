    device	zxspectrum48

    org $8000

    jp start 

BORDER          = 8859   ; Write the screen border color
COLOR_ATTR      = $5800
start:
    ld a,$D6
    ld (COLOR_ATTR),a
    ld a,$85
    call BORDER
    ret 
    
; Deployment: Snapshot
    savesna "load.sna",start
    