; FC3/GEOS loader by Michael Steil

src = 2
dst = 4
tmp = 2

DST   = $0801
ENTRY = $080d

.if 0 ; fake GEOS background pattern early
char = 1
	lda #15
	sta $d021
	ldx #0
	stx $d020
ll:	lda #char
	sta $0400,x
	sta $0500,x
	sta $0600,x
	sta $0700,x
	lda #11
	sta $d800,x
	sta $d900,x
	sta $da00,x
	sta $db00,x
	inx
	bne ll

	lda #$aa
	sta char * 8 + 0
	sta char * 8 + 2
	sta char * 8 + 4
	sta char * 8 + 6
	lsr
	sta char * 8 + 1
	sta char * 8 + 3
	sta char * 8 + 5
	sta char * 8 + 7
	lda #$11
	sta $d018
.else ; show "BOOTING GEOS ..."
	jsr $e544
	ldx #message_end - message - 1
@1:	lda message,x
	sta $054c,x
	dex
	bpl @1
.endif

	; GEOS needs the current drive set up
	lda #8
	sta $ba

	lda #<data
	sta src
	lda #>data
	sta src+1
	lda #<DST
	sta dst
	lda #>DST
	sta dst+1
	ldx #64
	ldy #0
@3:	lda (src),y
	sta (dst),y
	iny
	bne @3
	inc src+1
	inc dst+1
	dex
	bne @3

	lda fix_byte
	sta $9e04 - data + DST

	lda #$8d
	sta tmp
	lda #$ff
	sta tmp+1
	lda #$df
	sta tmp+2
	lda #$60
	sta tmp+3
	lda #>(ENTRY - 1)
	pha
	lda #<(ENTRY - 1)
	pha
	lda #$70
	jmp tmp

message:
	.byte $02, $0f, $0f, $14, $09, $0e, $07, $20
	.byte $07, $05, $0f, $13, $20, $2e, $2e, $2e
message_end:

fix_byte:

data = * + 1
