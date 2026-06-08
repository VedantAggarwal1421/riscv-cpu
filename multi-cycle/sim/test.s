.section .text
.global _start

_start:
    addi x1, x0, 10        # x1 = 10
    addi x2, x0, 10        # x2 = 10
    addi x3, x0, 7         # x3 = 7
    addi x4, x0, -1        # x4 = 0xFFFFFFFF (-1 signed, max unsigned)

    # BEQ
    beq  x1, x2, beq_pass
    addi x10, x0, 0xFF
beq_pass:
    addi x10, x0, 1        # x10 = 1

    # BNE
    bne  x1, x3, bne_pass
    addi x11, x0, 0xFF
bne_pass:
    addi x11, x0, 2        # x11 = 2

    # BNE not taken
    bne  x1, x2, bne_fail
    addi x12, x0, 3        # x12 = 3, should execute
    beq  x0, x0, bne_done
bne_fail:
    addi x12, x0, 0xFF
bne_done:

    # BLT signed — x4 = -1 < x1 = 10
    blt  x4, x1, blt_pass
    addi x13, x0, 0xFF
blt_pass:
    addi x13, x0, 4        # x13 = 4

    # BLT signed not taken — x1 = 10 not < x3 = 7
    blt  x1, x3, blt_fail
    addi x14, x0, 5        # x14 = 5, should execute
    beq  x0, x0, blt_done
blt_fail:
    addi x14, x0, 0xFF
blt_done:

    # BGE signed — x1 = 10 >= x3 = 7
    bge  x1, x3, bge_pass
    addi x15, x0, 0xFF
bge_pass:
    addi x15, x0, 6        # x15 = 6

    # BGE signed — x4 = -1 not >= x1 = 10
    bge  x4, x1, bge_fail
    addi x16, x0, 7        # x16 = 7, should execute
    beq  x0, x0, bge_done
bge_fail:
    addi x16, x0, 0xFF
bge_done:

    # BLTU unsigned — x3 = 7 < x4 = 0xFFFFFFFF
    bltu x3, x4, bltu_pass
    addi x17, x0, 0xFF
bltu_pass:
    addi x17, x0, 8        # x17 = 8

    # BLTU unsigned not taken — x4 = 0xFFFFFFFF not < x3 = 7
    bltu x4, x3, bltu_fail
    addi x18, x0, 9        # x18 = 9, should execute
    beq  x0, x0, bltu_done
bltu_fail:
    addi x18, x0, 0xFF
bltu_done:

    # BGEU unsigned — x4 = 0xFFFFFFFF >= x3 = 7
    bgeu x4, x3, bgeu_pass
    addi x19, x0, 0xFF
bgeu_pass:
    addi x19, x0, 10       # x19 = 10

    # BGEU unsigned not taken — x3 = 7 not >= x4 = 0xFFFFFFFF
    bgeu x3, x4, bgeu_fail
    addi x20, x0, 11       # x20 = 11, should execute
    beq  x0, x0, bgeu_done
bgeu_fail:
    addi x20, x0, 0xFF
bgeu_done:

    # Critical signed vs unsigned distinction
    # x4 = -1 = 0xFFFFFFFF
    # signed: x4 < x1 (10) → BLT taken, BLTU not taken
    blt  x4, x1, sign_pass
    addi x21, x0, 0xFF
sign_pass:
    addi x21, x0, 12       # x21 = 12, BLT correctly treats x4 as negative

    bltu x4, x1, unsigned_fail
    addi x22, x0, 13       # x22 = 13, BLTU correctly treats x4 as large positive
    beq  x0, x0, unsigned_done
unsigned_fail:
    addi x22, x0, 0xFF
unsigned_done: