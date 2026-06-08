.section .text
.global _start

_start:
    addi x1, x0, 0x300
    addi x2, x0, 0x42
    addi x3, x0, 0x7FF      # max positive 12 bit immediate = 0x000007FF
    addi x8, x0, 0x304      # separate base for SH tests

    # SB tests
    sw   x0, 0(x1)          # mem[0x300] = 0x00000000
    sb   x2, 0(x1)          # mem[0x300] = 0x00000042
    lbu  x10, 0(x1)         # x10 = 0x42
    sb   x2, 1(x1)          # mem[0x300] = 0x00004242
    lbu  x11, 1(x1)         # x11 = 0x42
    sb   x2, 2(x1)          # mem[0x300] = 0x00424242
    lbu  x12, 2(x1)         # x12 = 0x42
    sb   x2, 3(x1)          # mem[0x300] = 0x42424242
    lbu  x13, 3(x1)         # x13 = 0x42
    lw   x14, 0(x1)         # x14 = 0x42424242

    # SH tests
    sw   x0, 0(x8)          # mem[0x304] = 0x00000000
    sh   x3, 0(x8)          # mem[0x304] = 0x000007FF
    lhu  x15, 0(x8)         # x15 = 0x07FF
    sh   x3, 2(x8)          # mem[0x304] = 0x07FF07FF
    lhu  x16, 2(x8)         # x16 = 0x07FF
    lw   x17, 0(x8)         # x17 = 0x07FF07FF

    # Partial write corruption check
    sw   x0, 4(x8)          # mem[0x308] = 0x00000000
    addi x4, x0, 0x7F
    sb   x4, 5(x8)          # mem[0x308] = 0x00007F00
    sb   x4, 1(x8)          # mem[0x304] = 0x07FF7FFF
    lw   x18, 4(x8)         # x18 = 0x00007F00
    lb   x19, 1(x8)         # x19 = 0x0000007F
    lw   x20, 0(x8)         # x20 = 0x07FF7FFF