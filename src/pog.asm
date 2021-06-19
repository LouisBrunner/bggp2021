; From https://www.muppetlabs.com/~breadbox/software/tiny/teensy.html
; MS-DOS date: https://docs.microsoft.com/en-gb/windows/win32/api/winbase/nf-winbase-dosdatetimetofiletime?redirectedfrom=MSDN
; CRC-32: https://emn178.github.io/online-tools/crc32.html
bits 32

.ELF:
org     0x00010000

ehdr:           ; Elf32_Ehdr
  db 0x7F, "ELF"
  db 1, 1, 1, 0 ; e_ident
  dd 0
  dd 0
  dw 2          ; e_type
  dw 3          ; e_machine
  dd 1          ; e_version
  dd _start     ; e_entry
  dd phdr - $$  ; e_phoff
  dd 0          ; e_shoff
  dd 0          ; e_flags
  dw ehdrsize   ; e_ehsize
  dw phdrsize   ; e_phentsize
phdr:           ; Elf32_Phdr
  dd 1          ; e_phnum, p_type
                ; e_shentsize
  dd 0          ; e_shnum, p_offset
                ; e_shstrndx
ehdrsize equ $ - ehdr
  dd $$         ; p_vaddr
  dd $$         ; p_paddr
  dd filesize   ; p_filesz
  dd filesize   ; p_memsz
  dd 5          ; p_flags
  dd 0x1000     ; p_align
phdrsize equ $ - phdr

_start:
  xor eax,eax
  inc eax
  mov ebx,eax
  inc ebx
  int 0x80

filesize equ $ - $$

.ZIP:

filehdr:
  dd 0x04034b50 ; Local file header signature
  dw 0x14       ; Version needed to extract (minimum)
  dw 0          ; General purpose bit flag
  dw 0x8        ; Compression method (STORE = 0, DEFLATE = 8)
  ; File last modification time
  ; File last modification date
  ; CRC-32 of uncompressed data
  ; Compressed size (or 0xffffffff for ZIP64)
  ; Uncompressed size (or 0xffffffff for ZIP64)
  %include 'build/test.meta'
  dw fnsize1    ; File name length (n)
  dw efsize1    ; Extra field length (m)
filename1:
  %include 'build/test.name'
fnsize1 equ $ - filename1
extra_field1:
efsize1 equ $ - extra_field1
content:
  incbin 'build/test.deflated'

cdhdr:
  dd 0x02014b50 ; Central directory file header signature
  dw 0x314      ; Version made by
  dw 0x14       ; Version needed to extract (minimum)
  dw 0          ; General purpose bit flag
  dw 0x8        ; Compression method (STORE = 0, DEFLATE = 8)
  ; File last modification time
  ; File last modification date
  ; CRC-32 of uncompressed data
  ; Compressed size (or 0xffffffff for ZIP64)
  ; Uncompressed size (or 0xffffffff for ZIP64)
  %include 'build/test.meta'
  dw fnsize2    ; File name length (n)
  dw efsize2    ; Extra field length (m)
  dw fcsize     ; File comment length (k)
  dw 0          ; Disk number where file starts
  dw 0          ; Internal file attributes
  dd 0100664o << 16 ; External file attributes
  dd filehdr - $$ ; Relative offset of local file header
; This is the number of bytes between the start of the first disk on which the file occurs, and the start of the local file header.
filename2:      ; File name
  %include 'build/test.name'
fnsize2 equ $ - filename2
extra_field2:   ; Extra field
efsize2 equ $ - extra_field2
file_comment:   ; File comment
fcsize equ $ - file_comment

cdsize equ $ - cdhdr
eocd:
  dd 0x06054b50 ; End of central directory signature
  dw 0          ; Number of this disk (or 0xffff for ZIP64)
  dw 0          ; Disk where central directory starts (or 0xffff for ZIP64)
  dw 1          ; Number of central directory records on this disk (or 0xffff for ZIP64)
  dw 1          ; Total number of central directory records (or 0xffff for ZIP64)
  dd cdsize     ; Size of central directory (bytes) (or 0xffffffff for ZIP64)
  dd cdhdr - $$ ; Offset of start of central directory, relative to start of archive (or 0xffffffff for ZIP64)
  dw cmsize     ; Comment length (n)
comment:        ; Comment
cmsize equ $ - comment
