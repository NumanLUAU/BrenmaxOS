; THE BRENMAX BOOTLOADER
[org 0x7c00]
start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00

    ; nice looking text
    mov ah, 0
    mov al, 3
    int 0x10

    print:
        mov ah, 0x0E
        mov si, Brenmax
    printloop:
        lodsb
        cmp al, 0
        je exit
        int 0x10
    jmp printloop

    exit:
        mov [BootDisk], dl
        mov ah, 86h
        mov cx, 0007h       
        mov dx, 0A120h      
        int 15h             
    ; scrn 1024x768+16b color 
    mov ax, 0x4F01
    mov cx, 0x4117     
    mov di, 0x7000      
    int 0x10
    mov ax, 0x4F02
    mov bx, 0x4117
    int 0x10

    startA20:
        mov ax, 0x2401     
        int 0x15
    Loadthesecs:
        mov dl, [BootDisk]
        mov bx, 0x7e00     
        mov cx, 0x0002     
        mov dh, 0          
        mov si, 10         
    load_loop:
        push si             
        mov ah, 0x02
        mov al, 20          
        int 0x13
        add bx, 10240       
        jnc .no_es_inc
        mov ax, es
        add ax, 0x1000     
        mov es, ax
    .no_es_inc:
        add cl, 20         
        cmp cl, 63         
        jbe .next_iter
        sub cl, 63
        inc dh              
    .next_iter:
        pop si             
        dec si
    jnz load_loop
    ;close jump
    cli
    lgdt [gdt_descriptor] ;lgbtq
    mov eax, cr0
    or eax, 1
    mov cr0, eax  
    jmp 0x08:border

    gdt_start: dq 0
    gdt_code:  dw 0xffff, 0x0, 0x9a00, 0x00cf
    gdt_data:  dw 0xffff, 0x0, 0x9200, 0x00cf
    gdt_end:
    gdt_descriptor:
        dw gdt_end - gdt_start - 1
        dd gdt_start

    Brenmax db "Brenmax is starting...", 0
    BootDisk db 0

    [bits 32]
    border:
        mov ax, 0x10
        mov ds, ax
        mov es, ax
        mov fs, ax
        mov gs, ax
        mov ss, ax
        mov esp, 0x01100000
        jmp 0x08:0x7e00

    times 510-($-$$) db 0
    dw 0xaa55

    [bits 32]
    incbin "kernel.bin"
    
times (200*512)-($-$$)+0x7c00 db 0