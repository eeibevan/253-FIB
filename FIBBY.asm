include emu8086.inc

org 100h

jmp _main                       ; Jump Over Proc Definitions

; Prints n Fibonacci Numbers
; Params:
;  [Stack] Word n: Number of Fibonacci Numbers to Print
; Registers: ax
print_fib proc
  mov bp, sp
  mov cx, [bp+2]                       ; Only Param, Number of Terms
  push bx                       ; Not A Caller Save Register, Restore At The End
  mov ax, 0                     ; Start 1st Term
  mov bx, 1                     ; Start 2nd Num

  cmp cx, 0                     ; Make Sure We Should Print Someting Before Printing First 0
  jz _end_fib                   ; Skip To The End If No Terms Were Requested
  PRINTN '0'                    ; Prints The First 0 To Get Us Started
  sub cx, 1                     ; Counts The Zero We Printed
  jz _end_fib                   ; End If The First 0 Was All That Was Requested
_fib:
  mov dx, ax
  add dx, bx
  jc _carry
_post_step:
  mov ax, bx
  mov bx, dx

  call PRINT_NUM_UNS
  PRINTN
  loop _fib
  jmp _end_fib                  ; Jump Over Carry Warning

_carry:
  PRINTN 'WARN: Carried'
  jmp _post_step                ; Jump Back

_end_fib:
  pop bx                        ; Restore bx
  mov sp, bp
  ret
  endp

_main:
  PRINT 'Enter Number of Fibonacci Terms:'
  call scan_num
  PRINTN
  push cx
  xor cx, cx
  call print_fib
  add sp, 2                     ; Clean Up Parameter
  ret


DEFINE_SCAN_NUM
DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS
DEFINE_PTHIS
END
