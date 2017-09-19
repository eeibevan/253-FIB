include emu8086.inc

org 100h

mov cx, 50 ; Num Fib Numbers
mov ax, 0  ; seed
mov bx, 1  ;seed

_fib:
    mov dx, ax
    add dx, bx
    
    jc _carried_message ;  Print An Error If We Carry
    
    mov ax, bx
    mov bx, dx
    call PRINT_NUM_UNS
    PUTC 10  ; '\n'
    PUTC 13  ; '\r'
    loop _fib

_carried_message:
    call PTHIS
    db 'ERROR: Carried At:',0
    mov ax, cx
    call PRINT_NUM_UNS
       

ret


   
DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS
DEFINE_PTHIS   
END
