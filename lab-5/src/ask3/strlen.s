.text
.align 4
.global strlen
.type strlen, %function

@ Function input:
@ r0: address of the string (str)
strlen:
    mov r3, #0          @ Initialize the length counter in r3
length_loop:
    ldrb r2, [r0], #1   @ Read the next character and advance the pointer
    cmp r2, #0          @ Check if the current character is the null terminator
    beq finish          @ If null terminator found, exit the loop
    add r3, r3, #1      @ Otherwise, increment the length counter
    b length_loop       @ Repeat for the next character
finish:
    mov r0, r3          @ Store the computed length in r0 as the return value
    bx lr               @ Return to the caller