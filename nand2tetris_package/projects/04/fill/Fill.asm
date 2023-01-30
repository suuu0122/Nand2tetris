// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed. 
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.

// Put your code here.

(LOOP_KBD)
		@KBD
		D=M
		@SELECT_WHITE
		D; JEQ			// if D=0 then goto SELECT_WHITE (何も押されていない場合はSELECT_WHITE）にジャンプ)
		@0
		D=A - 1
		@SET_COLOR
		0; JMP			// goto SET_COLOR (上記でSELECT_WHITEで無いことがわかっているので@colorに黒=1が代入されるようにする)

(SELECT_WHITE)
		@0
		D=A

(SET_COLOR)
		@color
		M=D				// color=0 or -1

		@SCREEN
		D=A				// D=16384 (SCREENのベースアドレス)
		@pos
		M=D				// pos=16384

		@8192			// define screen size 24576 - 16384 = 8192
		D=A				// D=8192
		@i
		M=D				// i=8192

(LOOP_FILL)
		@i
		D=M
		@FILL_END
		D; JEQ			// if i == 0 then goto FILL_END (最初はi=8192)

		// print color
		@color
		D=M		// D=color
		@pos
		A=M		// A=pos 
		M=D		// M[pos]=color

		@pos
		M=M+1
		@i
		M=M-1

		@LOOP_FILL
		0; JMP

(FILL_END)
		@LOOP_KBD
		0; JMP			// スクリーンの塗りつぶしが完了したらLOOP_KBDに戻る