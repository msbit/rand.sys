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

commands:
  dw  command_0         ; 0   initialization
  dw  command_unknown   ; 1   media check
  dw  command_unknown   ; 2   build bfb
  dw  command_unknown   ; 3   ioctl input
  dw  command_unknown   ; 4   input (read)
  dw  command_unknown   ; 5   nondestructive input no wait
  dw  command_unknown   ; 6   input status
  dw  command_unknown   ; 7   input flush
  dw  command_unknown   ; 8   output (write)
  dw  command_unknown   ; 9   output (write with verify)
  dw  command_unknown   ; 10  output status
  dw  command_unknown   ; 11  output flush
  dw  command_unknown   ; 12  ioctl output
  dw  command_unknown   ; 13  device open
  dw  command_unknown   ; 14  device close
  dw  command_unknown   ; 15  removable media
  dw  command_unknown   ; 16
  dw  command_unknown   ; 17
  dw  command_unknown   ; 18
  dw  command_unknown   ; 19  generic ioctl request
  dw  command_unknown   ; 20
  dw  command_unknown   ; 21
  dw  command_unknown   ; 22
  dw  command_unknown   ; 23  get logical device
  dw  command_unknown   ; 24  set logical device

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

command_unknown:
  mov   word ptr [bx + 3], 8103h

  ret

command_0:
  mov   word ptr [bx + 14], offset ending_address
  mov   word ptr [bx + 16], cs

  mov   word ptr [bx + 3], 0100h

  ret

ending_address:
ends text
end start
