.text
.align 4
.global strcat
.type strcat, %function

@ Function inputs:
@ r0: destination string (dst)
@ r1: source string (src)
strcat:
    mov r5, r0          @ Save the initial destination address in r5
find_end:
    ldrb r3, [r0], #1   @ Load a byte from the destination string and advance the pointer
    cmp r3, #0          @ Check if it's the null terminator
    bne find_end        @ Continue until the end of the destination string is reached
    sub r0, r0, #1      @ Step back to overwrite the null terminator with the source string
append_src:
    ldrb r4, [r1], #1   @ Load a byte from the source string and advance the source pointer
    strb r4, [r0], #1   @ Write the byte to the current position in the destination string
    cmp r4, #0          @ Check if it's the null terminator of the source string
    bne append_src      @ Continue until the source string ends
finish:
    mov r0, r5          @ Restore the original destination address to r0
    bx lr               @ Return to the caller