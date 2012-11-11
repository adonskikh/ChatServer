push ebp
mov esp,ebp
push ebx
xor ebx,ebx
mov ebx,eax
inc eax
int $0x80
call -0x24