.section .text
.global _start

_start:
    addi x1, x0, 0x100      # base = 0x100, mem[0x100] = 0xDEADBEEF

    # LW
    lw   x10, 0(x1)         # x10 = 0xDEADBEEF

    # LB — signed, sign extends
    lb   x11, 0(x1)         # x11 = 0xFFFFFFEF (0xEF sign extended, MSB is 1)
    lb   x12, 1(x1)         # x12 = 0xFFFFFFBE (0xBE sign extended)
    lb   x13, 2(x1)         # x13 = 0xFFFFFFAD (0xAD sign extended)
    lb   x14, 3(x1)         # x14 = 0xFFFFFFDE (0xDE sign extended)

    # LBU — unsigned, zero extends
    lbu  x15, 0(x1)         # x15 = 0x000000EF
    lbu  x16, 1(x1)         # x16 = 0x000000BE
    lbu  x17, 2(x1)         # x17 = 0x000000AD
    lbu  x18, 3(x1)         # x18 = 0x000000DE

    addi x2, x0, 0x104      # base2 = 0x104, mem[0x104] = 0xCAFEBABE

    # LH — signed, sign extends halfword
    lh   x19, 0(x2)         # x19 = 0xFFFFBABE (0xBABE sign extended, MSB is 1)
    lh   x20, 2(x2)         # x20 = 0xFFFFCAFE (0xCAFE sign extended)

    # LHU — unsigned, zero extends halfword
    lhu  x21, 0(x2)         # x21 = 0x0000BABE
    lhu  x22, 2(x2)         # x22 = 0x0000CAFE