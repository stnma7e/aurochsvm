loadi r0 #100
LOADI r1 #200
add r2 r0 r1
loadi r3 #255
loadr r0 r2
SUB r3 r0 r2
add r1 r3 r2
mul r0 r1 r2
MUL r0 r0 r1
mul r0 r0 r0
mul r0 r0 r0
HALT