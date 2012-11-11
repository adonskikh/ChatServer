	.file	"test.c"
	.comm	message_count,4,4
	.section	.rodata
.LC0:
	.string	"["
.LC1:
	.string	"]: "
.LC2:
	.string	"Recieved message[%d]: %s\n"
	.text
	.globl	PrintMessage
	.type	PrintMessage, @function
PrintMessage:
.LFB0:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%edi
	pushl	%ebx
	subl	$288, %esp
	movl	$.LC0, %edx
	leal	-264(%ebp), %eax
	movzwl	(%edx), %edx
	movw	%dx, (%eax)
	leal	8(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-264(%ebp), %eax
	movl	%eax, (%esp)
	.cfi_offset 3, -16
	.cfi_offset 7, -12
	call	strcat
	movl	$.LC1, %ebx
	leal	-264(%ebp), %eax
	movl	$-1, -268(%ebp)
	movl	%eax, %edx
	movl	$0, %eax
	movl	-268(%ebp), %ecx
	movl	%edx, %edi
	repnz scasb
	movl	%ecx, %eax
	notl	%eax
	leal	-1(%eax), %edx
	leal	-264(%ebp), %eax
	addl	%eax, %edx
	movl	(%ebx), %eax
	movl	%eax, (%edx)
	leal	40(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-264(%ebp), %eax
	movl	%eax, (%esp)
	call	strcat
	movl	message_count, %edx
	movl	$.LC2, %eax
	leal	-264(%ebp), %ecx
	movl	%ecx, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	printf
	addl	$288, %esp
	popl	%ebx
	.cfi_restore 3
	popl	%edi
	.cfi_restore 7
	popl	%ebp
	.cfi_def_cfa 4, 4
	.cfi_restore 5
	ret
	.cfi_endproc
.LFE0:
	.size	PrintMessage, .-PrintMessage
	.section	.rodata
.LC3:
	.string	"i = %d\n"
.LC4:
	.string	"n = %d\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB1:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	andl	$-16, %esp
	subl	$2144, %esp
	movl	$0, 2136(%esp)
	movl	$0, 2140(%esp)
	jmp	.L3
	.cfi_offset 3, -20
	.cfi_offset 6, -16
	.cfi_offset 7, -12
.L4:
	leal	1076(%esp), %eax
	addl	2140(%esp), %eax
	movb	$111, (%eax)
	addl	$1, 2140(%esp)
.L3:
	cmpl	$30, 2140(%esp)
	jle	.L4
	movl	$.LC3, %eax
	movl	2140(%esp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	printf
	leal	1076(%esp), %eax
	addl	2140(%esp), %eax
	movb	$0, (%eax)
	movl	$0, 2140(%esp)
	jmp	.L5
.L6:
	leal	1108(%esp), %eax
	addl	2140(%esp), %eax
	movb	$97, (%eax)
	addl	$1, 2140(%esp)
.L5:
	cmpl	$227, 2140(%esp)
	jle	.L6
	leal	1108(%esp), %eax
	addl	2140(%esp), %eax
	movb	$0, (%eax)
	movl	%esp, %edx
	leal	1076(%esp), %ebx
	movl	$265, %eax
	movl	%edx, %edi
	movl	%ebx, %esi
	movl	%eax, %ecx
	rep movsl
	call	PrintMessage
	addl	$1, 2136(%esp)
	movl	$.LC4, %eax
	movl	2136(%esp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	printf
	movl	$0, %eax
	leal	-12(%ebp), %esp
	popl	%ebx
	.cfi_restore 3
	popl	%esi
	.cfi_restore 6
	popl	%edi
	.cfi_restore 7
	popl	%ebp
	.cfi_def_cfa 4, 4
	.cfi_restore 5
	ret
	.cfi_endproc
.LFE1:
	.size	main, .-main
	.ident	"GCC: (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3"
	.section	.note.GNU-stack,"",@progbits
