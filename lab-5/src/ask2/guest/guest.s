    .text
    .align 4                    @ Align instructions on a 4-byte boundary
    .global main
    .extern tcsetattr           @ External function

    @ Define syscall numbers at the start
    .equ SYSCALL_OPEN,  5
    .equ SYSCALL_READ,  3
    .equ SYSCALL_WRITE, 4
    .equ SYSCALL_CLOSE, 6
    .equ SYSCALL_EXIT,  1

main:

device_open:
    ldr r0, =dev_path           @ r0 = device path
    ldr r1, =#258               @ O_RDWR|O_NOCTTY
    mov r7, #SYSCALL_OPEN       @ open syscall
    swi 0                       @ invoke open
    mov r6, r0                  @ store fd in r6

setup_terminal:
    mov r0, r6                  @ r0 = fd
    ldr r2, =term_config        @ r2 = termios options
    mov r1, #0                  @ TCSANOW
    bl tcsetattr                @ set terminal attributes

read_data:
    mov r0, r6                  @ fd
    ldr r1, =input_data         @ buffer
    mov r2, #64                 @ size
    mov r7, #SYSCALL_READ       @ read syscall
    swi 0                       @ call read
    ldr r0, =input_data         @ r0 points to start of input

analyze_string:
    ldr r3, =freq_table         @ frequency table base
    mov r1, #0                  @ index for scanning input

char_loop:
    ldrb r2, [r0], #1           @ get char & increment pointer
    cmp r2, #10                 @ newline?
    beq done_analyze            @ end if newline
    ldrb r4, [r3, r2]           @ get current freq for char
    add r4, r4, #1              @ increment freq
    strb r4, [r3, r2]           @ store updated freq
    b char_loop                 @ continue loop

done_analyze:
    mov r1, #0                  @ reset index for freq search
    mov r0, #0                  @ max frequency
    ldr r3, =freq_table         @ frequency table
    strb r0, [r3, #32]          @ zero out space char frequency

freq_check:
    ldrb r2, [r3, r1]           @ freq at index r1
    cmp r0, r2                  @ compare with current max freq
    movlt r4, r1                @ if greater, record new max char
    movlt r0, r2                @ update max freq
    add r1, r1, #1              @ next index
    cmp r1, #256                @ done with all ASCII chars?
    beq freq_done
    b freq_check

freq_done:
    add r0, r0, #48             @ convert freq number to ASCII
    ldr r3, =output_data        @ result buffer
    strb r4, [r3]               @ output_data[0] = char
    strb r0, [r3, #2]           @ output_data[2] = freq as ASCII

write_result:
    mov r0, r6                  @ fd
    ldr r1, =output_data        @ result data
    ldr r2, =out_len            @ length
    mov r7, #SYSCALL_WRITE      @ write syscall
    swi 0                       @ call write

close_device:
    mov r0, r6                  @ fd
    mov r7, #SYSCALL_CLOSE      @ close syscall
    swi 0                       @ close device

exit_program:
    mov r0, #0                  @ exit code
    mov r7, #SYSCALL_EXIT       @ exit syscall
    swi 0                       @ exit

.data
term_config:
    .word 0x00000000            @ c_iflag
    .word 0x00000000            @ c_oflag
    .word 0x000008bd            @ c_cflag
    .word 0x00000002            @ c_lflag
    .byte 0x00                  @ c_line
    .word 0x00000000            @ c_cc[0-3]
    .word 0x00010000            @ c_cc[4-7]
    .word 0x00000000            @ c_cc[8-11]
    .word 0x00000000            @ c_cc[12-15]
    .word 0x00000000            @ c_cc[16-19]
    .word 0x00000000            @ c_cc[20-23]
    .word 0x00000000            @ c_cc[24-27]
    .word 0x00000000            @ c_cc[28-31]
    .byte 0x00                  @ padding
    .hword 0x0000               @ padding
    .word 0x0000000d            @ c_ispeed
    .word 0x0000000d            @ c_ospeed

dev_path: .asciz "/dev/ttyAMA0"

input_data:
    .asciz "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"

freq_table:                     @ Initialize freq_table with zeros
    .rept 256
    .byte 0
    .endr

output_data: .asciz "cccc\n"    @ placeholder output
out_len = . - output_data