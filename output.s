#start
.data
	newline: .asciiz "
"
.text
.globl main
main:
addiu $t7, $sp, 160

#ld_int
li $a0, 2
sw $a0, 0($sp)
addiu $sp, $sp, 16


#store
sw $a0, 0($t7)

#ld_int
li $a0, 4
sw $a0, 0($sp)
addiu $sp, $sp, 16


#ld_var
lw $a0, 0($t7)
sw $a0, 0($sp)
addiu $sp, $sp, 16


#ld_int
li $a0, 100
sw $a0, 0($sp)
addiu $sp, $sp, 16


#mul
addiu $sp, $sp, -16
lw $a0, 0($sp)
addiu $sp, $sp, -16
lw $t1, 0($sp)
mul $a0, $t1, $a0
sw $a0, 0($sp)
addiu $sp, $sp, 16


#add
addiu $sp, $sp, -16
lw $a0, 0($sp)
addiu $sp, $sp, -16
lw $t1, 0($sp)
add $a0, $t1, $a0
sw $a0, 0($sp)
addiu $sp, $sp, 16


#store
sw $a0, 16($t7)

#write_int
lw $a0, 0($t7)
li $v0, 1
move $t0, $a0
syscall

#pnew
li $v0, 4
la $a0, newline
syscall

#write_int
lw $a0, 16($t7)
li $v0, 1
move $t0, $a0
syscall

#pnew
li $v0, 4
la $a0, newline
syscall

#ld_var
lw $a0, 0($t7)
sw $a0, 0($sp)
addiu $sp, $sp, 16


#ld_var
lw $a0, 16($t7)
sw $a0, 0($sp)
addiu $sp, $sp, 16


#lte
addiu $sp, $sp, -16
lw $a0, 0($sp)
addiu $sp, $sp, -16
lw $t1, 0($sp)
sle $a0, $t1, $a0
sw $a0, 0($sp)
add $sp, $sp, 16


#jmp_false
beq $a0, 0, LABEL3


#ld_var
lw $a0, 0($t7)
sw $a0, 0($sp)
addiu $sp, $sp, 16


#ld_int
li $a0, 1
sw $a0, 0($sp)
addiu $sp, $sp, 16


#add
addiu $sp, $sp, -16
lw $a0, 0($sp)
addiu $sp, $sp, -16
lw $t1, 0($sp)
add $a0, $t1, $a0
sw $a0, 0($sp)
addiu $sp, $sp, 16


#store
sw $a0, 0($t7)

#ld_var
lw $a0, 16($t7)
sw $a0, 0($sp)
addiu $sp, $sp, 16


#ld_int
li $a0, 2
sw $a0, 0($sp)
addiu $sp, $sp, 16


#div
addiu $sp, $sp, -16
lw $a0, 0($sp)
addiu $sp, $sp, -16
lw $t1, 0($sp)
div $a0, $t1, $a0
sw $a0, 0($sp)
addiu $sp, $sp, 16


#store
sw $a0, 16($t7)

#label
LABEL3:


#write_int
lw $a0, 0($t7)
li $v0, 1
move $t0, $a0
syscall

#pnew
li $v0, 4
la $a0, newline
syscall

#write_int
lw $a0, 16($t7)
li $v0, 1
move $t0, $a0
syscall

#pnew
li $v0, 4
la $a0, newline
syscall

#halt
li $v0, 10
syscall
