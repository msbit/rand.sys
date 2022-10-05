segment text
  org 0

start:
  dw  0ffffh,0ffffh
  dw  8000h             ; character device
  dw  entry_strategy
  dw  entry_interrupt
  db  'RAND$',0,0,0

request_off dw  0
request_seg dw  0
debug_msg   db  'rand',0dh,0ah,'$'

entry_strategy:
  mov   word ptr cs:[request_off], bx
  mov   word ptr cs:[request_seg], es

  retf

entry_interrupt:
  pushf
  push  ax
  push  bx
  push  dx
  push  ds

  mov   dx, offset debug_msg
  mov   ah, 9
  int   21h

  lds   bx, dword ptr cs:[request_off]

  ; If the initialization routine determines that it cannot set up the device
  ; and wants to terminate without using any memory, use the following
  ; procedure:
  mov   word ptr [bx + 14], 0   ; Set the ending address offset to 0
  mov   word ptr [bx + 16], cs  ; Set the ending address segment to CS

  pop   ds
  pop   dx
  pop   bx
  pop   ax
  popf

  retf

ends text
end start
