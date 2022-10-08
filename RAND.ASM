model tiny
codeseg
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
  dw  command_0         ; 0   initialization                [both]
  dw  command_unknown   ; 1   media check                   [block]
  dw  command_unknown   ; 2   build bfb                     [block]
  dw  command_unknown   ; 3   ioctl input                   [both]
  dw  command_4         ; 4   input (read)                  [both]
  dw  command_unknown   ; 5   nondestructive input no wait  [character]
  dw  command_unknown   ; 6   input status                  [character]
  dw  command_unknown   ; 7   input flush                   [character]
  dw  command_unknown   ; 8   output (write)                [both]
  dw  command_unknown   ; 9   output (write with verify)    [block]
  dw  command_unknown   ; 10  output status                 [character]
  dw  command_unknown   ; 11  output flush                  [character]
  dw  command_unknown   ; 12  ioctl output                  [both]
  dw  command_unknown   ; 13  device open                   [both]
  dw  command_unknown   ; 14  device close                  [both]
  dw  command_unknown   ; 15  removable media               [block]
  dw  command_unknown   ; 16
  dw  command_unknown   ; 17
  dw  command_unknown   ; 18
  dw  command_unknown   ; 19  generic ioctl request         [both]
  dw  command_unknown   ; 20
  dw  command_unknown   ; 21
  dw  command_unknown   ; 22
  dw  command_unknown   ; 23  get logical device            [block]
  dw  command_unknown   ; 24  set logical device            [block]

entry_strategy:
  mov   word ptr cs:[request_off], bx     ; save request pointer
  mov   word ptr cs:[request_seg], es     ; for use in entry_interrupt

  retf

entry_interrupt:
  pushf                                   ; save state
  push  ax                                ;  "
  push  bx                                ;  "
  push  dx                                ;  "
  push  di                                ;  "
  push  ds                                ;  "

  lds   bx, dword ptr cs:[request_off]    ; load request pointer into DS:BX

  mov   di, word ptr [bx + 2]             ; read command code
  cmp   di, 24                            ; is it greater than 24?
  ja    _command_unknown                  ; yes, jump forward

  shl   di, 1                             ; convert to table offset

  call  word ptr cs:[di + commands]       ; execute command handler
  jmp   short _done                       ; jump forward

_command_unknown:
  call  command_unknown                   ; handle command as unknown

_done:
  pop   ds                                ; revert state
  pop   di                                ;  "
  pop   dx                                ;  "
  pop   bx                                ;  "
  pop   ax                                ;  "
  popf                                    ;  "

  retf

command_unknown:
  mov   word ptr [bx + 3], 8103h          ; set status:
                                          ;   error:            8000h
                                          ;   done:             0100h
                                          ;   unknown command:  0003h

  ret

command_0:
  mov   word ptr [bx + 14], offset end_addr ; set ending address of
  mov   word ptr [bx + 16], cs              ; program resident code

  mov   word ptr [bx + 3], 0100h            ; set status done

  ret

command_4:
  push  di                                ; clobbers DI

  push  ds                                ; clobbers DS

  lds   di, dword ptr [bx + 14]           ; load output buffer into DS:DI
  mov   byte ptr [di], 'A'                ; write 'A' to output buffer

  pop   ds

  mov   word ptr [bx + 18], 1             ; set byte count to 1

  pop   di

  mov   word ptr [bx + 3], 0100h          ; set status done

  ret

end_addr:
end start
