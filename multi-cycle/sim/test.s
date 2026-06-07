.section .text
.global _start

_start:
    addi x1, x0, 0x100     # base address 1
    addi x2, x0, 0x200     # base address 2
    addi x3, x0, 4         # offset increment

    lw   x10, 0(x1)        # x10 = mem[0x100] = 0xDEADBEEF
    lw   x11, 4(x1)        # x11 = mem[0x104] = 0xCAFEBABE
    lw   x12, 8(x1)        # x12 = mem[0x108] = 0x12345678
    lw   x13, -4(x1)       # x13 = mem[0x0FC] = 0xAABBCCDD
    lw   x14, 0(x2)        # x14 = mem[0x200] = 0x11223344
    lw   x15, 4(x2)        # x15 = mem[0x204] = 0x55667788
    add  x6, x1, x3        # x6  = 0x104
    lw   x16, 0(x6)        # x16 = mem[0x104] = 0xCAFEBABE (same as x11, different base)
    addi x7, x2, 8
    lw   x17, 0(x7)        # x17 = mem[0x208] = 0x99AABBCC