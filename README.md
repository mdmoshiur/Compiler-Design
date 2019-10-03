# Compiler-Design 

This is my designed compiler which generates assembly code (MIPS assembly) of my newly designed language. 

You can write code my generated language my compiler will convert that in assembly code. You can run this assembly code in the QtSpim emulator. 

I used flex for lexical analysis; bison for syntax and semantic analysis.
Stack machine is used for intermediate code generation. Then I generate MIPS assembly code for input code.
