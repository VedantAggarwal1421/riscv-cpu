.section .text
.global _start

_start:
    addi x1, x0, 10      # x1 = 10
    addi x2, x0, -3      # x2 = -3 (tests sign extension)
    addi x3, x1, 5       # x3 = 15
    slti x4, x1, 20      # x4 = 1  (10 < 20)
    slti x5, x1, 5       # x5 = 0  (10 < 5 is false)
    xori x6, x1, 15      # x6 = 5  (1010 ^ 1111 = 0101)
    ori  x7, x1, 5       # x7 = 15 (1010 | 0101 = 1111)
    andi x8, x1, 7       # x8 = 2  (1010 & 0111 = 0010)
    slli x9, x1, 2       # x9 = 40 (10 << 2)
    srli x10, x9, 1      # x10 = 20
    srai x11, x2, 1      # x11 = -2 (arithmetic right shift, sign preserved)