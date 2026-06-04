# Load immediate values into registers via addi (we'll hardcode regs instead)
# Test: ADD, SUB, AND, OR, XOR, SLT

# Assuming x1 = 10, x2 = 3 hardcoded via initial block

add  x3, x1, x2    # x3 = 13
sub  x4, x1, x2    # x4 = 7
and  x5, x1, x2    # x5 = 2
or   x6, x1, x2    # x6 = 11
xor  x7, x1, x2    # x7 = 9
slt  x8, x2, x1    # x8 = 1 (3 < 10)