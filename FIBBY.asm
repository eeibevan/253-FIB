include emu8086.inc

; 25 - 46368 < 65,535
; 24 - 28,657   < 32,767



org 100h

jmp _main                       ; Jump Over Proc Definitions

; Prints n Fibonacci Numbers
; Params:
;  [Stack] Word n: Number of Fibonacci Numbers to Print [0 - 50]
; Registers Cleared: ax
print_fib proc
  mov bp, sp                    ; Start Our Stack Frame
  mov cx, [bp+2]                       ; Only Param, Number of Terms
  push bx                       ; Not A Standard Caller Save Register, Save To Restore At The End
  mov ax, 0                     ; Start 1st Term
  mov bx, 1                     ; Start 2nd Num

  cmp cx, 0                     ; Make Sure We Should Print Someting Before Printing First 0
  jz _end_fib                   ; Skip To The End If No Terms Were Requested
  PRINTN '0'                    ; Prints The First 0 To Get Us Started
  sub cx, 1                     ; Counts The Zero We Printed
  jz _end_fib                   ; End If The First 0 Was All That Was Requested

  cmp cx, 0                     ; Make Sure We Should Print Someting Before Printing The Second Term
  jz _end_fib                   ; Skip To The End If No Terms Were Requested
  PRINTN '1'                    ; Prints The Second Term To Get Us Started
  sub cx, 1                     ; Counts The One We Printed
  jz _end_fib                   ; End If The First Term Was All That Was Requested
_fib:
  add ax, bx                    ; ax (current) = ax (before last) + bx (last)
  jc _carry                     ; Print A Warning If We Carried
_post_step:
  call PRINT_NUM_UNS            ; Print Current Number, Will Have 'WARN: Carried: ' Before It If The Addition Carried
  xchg  ax, bx                  ; Switch ax (Now Last) To bx And bx (Now Before Last) to ax
                                  ; This Prevents The Need Of An Intermediate Register
  PRINTN                        ; Print Newline
  loop _fib                     ; Loop Until We Have All of The User Requested Fibonacci Numbers

_end_fib:
  pop bx                        ; Restore bx
  mov sp, bp
  ret

; Print A Warning For A Carry
; Returns To After Addition
_carry:
  PRINT 'WARN: Carried: '       ; Print Warning Before The Result
  jmp _post_step                ; Jump Back
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
