segment text
  org 0

start:
  dw  0ffffh,0ffffh
  dw  8000h             ; character device
  dw  entry_strategy
  dw  entry_interrupt
  db  'RAND$   '

request_off dw  0
request_seg dw  0
debug_msg   db  'rand',0dh,0ah,'$'

commands:
  dw  command_0     ; 0   initialization
  dw  command_none  ; 1   media check
  dw  command_none  ; 2   build bfb
  dw  command_none  ; 3   ioctl input
  dw  command_none  ; 4   input (read)
  dw  command_none  ; 5   nondestructive input no wait
  dw  command_none  ; 6   input status
  dw  command_none  ; 7   input flush
  dw  command_none  ; 8   output (write)
  dw  command_none  ; 9   output (write with verify)
  dw  command_none  ; 10  output status
  dw  command_none  ; 11  output flush
  dw  command_none  ; 12  ioctl output
  dw  command_none  ; 13  device open
  dw  command_none  ; 14  device close
  dw  command_none  ; 15  removable media
  dw  command_none  ; 16
  dw  command_none  ; 17
  dw  command_none  ; 18
  dw  command_none  ; 19  generic ioctl request
  dw  command_none  ; 20
  dw  command_none  ; 21
  dw  command_none  ; 22
  dw  command_none  ; 23  get logical device
  dw  command_none  ; 24  set logical device

entry_strategy:
  mov   word ptr cs:[request_off], bx
  mov   word ptr cs:[request_seg], es

  retf

entry_interrupt:
  pushf
  push  ax
  push  bx
  push  dx
  push  di
  push  ds

  lds   bx, dword ptr cs:[request_off]

  mov   di, word ptr [bx + 2]

  call  word ptr cs:[di + commands]

  pop   ds
  pop   di
  pop   dx
  pop   bx
  pop   ax
  popf

  retf

command_none:
  ret

command_0:
  mov   word ptr [bx + 14], offset ending_address
  mov   word ptr [bx + 16], cs

  mov   word ptr [bx + 3], 0100h

  ret

ending_address:
ends text
end start
