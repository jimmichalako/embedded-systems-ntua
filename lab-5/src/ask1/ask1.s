.text
.syntax unified
.align 4
.global main
.type main, %function

main:
    push {ip, lr}

@ Loop Entry Point
loop:
    mov r4, #0          @ Initialize character counter
    mov r5, #10         @ Newline character for output

    @ Print Prompt
    mov r0, #1          @ stdout
    ldr r1, =prompt     @ Address of the prompt in memory
    mov r2, #prompt_len @ Length of the prompt
    mov r7, #4          @ write system call
    swi 0

    @ Read Input
    mov r0, #0          @ stdin
    ldr r1, =input_str  @ Address of input string in memory
    mov r2, #32         @ Read 32 characters + newline
    mov r7, #3          @ read system call
    swi 0

    @ Check for Exit Conditions
    cmp r0, #2          @ Could it be 'q\n' or 'Q\n'?
    bne convert
    ldrb r3, [r1]
    cmp r3, #81         @ Is it 'Q'?
    beq exit_program
    cmp r3, #113        @ Is it 'q'?
    beq exit_program

convert:
    ldrb r3, [r1]       @ Load current character
    add r4, #1          @ Increment character counter
    cmp r3, #10         @ Is it a newline?
    beq output          @ If newline, go to output

    @ Process Characters
    cmp r3, #48         @ Is it a digit? ('0')
    blt handle_next     @ If less than '0', handle other characters
    cmp r3, #57         @ Is it a digit? ('9')
    ble convert_digit   @ If in '0'-'9', process as digit

    cmp r3, #65         @ Is it uppercase? ('A')
    blt handle_next     @ If less than 'A', handle other characters
    cmp r3, #90         @ Is it uppercase? ('Z')
    ble to_lowercase    @ If in 'A'-'Z', convert to lowercase

    cmp r3, #97         @ Is it lowercase? ('a')
    blt handle_next     @ If less than 'a', handle other characters
    cmp r3, #122        @ Is it lowercase? ('z')
    ble to_uppercase       @ If in 'a'-'z', convert to uppercase

handle_next:
    strb r3, [r1], #1   @ Store character as-is and move to next
    b final_check       @ Go to final check

convert_digit:
    cmp r3, #53         @ Check if digit < 5
    addlt r3, #5        @ Add 5 if less than 5
    subge r3, #5        @ Subtract 5 if >= 5
    strb r3, [r1], #1   @ Store transformed digit and move to next
    b final_check

to_uppercase:
    sub r3, r3, #32     @ Convert lowercase to uppercase
    strb r3, [r1], #1   @ Store transformed character and move to next
    b final_check

to_lowercase:
    add r3, r3, #32     @ Convert uppercase to lowercase
    strb r3, [r1], #1   @ Store transformed character and move to next
    b final_check

final_check:
    cmp r4, #32         @ Check if counter reached 32
    beq output          @ If 32 characters processed, go to output
    b convert           @ Otherwise, process the next character

output:
    cmp r4, #32
    strbeq r5, [r1, #-1] @ if 32nd character != '\n' make it '\n'
    mov r0, #1          @ stdout
    ldr r1, =input_str  @ Address of the string in memory
    mov r2, r4          @ Length of the string
    mov r7, #4          @ write system call
    swi 0
    cmp r4, #32
    beq flush_buffer
    b loop

flush_buffer:
    mov r7, #3          @ read system call
    mov r0, #2
    ldr r1,=input_str
    mov r2, #(1 << 30)  @ flush
    swi 0
    b loop

exit_program:
    pop {ip, pc}
    mov r7, #1          @ exit system call
    swi 0

.data
    prompt: .ascii "Input a string of up to 32 characters (Terminate with Q or q): "
    prompt_len = . - prompt  @ Length of the prompt
    input_str: .ascii "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0" @ Pre-allocate 32 bytes for input string, initialize them with null character '\0'
    input_len = . - input_str
