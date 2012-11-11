	.file	"server.c"
	.text
	.globl	ListIsEmpty
	.type	ListIsEmpty, @function
ListIsEmpty:
.LFB0:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	setle	%al
	popl	%ebp
	.cfi_def_cfa 4, 4
	.cfi_restore 5
	ret
	.cfi_endproc
.LFE0:
	.size	ListIsEmpty, .-ListIsEmpty
	.globl	AddToList
	.type	AddToList, @function
AddToList:
.LFB1:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	$8, (%esp)
	call	malloc
	movl	%eax, -12(%ebp)
	movl	-12(%ebp), %eax
	movl	12(%ebp), %edx
	movl	%edx, (%eax)
	movl	-12(%ebp), %eax
	movl	$0, 4(%eax)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	ListIsEmpty
	testb	%al, %al
	je	.L3
	movl	8(%ebp), %eax
	movl	-12(%ebp), %edx
	movl	%edx, 4(%eax)
	movl	8(%ebp), %eax
	movl	-12(%ebp), %edx
	movl	%edx, 8(%eax)
	jmp	.L4
.L3:
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	movl	-12(%ebp), %edx
	movl	%edx, 4(%eax)
	movl	8(%ebp), %eax
	movl	-12(%ebp), %edx
	movl	%edx, 8(%eax)
