.section .text
.global _start

_start:
    # ── Initialize registers ──────────────────────────────
    addi x1,  x0, 1
    addi x2,  x0, -1          # x2 = 0xFFFFFFFF
    addi x3,  x0, 15
    addi x4,  x0, 7
    lui  x5,  0xABCDE          # x5 = 0xABCDE000
    auipc x6, 0x1              # x6 = PC + 0x1000

    # ── R-type ───────────────────────────────────────────
    add  x7,  x1,  x3          # x7  = 16
    sub  x8,  x3,  x4          # x8  = 8
    and  x9,  x3,  x4          # x9  = 7  (1111 & 0111)
    or   x10, x3,  x4          # x10 = 15
    xor  x11, x3,  x4          # x11 = 8
    sll  x12, x1,  x4          # x12 = 128 (1 << 7)
    srl  x13, x12, x4          # x13 = 1
    sra  x14, x2,  x4          # x14 = 0xFFFFFFFF (arithmetic shift of -1)
    slt  x15, x2,  x1          # x15 = 1 (-1 < 1 signed)
    sltu x16, x1,  x2          # x16 = 1 (1 < 0xFFFFFFFF unsigned)

    # ── I-type arithmetic ────────────────────────────────
    addi x17, x3,  -8          # x17 = 7
    xori x18, x3,  0x7FF       # x18 = 15 ^ 0x7FF = 0x7F0
    ori  x19, x0,  0x123       # x19 = 0x123
    andi x20, x3,  0x5         # x20 = 5 (1111 & 0101)
    slli x21, x1,  3           # x21 = 8
    srli x22, x12, 3           # x22 = 16
    srai x23, x2,  1           # x23 = 0xFFFFFFFF
    slti x24, x2,  1           # x24 = 1 (-1 < 1 signed)
    sltiu x25, x1, 5           # x25 = 1 (1 < 5 unsigned)

    # ── Store then load roundtrip ────────────────────────
    addi x28, x0,  0x300
    sw   x7,  0(x28)           # mem[0x300] = 16
    sw   x2,  4(x28)           # mem[0x304] = 0xFFFFFFFF
    sb   x3,  8(x28)           # mem[0x308] = 0x0000000F
    sh   x19, 10(x28)          # mem[0x30A] = 0x01230000 upper half

    lw   x29, 0(x28)           # x29 = 16
    lw   x30, 4(x28)           # x30 = 0xFFFFFFFF
    lbu  x31, 8(x28)           # x31 = 0x0F
    lb   x27, 4(x28)           # x27 = 0xFFFFFFFF (0xFF sign extended)
    lhu  x26, 10(x28)          # x26 = 0x0123

    # ── Branches ─────────────────────────────────────────
    beq  x1,  x1,  beq_ok
    addi x1,  x0,  0xFF
beq_ok:
    bne  x1,  x2,  bne_ok
    addi x2,  x0,  0xFF
bne_ok:
    blt  x2,  x1,  blt_ok     # -1 < 1 signed
    addi x3,  x0,  0xFF
blt_ok:
    bge  x1,  x2,  bge_ok     # 1 >= -1 signed
    addi x4,  x0,  0xFF
bge_ok:
    bltu x1,  x2,  bltu_ok    # 1 < 0xFFFFFFFF unsigned
    addi x5,  x0,  0xFF
bltu_ok:
    bgeu x2,  x1,  bgeu_ok    # 0xFFFFFFFF >= 1 unsigned
    addi x6,  x0,  0xFF
bgeu_ok:

    # ── JAL and JALR ─────────────────────────────────────
    jal  x1,  subr             # jump to subr, x1 = return addr
after_subr:
    addi x9,  x0,  99          # x9 = 99, confirms return worked
    jal  x0,  done

subr:
    addi x10, x0,  42          # x10 = 42, inside subroutine
    jalr x0,  x1,  0           # return

done:
    addi x11, x0,  1           # x11 = 1, confirms program completed