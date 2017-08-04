A simplified MIPS CPU implementation.

This simulator implements 33 instructions of the MIPS ISA. The design is based on *Computer Organization and Design: The Hardware/Software Interface, 5th edition*.

## Features

- A 5-stage pipeline
- Hazard detection, stall and forward
- CP0 and basic exception support

## Notes on Test

- The instruction RAM and data RAM used in the test file are generated using Xilinx IP Core.

## Supported Instructions

### Arithmetic and Logical Instructions

```
add
addu
addi
addiu
and
andi
nor
or
ori
sll
sllv
sra
srav
srl
srlv
sub
subu
xor
xori
```

### Comparison Instructions

```
slt
sltu
slti
sltiu
```

### Branch Instructions

```
beq
bgtz
bne
```

### Jump Instructions

```
j
jr
```

### Load Instructions

```
lw
```

### Store Instructions

```
sw
```

### Data Movement Instructions

```
mfc0
mtc0
```

### Exception and Interrupt Instructions

```
eret
```