.L4:
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	leal	1(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, (%eax)
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE1:
	.size	AddToList, .-AddToList
	.globl	RemoveFromList
	.type	RemoveFromList, @function
RemoveFromList:
.LFB2:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	ListIsEmpty
	xorl	$1, %eax
	testb	%al, %al
	je	.L5
	movl	8(%ebp), %eax
	movl	4(%eax), %eax
	movl	%eax, -12(%ebp)
	movl	$0, -16(%ebp)
	movl	-12(%ebp), %eax
	movl	(%eax), %eax
	cmpl	12(%ebp), %eax
	jne	.L12
	movl	-12(%ebp), %eax
	movl	%eax, -16(%ebp)
	movl	-12(%ebp), %eax
	movl	4(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 4(%eax)
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	leal	-1(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, (%eax)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	free
	jmp	.L5
.L11:
	movl	-12(%ebp), %eax
	movl	4(%eax), %eax
	movl	(%eax), %eax
	cmpl	12(%ebp), %eax
	jne	.L9
	movl	-12(%ebp), %eax
	movl	4(%eax), %eax
	movl	%eax, -16(%ebp)
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	cmpl	-16(%ebp), %eax
	jne	.L10
	movl	8(%ebp), %eax
	movl	-12(%ebp), %edx
	movl	%edx, 8(%eax)
.L10:
	movl	-16(%ebp), %eax
	movl	4(%eax), %edx
	movl	-12(%ebp), %eax
	movl	%edx, 4(%eax)
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	leal	-1(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, (%eax)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	free
	jmp	.L5
.L9:
	movl	-12(%ebp), %eax
	movl	4(%eax), %eax
	movl	%eax, -12(%ebp)
	jmp	.L8
.L12:
	nop
.L8:
	movl	-12(%ebp), %eax
	movl	4(%eax), %eax
	testl	%eax, %eax
	jne	.L11
.L5:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE2:
	.size	RemoveFromList, .-RemoveFromList
	.globl	ClearList
	.type	ClearList, @function
ClearList:
.LFB3:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	ListIsEmpty
	xorl	$1, %eax
	testb	%al, %al
	je	.L13
	movl	8(%ebp), %eax
	movl	4(%eax), %eax
	movl	%eax, -12(%ebp)
	movl	$0, -16(%ebp)
	jmp	.L15
.L16:
	movl	-12(%ebp), %eax
	movl	%eax, -16(%ebp)
	movl	-12(%ebp), %eax
	movl	4(%eax), %eax
	movl	%eax, -12(%ebp)
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	leal	-1(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, (%eax)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	free
.L15:
	cmpl	$0, -12(%ebp)
	jne	.L16
.L13:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE3:
	.size	ClearList, .-ClearList
	.globl	InitializeList
	.type	InitializeList, @function
InitializeList:
.LFB4:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	movl	8(%ebp), %eax
	movl	$0, (%eax)
	movl	8(%ebp), %eax
	movl	$0, 4(%eax)
	movl	8(%ebp), %eax
	movl	$0, 8(%eax)
	popl	%ebp
	.cfi_def_cfa 4, 4
	.cfi_restore 5
	ret
	.cfi_endproc
.LFE4:
	.size	InitializeList, .-InitializeList
	.globl	QueueIsEmpty
	.type	QueueIsEmpty, @function
QueueIsEmpty:
.LFB5:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	setle	%al
	popl	%ebp
	.cfi_def_cfa 4, 4
	.cfi_restore 5
	ret
	.cfi_endproc
.LFE5:
	.size	QueueIsEmpty, .-QueueIsEmpty
	.globl	AddToQueue
	.type	AddToQueue, @function
AddToQueue:
.LFB6:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$44, %esp
	movl	$1080, (%esp)
	.cfi_offset 3, -20
	.cfi_offset 6, -16
	.cfi_offset 7, -12
	call	malloc
	movl	%eax, -28(%ebp)
	movl	-28(%ebp), %eax
	movl	%eax, %edx
	leal	12(%ebp), %ebx
	movl	$269, %eax
	movl	%edx, %edi
	movl	%ebx, %esi
	movl	%eax, %ecx
	rep movsl
	movl	-28(%ebp), %eax
	movl	$0, 1076(%eax)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	QueueIsEmpty
	testb	%al, %al
	je	.L20
	movl	8(%ebp), %eax
	movl	-28(%ebp), %edx
	movl	%edx, 4(%eax)
	movl	8(%ebp), %eax
	movl	-28(%ebp), %edx
	movl	%edx, 8(%eax)
	jmp	.L21
.L20:
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	movl	-28(%ebp), %edx
	movl	%edx, 1076(%eax)
	movl	8(%ebp), %eax
	movl	-28(%ebp), %edx
	movl	%edx, 8(%eax)
.L21:
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	leal	1(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, (%eax)
	addl	$44, %esp
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
.LFE6:
	.size	AddToQueue, .-AddToQueue
	.section	.rodata
.LC0:
	.string	"Queue is empty!"
	.text
	.globl	GetFromQueue
	.type	GetFromQueue, @function
GetFromQueue:
.LFB7:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$1116, %esp
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	.cfi_offset 3, -20
	.cfi_offset 6, -16
	.cfi_offset 7, -12
	call	QueueIsEmpty
	xorl	$1, %eax
	testb	%al, %al
	je	.L23
	movl	12(%ebp), %eax
	movl	4(%eax), %eax
	movl	%eax, -28(%ebp)
	movl	-28(%ebp), %eax
	movl	1076(%eax), %edx
	movl	12(%ebp), %eax
	movl	%edx, 4(%eax)
	movl	12(%ebp), %eax
	movl	(%eax), %eax
	leal	-1(%eax), %edx
	movl	12(%ebp), %eax
	movl	%edx, (%eax)
	movl	-28(%ebp), %eax
	leal	-1104(%ebp), %edx
	movl	%eax, %ebx
	movl	$269, %eax
	movl	%edx, %edi
	movl	%ebx, %esi
	movl	%eax, %ecx
	rep movsl
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	free
	movl	8(%ebp), %eax
	movl	%eax, %edx
	leal	-1104(%ebp), %ebx
	movl	$269, %eax
	movl	%edx, %edi
	movl	%ebx, %esi
	movl	%eax, %ecx
	rep movsl
	movl	8(%ebp), %eax
	addl	$1116, %esp
	popl	%ebx
	.cfi_remember_state
	.cfi_restore 3
	popl	%esi
	.cfi_restore 6
	popl	%edi
	.cfi_restore 7
	popl	%ebp
	.cfi_def_cfa 4, 4
	.cfi_restore 5
	ret	$4
.L23:
	.cfi_restore_state
	movl	$.LC0, (%esp)
	call	puts
	movl	$-1, (%esp)
	call	exit
	.cfi_endproc
.LFE7:
	.size	GetFromQueue, .-GetFromQueue
	.globl	InitializeQueue
	.type	InitializeQueue, @function
InitializeQueue:
.LFB8:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	movl	8(%ebp), %eax
	movl	$0, (%eax)
	movl	8(%ebp), %eax
	movl	$0, 4(%eax)
	movl	8(%ebp), %eax
	movl	$0, 8(%eax)
	popl	%ebp
	.cfi_def_cfa 4, 4
	.cfi_restore 5
	ret
	.cfi_endproc
.LFE8:
	.size	InitializeQueue, .-InitializeQueue
	.globl	MAX_EPOLL_EVENTS
	.section	.rodata
	.align 4
	.type	MAX_EPOLL_EVENTS, @object
	.size	MAX_EPOLL_EVENTS, 4
MAX_EPOLL_EVENTS:
	.long	1000
	.globl	BACK_LOG
	.align 4
	.type	BACK_LOG, @object
	.size	BACK_LOG, 4
BACK_LOG:
	.long	1000
	.comm	list_mutex,24,4
	.comm	pipe_mutex,24,4
	.comm	message_count,4,4
	.comm	semid,4,4
	.data
	.align 2
	.type	sop_lock, @object
	.size	sop_lock, 6
sop_lock:
	.value	0
	.value	-1
	.value	0
	.align 2
	.type	sop_unlock, @object
	.size	sop_unlock, 6
sop_unlock:
	.value	0
	.value	1
	.value	0
	.globl	thr_id
	.bss
	.align 4
	.type	thr_id, @object
	.size	thr_id, 4
thr_id:
	.zero	4
	.section	.rodata
.LC1:
	.string	"["
.LC2:
	.string	"]: "
.LC3:
	.string	"Recieved message[%d]: %s\n"
	.text
	.globl	PrintMessage
	.type	PrintMessage, @function
PrintMessage:
.LFB9:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%edi
	pushl	%ebx
	subl	$288, %esp
	movl	$.LC1, %edx
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
	movl	$.LC2, %ebx
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
	movl	$.LC3, %eax
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
.LFE9:
	.size	PrintMessage, .-PrintMessage
	.section	.rodata
.LC4:
	.string	"Thread finished"
	.text
	.globl	Broadcast
	.type	Broadcast, @function
Broadcast:
.LFB10:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$2204, %esp
	movl	thr_id, %eax
	movl	%eax, -36(%ebp)
	addl	$1, %eax
	movl	%eax, thr_id
	movl	8(%ebp), %eax
	movl	%eax, -40(%ebp)
.L36:
	movl	semid, %eax
	movl	$1, 8(%esp)
	movl	$sop_lock, 4(%esp)
	movl	%eax, (%esp)
	.cfi_offset 3, -20
	.cfi_offset 6, -16
	.cfi_offset 7, -12
	call	semop
	movl	$pipe_mutex, (%esp)
	call	pthread_mutex_lock
	leal	-2200(%ebp), %eax
	movl	-40(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	GetFromQueue
	subl	$4, %esp
	leal	-2200(%ebp), %eax
	leal	-1124(%ebp), %edx
	movl	%eax, %ebx
	movl	$269, %eax
	movl	%edx, %edi
	movl	%ebx, %esi
	movl	%eax, %ecx
	rep movsl
	movl	$pipe_mutex, (%esp)
	call	pthread_mutex_unlock
	movzbl	-52(%ebp), %eax
	testb	%al, %al
	je	.L27
	movl	$.LC4, (%esp)
	call	puts
	nop
	movl	$0, %eax
	leal	-12(%ebp), %esp
	popl	%ebx
	.cfi_remember_state
	.cfi_restore 3
	popl	%esi
	.cfi_restore 6
	popl	%edi
	.cfi_restore 7
	popl	%ebp
	.cfi_def_cfa 4, 4
	.cfi_restore 5
	ret
.L27:
	.cfi_restore_state
	movl	$list_mutex, (%esp)
	call	pthread_mutex_lock
	movl	-1120(%ebp), %eax
	movl	4(%eax), %eax
	movl	%eax, -28(%ebp)
	movl	$0, -44(%ebp)
	jmp	.L29
.L35:
	movl	-28(%ebp), %eax
	movl	(%eax), %edx
	movl	-1124(%ebp), %eax
	cmpl	%eax, %edx
	je	.L30
	movl	$0, -32(%ebp)
	jmp	.L31
.L34:
	movl	-32(%ebp), %eax
	movl	$1060, %edx
	movl	%edx, %ecx
	subl	%eax, %ecx
	movl	-32(%ebp), %eax
	imull	$1060, %eax, %eax
	leal	-1124(%ebp), %edx
	addl	$8, %edx
	addl	%eax, %edx
	movl	-28(%ebp), %eax
	movl	(%eax), %eax
	movl	$16384, 12(%esp)
	movl	%ecx, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	send
	movl	%eax, -48(%ebp)
	cmpl	$0, -48(%ebp)
	jle	.L32
	movl	-48(%ebp), %eax
	addl	%eax, -32(%ebp)
	jmp	.L31
.L32:
	cmpl	$0, -48(%ebp)
	je	.L37
.L33:
	cmpl	$0, -48(%ebp)
	jns	.L31
	call	__errno_location
	movl	(%eax), %eax
	cmpl	$11, %eax
	jne	.L38
.L31:
	movl	-32(%ebp), %eax
	cmpl	$1059, %eax
	jbe	.L34
	jmp	.L30
.L37:
	nop
	jmp	.L30
.L38:
	nop
.L30:
	movl	-28(%ebp), %eax
	movl	4(%eax), %eax
	movl	%eax, -28(%ebp)
.L29:
	cmpl	$0, -28(%ebp)
	jne	.L35
	movl	$list_mutex, (%esp)
	call	pthread_mutex_unlock
	jmp	.L36
	.cfi_endproc
.LFE10:
	.size	Broadcast, .-Broadcast
	.section	.rodata
.LC5:
	.string	"Server started"
.LC6:
	.string	"Commands: stop, inf"
.LC7:
	.string	"Socket creation error\n"
.LC8:
	.string	"Binding error"
.LC9:
	.string	"Epoll fd add"
.LC10:
	.string	"Semaphore creation failed\n"
.LC11:
	.string	"Creating thread %d\n"
.LC12:
	.string	"Thread creation error!"
	.align 4
.LC13:
	.string	"========================Connected clients========================"
.LC14:
	.string	"client %d\n"
.LC15:
	.string	"accept"
.LC16:
	.string	"Event array is full"
	.align 4
.LC17:
	.string	"bytes_read: %d bytes_left: %d\n"
.LC18:
	.string	"deleing client: %d \n"
.LC19:
	.string	"Read %d of %d bytes.\n"
.LC20:
	.string	"Printing finished"
.LC21:
	.string	"Creating finish tasks"
.LC22:
	.string	"Finish tasks created"
.LC23:
	.string	"All threads joined"
.LC24:
	.string	"All sockets closed"
.LC25:
	.string	"Server stopped"
	.text
	.globl	Server
	.type	Server, @function
Server:
.LFB11:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$3452, %esp
	movl	%esp, %eax
	movl	%eax, -2364(%ebp)
	movl	$.LC5, (%esp)
	.cfi_offset 3, -20
	.cfi_offset 6, -16
	.cfi_offset 7, -12
	call	puts
	movl	$.LC6, (%esp)
	call	puts
	movl	8(%ebp), %eax
	movl	(%eax), %edx
	movl	%edx, -128(%ebp)
	movl	4(%eax), %edx
	movl	%edx, -124(%ebp)
	movl	8(%eax), %eax
	movl	%eax, -120(%ebp)
	movl	-128(%ebp), %eax
	movl	%eax, -56(%ebp)
	movl	$0, 8(%esp)
	movl	$1, 4(%esp)
	movl	$2, (%esp)
	call	socket
	movl	%eax, -60(%ebp)
	cmpl	$0, -60(%ebp)
	jns	.L40
	movl	$.LC7, (%esp)
	call	perror
	movl	$1, (%esp)
	call	exit
.L40:
	movl	$2048, 8(%esp)
	movl	$4, 4(%esp)
	movl	-60(%ebp), %eax
	movl	%eax, (%esp)
	call	fcntl
	movw	$2, -116(%ebp)
	movl	$3425, (%esp)
	call	htons
	movw	%ax, -114(%ebp)
	movl	$0, -112(%ebp)
	movl	$16, 8(%esp)
	leal	-116(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-60(%ebp), %eax
	movl	%eax, (%esp)
	call	bind
	testl	%eax, %eax
	jns	.L41
	movl	$.LC8, (%esp)
	call	perror
	movl	$2, (%esp)
	call	exit
.L41:
	movl	BACK_LOG, %eax
	movl	%eax, 4(%esp)
	movl	-60(%ebp), %eax
	movl	%eax, (%esp)
	call	listen
	leal	-140(%ebp), %eax
	movl	%eax, (%esp)
	call	InitializeList
	movl	MAX_EPOLL_EVENTS, %eax
	movl	%eax, (%esp)
	call	epoll_create
	movl	%eax, -64(%ebp)
	movl	$3, -152(%ebp)
	movl	-60(%ebp), %eax
	movl	%eax, -148(%ebp)
	leal	-152(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	-60(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$1, 4(%esp)
	movl	-64(%ebp), %eax
	movl	%eax, (%esp)
	call	epoll_ctl
	testl	%eax, %eax
	jns	.L42
	movl	$.LC9, (%esp)
	call	perror
	movl	$0, %eax
	jmp	.L43
.L42:
	movl	MAX_EPOLL_EVENTS, %eax
	subl	$1, %eax
	movl	%eax, -68(%ebp)
	movl	MAX_EPOLL_EVENTS, %eax
	movl	$0, %edx
	imull	$96, %edx, %ebx
	imull	$0, %eax, %ecx
	addl	%ecx, %ebx
	movl	$96, %ecx
	mull	%ecx
	leal	(%ebx,%edx), %ecx
	movl	%ecx, %edx
	movl	MAX_EPOLL_EVENTS, %eax
	movl	%eax, %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$2, %eax
	movl	MAX_EPOLL_EVENTS, %eax
	movl	$0, %edx
	imull	$96, %edx, %ebx
	imull	$0, %eax, %ecx
	addl	%ecx, %ebx
	movl	$96, %ecx
	mull	%ecx
	leal	(%ebx,%edx), %ecx
	movl	%ecx, %edx
	movl	MAX_EPOLL_EVENTS, %eax
	movl	%eax, %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$2, %eax
	leal	15(%eax), %edx
	movl	$16, %eax
	subl	$1, %eax
	addl	%edx, %eax
	movl	$16, -2368(%ebp)
	movl	$0, %edx
	divl	-2368(%ebp)
	imull	$16, %eax, %eax
	subl	%eax, %esp
	leal	1080(%esp), %eax
	addl	$15, %eax
	shrl	$4, %eax
	sall	$4, %eax
	movl	%eax, -72(%ebp)
	movl	$1, -28(%ebp)
	movl	$950, 8(%esp)
	movl	$1, 4(%esp)
	movl	$0, (%esp)
	call	semget
	movl	%eax, semid
	movl	semid, %eax
	cmpl	$-1, %eax
	jne	.L44
	movl	$.LC10, (%esp)
	call	perror
	movl	$1, (%esp)
	call	exit
.L44:
	movl	-56(%ebp), %eax
	sall	$2, %eax
	movl	%eax, (%esp)
	call	malloc
	movl	%eax, -76(%ebp)
	movl	$0, -32(%ebp)
	jmp	.L45
.L48:
	movl	-120(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	je	.L46
	movl	$.LC11, %eax
	movl	-32(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	printf
.L46:
	movl	-32(%ebp), %eax
	sall	$2, %eax
	addl	-76(%ebp), %eax
	leal	-196(%ebp), %edx
	movl	%edx, 12(%esp)
	movl	$Broadcast, 8(%esp)
	movl	$0, 4(%esp)
	movl	%eax, (%esp)
	call	pthread_create
	movl	%eax, -80(%ebp)
	cmpl	$0, -80(%ebp)
	je	.L47
	movl	$.LC12, (%esp)
	call	puts
.L47:
	addl	$1, -32(%ebp)
.L45:
	movl	-32(%ebp), %eax
	cmpl	-56(%ebp), %eax
	jl	.L48
	jmp	.L49
.L70:
	movl	MAX_EPOLL_EVENTS, %edx
	movl	-72(%ebp), %eax
	movl	$1000, 12(%esp)
	movl	%edx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	-64(%ebp), %eax
	movl	%eax, (%esp)
	call	epoll_wait
	movl	%eax, -84(%ebp)
	cmpl	$0, -84(%ebp)
	jle	.L80
.L50:
	movl	-120(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	je	.L51
	movl	$list_mutex, (%esp)
	call	pthread_mutex_lock
	movl	$.LC13, (%esp)
	call	puts
	movl	-136(%ebp), %eax
	movl	%eax, -36(%ebp)
	jmp	.L52
.L53:
	movl	-36(%ebp), %eax
	movl	(%eax), %edx
	movl	$.LC14, %eax
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	printf
	movl	-36(%ebp), %eax
	movl	4(%eax), %eax
	movl	%eax, -36(%ebp)
.L52:
	cmpl	$0, -36(%ebp)
	jne	.L53
	movl	$list_mutex, (%esp)
	call	pthread_mutex_unlock
.L51:
	movl	$0, -40(%ebp)
	jmp	.L54
.L69:
	movl	-72(%ebp), %ecx
	movl	-40(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$2, %eax
	addl	%ecx, %eax
	addl	$4, %eax
	movl	(%eax), %eax
	cmpl	-60(%ebp), %eax
	jne	.L55
	movl	$16, -156(%ebp)
	leal	-156(%ebp), %eax
	movl	%eax, 8(%esp)
	leal	-184(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-60(%ebp), %eax
	movl	%eax, (%esp)
	call	accept
	movl	%eax, -88(%ebp)
	cmpl	$0, -88(%ebp)
	jns	.L56
	movl	$.LC15, (%esp)
	call	perror
	jmp	.L57
.L56:
	movl	MAX_EPOLL_EVENTS, %eax
	subl	$1, %eax
	cmpl	-28(%ebp), %eax
	jne	.L58
	movl	$.LC16, (%esp)
	call	puts
	movl	-88(%ebp), %eax
	movl	%eax, (%esp)
	call	close
	jmp	.L57
.L58:
	movl	$2048, 8(%esp)
	movl	$4, 4(%esp)
	movl	-88(%ebp), %eax
	movl	%eax, (%esp)
	call	fcntl
	movl	-88(%ebp), %eax
	movl	%eax, -164(%ebp)
	movl	$8193, -168(%ebp)
	leal	-168(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	-88(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$1, 4(%esp)
	movl	-64(%ebp), %eax
	movl	%eax, (%esp)
	call	epoll_ctl
	movl	$list_mutex, (%esp)
	call	pthread_mutex_lock
	movl	-88(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-140(%ebp), %eax
	movl	%eax, (%esp)
	call	AddToList
	movl	$list_mutex, (%esp)
	call	pthread_mutex_unlock
	addl	$1, -28(%ebp)
	jmp	.L57
.L55:
	movl	-72(%ebp), %ecx
	movl	-40(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$2, %eax
	addl	%ecx, %eax
	addl	$4, %eax
	movl	(%eax), %eax
	movl	%eax, -92(%ebp)
	movl	-72(%ebp), %ecx
	movl	-40(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$2, %eax
	addl	%ecx, %eax
	movl	(%eax), %eax
	andl	$1, %eax
	testb	%al, %al
	je	.L59
	movl	$0, -44(%ebp)
	movl	$1060, -48(%ebp)
	jmp	.L60
.L64:
	movl	-48(%ebp), %eax
	movl	-44(%ebp), %edx
	leal	-1276(%ebp), %ecx
	addl	%ecx, %edx
	movl	$256, 12(%esp)
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	-92(%ebp), %eax
	movl	%eax, (%esp)
	call	recv
	movl	%eax, -96(%ebp)
	cmpl	$0, -96(%ebp)
	jle	.L61
	movl	-96(%ebp), %eax
	addl	%eax, -44(%ebp)
	movl	-96(%ebp), %eax
	subl	%eax, -48(%ebp)
	movl	-120(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	je	.L61
	movl	$.LC17, %eax
	movl	-48(%ebp), %edx
	movl	%edx, 8(%esp)
	movl	-44(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	printf
.L61:
	cmpl	$0, -96(%ebp)
	jne	.L60
	leal	-168(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	-92(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$2, 4(%esp)
	movl	-64(%ebp), %eax
	movl	%eax, (%esp)
	call	epoll_ctl
	subl	$1, -28(%ebp)
	movl	$list_mutex, (%esp)
	call	pthread_mutex_lock
	movl	-120(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	je	.L62
	movl	$.LC18, %eax
	movl	-92(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	printf
.L62:
	movl	-92(%ebp), %eax
	movl	%eax, (%esp)
	call	close
	movl	-92(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-140(%ebp), %eax
	movl	%eax, (%esp)
	call	RemoveFromList
	movl	$list_mutex, (%esp)
	call	pthread_mutex_unlock
	jmp	.L63
.L60:
	cmpl	$0, -48(%ebp)
	jle	.L63
	movl	-124(%ebp), %eax
	movzbl	(%eax), %eax
	xorl	$1, %eax
	testb	%al, %al
	jne	.L64
.L63:
	movl	-120(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	je	.L65
	movl	$.LC19, %eax
	movl	$1060, 8(%esp)
	movl	-44(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	printf
.L65:
	cmpl	$0, -48(%ebp)
	jg	.L81
.L66:
	movb	$0, -1280(%ebp)
	movl	-92(%ebp), %eax
	movl	%eax, -2352(%ebp)
	leal	-1276(%ebp), %eax
	leal	-2344(%ebp), %edx
	movl	%eax, %ebx
	movl	$265, %eax
	movl	%edx, %edi
	movl	%ebx, %esi
	movl	%eax, %ecx
	rep movsl
	movl	-44(%ebp), %eax
	movl	%eax, -1284(%ebp)
	leal	-140(%ebp), %eax
	movl	%eax, -2348(%ebp)
	movl	$pipe_mutex, (%esp)
	call	pthread_mutex_lock
	leal	4(%esp), %edx
	leal	-2352(%ebp), %ebx
	movl	$269, %eax
	movl	%edx, %edi
	movl	%ebx, %esi
	movl	%eax, %ecx
	rep movsl
	leal	-196(%ebp), %eax
	movl	%eax, (%esp)
	call	AddToQueue
	movl	message_count, %eax
	addl	$1, %eax
	movl	%eax, message_count
	movl	semid, %eax
	movl	$1, 8(%esp)
	movl	$sop_unlock, 4(%esp)
	movl	%eax, (%esp)
	call	semop
	movl	-120(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	je	.L67
	movl	%esp, %edx
	leal	-2344(%ebp), %ebx
	movl	$265, %eax
	movl	%edx, %edi
	movl	%ebx, %esi
	movl	%eax, %ecx
	rep movsl
	call	PrintMessage
	movl	$.LC20, (%esp)
	call	puts
.L67:
	movl	$pipe_mutex, (%esp)
	call	pthread_mutex_unlock
.L59:
	movl	-72(%ebp), %ecx
	movl	-40(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$2, %eax
	addl	%ecx, %eax
	movl	(%eax), %eax
	andl	$8192, %eax
	testl	%eax, %eax
	je	.L57
	leal	-168(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	-92(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$2, 4(%esp)
	movl	-64(%ebp), %eax
	movl	%eax, (%esp)
	call	epoll_ctl
	subl	$1, -28(%ebp)
	movl	$list_mutex, (%esp)
	call	pthread_mutex_lock
	movl	-120(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	je	.L68
	movl	$.LC18, %eax
	movl	-92(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	printf
.L68:
	movl	-92(%ebp), %eax
	movl	%eax, (%esp)
	call	close
	movl	-92(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-140(%ebp), %eax
	movl	%eax, (%esp)
	call	RemoveFromList
	movl	$list_mutex, (%esp)
	call	pthread_mutex_unlock
	jmp	.L57
.L81:
	nop
.L57:
	addl	$1, -40(%ebp)
.L54:
	movl	-40(%ebp), %eax
	cmpl	-84(%ebp), %eax
	jl	.L69
	jmp	.L49
.L80:
	nop
.L49:
	movl	-124(%ebp), %eax
	movzbl	(%eax), %eax
	xorl	$1, %eax
	testb	%al, %al
	jne	.L70
	movl	$.LC21, (%esp)
	call	puts
	movl	$0, -32(%ebp)
	jmp	.L71
.L72:
	movb	$1, -204(%ebp)
	movl	$pipe_mutex, (%esp)
	call	pthread_mutex_lock
	leal	4(%esp), %edx
	leal	-1276(%ebp), %ebx
	movl	$269, %eax
	movl	%edx, %edi
	movl	%ebx, %esi
	movl	%eax, %ecx
	rep movsl
	leal	-196(%ebp), %eax
	movl	%eax, (%esp)
	call	AddToQueue
	movl	semid, %eax
	movl	$1, 8(%esp)
	movl	$sop_unlock, 4(%esp)
	movl	%eax, (%esp)
	call	semop
	movl	$pipe_mutex, (%esp)
	call	pthread_mutex_unlock
	addl	$1, -32(%ebp)
.L71:
	movl	-32(%ebp), %eax
	cmpl	-56(%ebp), %eax
	jl	.L72
	movl	$.LC22, (%esp)
	call	puts
	movl	$0, -32(%ebp)
	jmp	.L73
.L74:
	movl	-32(%ebp), %eax
	sall	$2, %eax
	addl	-76(%ebp), %eax
	movl	(%eax), %eax
	leal	-200(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	pthread_join
	addl	$1, -32(%ebp)
.L73:
	movl	-32(%ebp), %eax
	cmpl	-56(%ebp), %eax
	jl	.L74
	movl	$.LC23, (%esp)
	call	puts
	movl	$list_mutex, (%esp)
	call	pthread_mutex_lock
	movl	-136(%ebp), %eax
	movl	%eax, -52(%ebp)
	jmp	.L75
.L76:
	movl	-52(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, -100(%ebp)
	leal	-168(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	-100(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$2, 4(%esp)
	movl	-64(%ebp), %eax
	movl	%eax, (%esp)
	call	epoll_ctl
	subl	$1, -28(%ebp)
	movl	-100(%ebp), %eax
	movl	%eax, (%esp)
	call	close
	movl	-52(%ebp), %eax
	movl	4(%eax), %eax
	movl	%eax, -52(%ebp)
.L75:
	cmpl	$0, -52(%ebp)
	jne	.L76
	movl	$list_mutex, (%esp)
	call	pthread_mutex_unlock
	movl	-60(%ebp), %eax
	movl	%eax, (%esp)
	call	close
	movl	$.LC24, (%esp)
	call	puts
	movl	-76(%ebp), %eax
	movl	%eax, (%esp)
	call	free
	leal	-140(%ebp), %eax
	movl	%eax, (%esp)
	call	ClearList
	movl	$.LC25, (%esp)
	call	puts
	movl	$0, %ebx
	movl	$1, %eax
.L43:
	movl	-2364(%ebp), %esp
	testl	%eax, %eax
	je	.L79
	movl	%ebx, %eax
	jmp	.L39
.L79:
.L39:
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
.LFE11:
	.size	Server, .-Server
	.section	.rodata
.LC26:
	.string	"Server thread creation error!"
.LC27:
	.string	"stop"
.LC28:
	.string	"inf"
	.text
	.globl	main
	.type	main, @function
main:
.LFB12:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%edi
	pushl	%esi
	andl	$-16, %esp
	subl	$64, %esp
	movl	$0, 4(%esp)
	movl	$list_mutex, (%esp)
	.cfi_offset 6, -16
	.cfi_offset 7, -12
	call	pthread_mutex_init
	movl	$0, 4(%esp)
	movl	$pipe_mutex, (%esp)
	call	pthread_mutex_init
	movb	$0, 43(%esp)
	movb	$0, 42(%esp)
	leal	43(%esp), %eax
	movl	%eax, 48(%esp)
	leal	42(%esp), %eax
	movl	%eax, 52(%esp)
	movl	12(%ebp), %eax
	addl	$4, %eax
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	atoi
	movl	%eax, 44(%esp)
	leal	44(%esp), %eax
	movl	%eax, 12(%esp)
	movl	$Server, 8(%esp)
	movl	$0, 4(%esp)
	leal	36(%esp), %eax
	movl	%eax, (%esp)
	call	pthread_create
	movl	%eax, 60(%esp)
	cmpl	$0, 60(%esp)
	je	.L88
	movl	$.LC26, (%esp)
	call	puts
	jmp	.L88
.L87:
	movl	stdin, %eax
	movl	%eax, 8(%esp)
	movl	$5, 4(%esp)
	leal	27(%esp), %eax
	movl	%eax, (%esp)
	call	fgets
	movl	$10, 4(%esp)
	leal	27(%esp), %eax
	movl	%eax, (%esp)
	call	strchr
	movl	%eax, 56(%esp)
	cmpl	$0, 56(%esp)
	je	.L85
	movl	56(%esp), %eax
	movb	$0, (%eax)
.L85:
	leal	27(%esp), %eax
	movl	%eax, %edx
	movl	$.LC27, %eax
	movl	$5, %ecx
	movl	%edx, %esi
	movl	%eax, %edi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L86
	movb	$1, 43(%esp)
	jmp	.L84
.L86:
	leal	27(%esp), %eax
	movl	%eax, %edx
	movl	$.LC28, %eax
	movl	$4, %ecx
	movl	%edx, %esi
	movl	%eax, %edi
	repz cmpsb
	seta	%dl
	setb	%al
	movl	%edx, %ecx
	subb	%al, %cl
	movl	%ecx, %eax
	movsbl	%al, %eax
	testl	%eax, %eax
	jne	.L84
	movzbl	42(%esp), %eax
	xorl	$1, %eax
	movzbl	%al, %eax
	movb	%al, 42(%esp)
	jmp	.L84
.L88:
	nop
.L84:
	movzbl	43(%esp), %eax
	xorl	$1, %eax
	testb	%al, %al
	jne	.L87
	movl	36(%esp), %eax
	leal	32(%esp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	pthread_join
	movl	$list_mutex, (%esp)
	call	pthread_mutex_destroy
	movl	$pipe_mutex, (%esp)
	call	pthread_mutex_destroy
	movl	$0, %eax
	leal	-8(%ebp), %esp
	popl	%esi
	.cfi_restore 6
	popl	%edi
	.cfi_restore 7
	popl	%ebp
	.cfi_def_cfa 4, 4
	.cfi_restore 5
	ret
	.cfi_endproc
.LFE12:
	.size	main, .-main
	.ident	"GCC: (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3"
	.section	.note.GNU-stack,"",@progbits
