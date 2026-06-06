sim: obj bin hex clean

obj:
	riscv64-linux-gnu-as -march=rv32i sim/test.s -o sim/test.o
bin:
	riscv64-linux-gnu-objcopy -O binary sim/test.o sim/test.bin
hex:
	hexdump -v -e '1/4 "%08x\n"' sim/test.bin > sim/program.hex
clean:
	rm -f sim/test.o sim/test.bin

build: compile run

compile:
	iverilog -g2012 -o cpu_ms sim/cpu_tb.v src/*/**.v
run:
	vvp cpu_ms