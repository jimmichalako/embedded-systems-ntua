.text
.align 4
.global strcmp
.type strcmp, %function

@ Function inputs:
@ r0: address of the first string (str1)
@ r1: address of the second string (str2)
strcmp:
    mov r5, #0          @ Default result is 0 (strings are equal)
compare_loop:
    ldrb r3, [r0], #1   @ Load a character from str1 and advance pointer
    ldrb r4, [r1], #1   @ Load a character from str2 and advance pointer
    cmp r3, r4          @ Compare the characters from str1 and str2
    bne determine_order @ If not equal, decide which string is lexicographically smaller
    cmp r3, #0          @ Check if we’ve reached the end of both strings
    beq finish          @ If both ended simultaneously, strings are equal
    b compare_loop      @ Otherwise, continue comparing the next characters
determine_order:
    movlt r5, #-1       @ If str1 < str2, set result to -1
    movgt r5, #1        @ If str1 > str2, set result to 1
finish:
    mov r0, r5          @ Place the result into r0 for returning
    bx lr               @ Return to the caller