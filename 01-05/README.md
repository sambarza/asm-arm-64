# Playing with Python inside LLDB

The program Listing1-5 print hello world 1000 times, doing this in debug you can force to run only 1 time:

`lldb Listing1-5`

inside lldb...

`b main`

```
(lldb) b main
Breakpoint 1: where = Listing1-5`main + 32 at c.cpp:18:19, address = 0x0000000100003f20
(lldb)
```

`run`

`disassemble -n asmMain -c 40`

```
(lldb) disassemble -n asmMain -c 40
Listing1-5`asmMain:
Listing1-5[0x100003e50] <+0>:  sub    sp, sp, #0x40
Listing1-5[0x100003e54] <+4>:  adrp   x0, 5
Listing1-5[0x100003e58] <+8>:  add    x0, x0, #0x10 ; savedLR
Listing1-5[0x100003e5c] <+12>: str    x30, [x0]

Listing1-5`printhw:
Listing1-5[0x100003e60] <+0>:  adrp   x0, 5
Listing1-5[0x100003e64] <+4>:  add    x0, x0, #0x18 ; hellowordStr
Listing1-5[0x100003e68] <+8>:  adrp   x1, 5
Listing1-5[0x100003e6c] <+12>: add    x1, x1, #0x28 ; counter
Listing1-5[0x100003e70] <+16>: ldr    x1, [x1]
Listing1-5[0x100003e74] <+20>: str    x1, [sp]
Listing1-5[0x100003e78] <+24>: bl     0x100003f6c    ; symbol stub for: printf

Listing1-5`cond:
Listing1-5[0x100003e7c] <+0>:  adrp   x10, 5
Listing1-5[0x100003e80] <+4>:  add    x10, x10, #0x28 ; counter
Listing1-5[0x100003e84] <+8>:  ldr    x9, [x10]
Listing1-5[0x100003e88] <+12>: add    x9, x9, #0x1
Listing1-5[0x100003e8c] <+16>: str    x9, [x10]
Listing1-5[0x100003e90] <+20>: cmp    x9, #0x3e8               <<----------
Listing1-5[0x100003e94] <+24>: b.lt   0x100003e60    ; printhw
Listing1-5[0x100003e98] <+28>: adrp   x0, 5
Listing1-5[0x100003e9c] <+32>: add    x0, x0, #0x10 ; savedLR
Listing1-5[0x100003ea0] <+36>: ldr    x30, [x0]
Listing1-5[0x100003ea4] <+40>: add    sp, sp, #0x40
Listing1-5[0x100003ea8] <+44>: ret    

Listing1-5`print_hw:
Listing1-5[0x100003eac] <+0>:  sub    sp, sp, #0x20
Listing1-5[0x100003eb0] <+4>:  stp    x29, x30, [sp, #0x10]
Listing1-5[0x100003eb4] <+8>:  add    x29, sp, #0x10
Listing1-5[0x100003eb8] <+12>: stur   wzr, [x29, #-0x4]
Listing1-5[0x100003ebc] <+16>: b      0x100003ec0    ; <+20> at c.cpp:10:27
Listing1-5[0x100003ec0] <+20>: ldur   w8, [x29, #-0x4]
Listing1-5[0x100003ec4] <+24>: subs   w8, w8, #0x3e8
Listing1-5[0x100003ec8] <+28>: cset   w8, ge
Listing1-5[0x100003ecc] <+32>: tbnz   w8, #0x0, 0x100003ef4 ; <+72> at c.cpp:13:1
Listing1-5[0x100003ed0] <+36>: b      0x100003ed4    ; <+40> at c.cpp:11:9
Listing1-5[0x100003ed4] <+40>: adrp   x0, 0
Listing1-5[0x100003ed8] <+44>: add    x0, x0, #0xf78 ; "Hello world\n"
Listing1-5[0x100003edc] <+48>: bl     0x100003f6c    ; symbol stub for: printf
Listing1-5[0x100003ee0] <+52>: b      0x100003ee4    ; <+56> at c.cpp:10:50
Listing1-5[0x100003ee4] <+56>: ldur   w8, [x29, #-0x4]
Listing1-5[0x100003ee8] <+60>: add    w8, w8, #0x1
Listing1-5[0x100003eec] <+64>: stur   w8, [x29, #-0x4]
```

Breakpoint at `cmp x9, #0x3e8` with:  
`b --address 0x100003e90`

```
(lldb) b --address 0x100003e90
Breakpoint 2: address = 0x0000000100003e90
```

add python script:  
`breakpoint command add -s python 2`

use this script:
```
error = lldb.SBError() 
did_change = frame.registers[0].GetChildMemberWithName('x9').SetValueFromCString("0x3e8") 
print("Cambio fatto?", did_change)
DONE
```

```
(lldb) breakpoint command add -s python 1
Enter your Python command(s). Type 'DONE' to end.
def function (frame, bp_loc, internal_dict):
    """frame: the lldb.SBFrame for the location at which you stopped
       bp_loc: an lldb.SBBreakpointLocation for the breakpoint location information
       internal_dict: an LLDB support object not to be used"""
    error = lldb.SBError() 
    did_change = frame.registers[0].GetChildMemberWithName('x9').SetValueFromCString("0x3e8") 
    print("Cambio fatto?", did_change) 
(lldb)
```

continue the process:  
`continue`

"Hello world" has been written only one time
```
(lldb) continue
Process 82902 resuming
Before : Listing 01-05 S
Hello world 0
Cambio fatto? True                <---------------
Process 82902 stopped
* thread #1, queue = 'com.apple.main-thread', stop reason = breakpoint 2.1
    frame #0: 0x0000000100003e90 Listing1-5`cond + 20
Listing1-5`cond:
->  0x100003e90 <+20>: cmp    x9, #0x3e8
    0x100003e94 <+24>: b.lt   0x100003e60    ; printhw
    0x100003e98 <+28>: adrp   x0, 5
    0x100003e9c <+32>: add    x0, x0, #0x10 ; savedLR
Target 0: (Listing1-5) stopped.
(lldb)
```

# "main.py" it's an example to run the program by Python script in debug mode
IMPORT OF LLDB DOESN'T WORK, SEE ISSUE https://github.com/llvm/llvm-project/issues/92603

