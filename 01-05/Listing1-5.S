                #include "../aoaa.inc"

                .data
titleStr:       .asciz "Listing 01-05 S"
savedLR:        .dword 0   
hellowordStr:   .asciz "Hello world %d\n"
counter:        .dword 0

                .text

                .align 2

getTitle:
                lea x0, titleStr
                ret

asmMain:
//              Reserve space in the stack
                sub sp, sp, 64

//              Save the return address
                lea x0, savedLR
                str lr, [x0]

    printhw:
                lea x0, hellowordStr
                lea x1, counter
                ldr x1, [x1]
                str x1, [sp]
                bl  printf

    cond:                             // label just to set breakpoint easy
                lea x10, counter
                ldr x9, [x10]
                add x9, x9, #1
                str x9, [x10]
                
                cmp x9, #5
                B.LT    printhw

                lea x0, savedLR
                ldr lr, [x0]

//              Remove space from the stack
                add sp, sp, 64
                ret

