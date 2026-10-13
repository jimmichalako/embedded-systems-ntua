.text
.align 4
.global strcpy
.type strcpy, %function

@ Function inputs:
@ r0: destination buffer (dst)
@ r1: source string (src)
strcpy:
    mov r4, r0          @ Save the starting address of the destination buffer in r4
copy_loop:
    ldrb r3, [r1], #1   @ Read the next byte from the source string and move to the next position
    strb r3, [r0], #1   @ Write the byte to the destination buffer and move to the next position
    cmp r3, #0          @ Check if the byte is the null terminator
    bne copy_loop       @ If not, keep copying the next byte
finish:
    mov r0, r4          @ Restore the original destination address to r0 (return value)
    bx lr               @ Exit the function and return to the caller