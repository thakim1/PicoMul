# Select your RISC-V compiler here (riscv32i/riscv32im/riscv32ic/riscv32imc)

# For testing software in testbench  
RISCV_ISA = i
TOOLCHAIN_PREFIX = /opt/riscv32$(RISCV_ISA)/bin/riscv32-unknown-elf-
CFLAGS_SIM = -MD -O3 -mabi=ilp32 -march=rv32$(RISCV_ISA) -DTIME -DRISCV -DUSE_MYSTDLIB -ffreestanding -nostdlib
SIM_OBJS = stdlib_sim.o main_sim.o start.o
 

# For writing hardware 
CROSS=/opt/riscv32$(RISCV_ISA)/bin/riscv32-unknown-elf-
CFLAGS_HW= -O3 
HW_SRCS = stdlib_hw.c
BRAM_SIZE = 3072


# ===== START : Simulation multiplier submodules  ===== 

# Compile and run x1_approx_add simulation
x1_approx_add: x1_approx_add.v tb_x1_approx_add.v
	iverilog -o tb_x1_approx_add x1_approx_add.v tb_x1_approx_add.v
	vvp tb_x1_approx_add

# Compile and run x2_accu_mul simulation
x2_accu_mul: x2_accu_mul.v tb_x2_accu_mul.v
	iverilog -o tb_x2_accu_mul x2_accu_mul.v tb_x2_accu_mul.v
	vvp tb_x2_accu_mul

# Compile and run x2_approx_mul simulation
x2_approx_mul: x2_approx_mul.v tb_x2_approx_mul.v
	iverilog -o tb_x2_approx_mul x2_approx_mul.v tb_x2_approx_mul.v
	vvp tb_x2_approx_mul

# Compile and run x4_approx_add simulation: 
x4_approx_add: x4_approx_add.v x1_approx_add.v x1_accu_add.v tb_x4_approx_add.v
	iverilog -o tb_x4_approx_add x4_approx_add.v x1_approx_add.v x1_accu_add.v tb_x4_approx_add.v
	vvp tb_x4_approx_add

# Compile and run x8_approx_add simulation: 
x8_approx_add: x8_approx_add.v x1_approx_add.v x1_accu_add.v tb_x8_approx_add.v
	iverilog -o tb_x8_approx_add x8_approx_add.v x1_approx_add.v x1_accu_add.v tb_x8_approx_add.v
	vvp tb_x8_approx_add

# Compile and run x16_approx_add simulation: 
x16_approx_add: x16_approx_add.v x1_approx_add.v x1_accu_add.v tb_x16_approx_add.v
	iverilog -o tb_x16_approx_add x16_approx_add.v x1_approx_add.v x1_accu_add.v tb_x16_approx_add.v
	vvp tb_x16_approx_add

# Compile and run x4_approx_mul simulation: 
x4_approx_mul: x4_approx_mul.v x1_approx_add.v x1_accu_add.v tb_x4_approx_mul.v
	iverilog -o tb_x4_approx_mul x4_approx_mul.v x1_approx_add.v x1_accu_add.v tb_x4_approx_mul.v
	vvp tb_x4_approx_mul

# Compile and run x8_approx_mul simulation: 
x8_approx_mul: x8_approx_mul.v x1_approx_add.v x1_accu_add.v tb_x8_approx_mul.v
	iverilog -o tb_x8_approx_mul x8_approx_mul.v x1_approx_add.v x1_accu_add.v tb_x8_approx_mul.v
	vvp tb_x8_approx_mul

# Compile and run x16_approx_mul simulation: 
x16_approx_mul: x16_approx_mul.v x1_approx_add.v x1_accu_add.v tb_x16_approx_mul.v
	iverilog -o tb_x16_approx_mul x16_approx_mul.v x1_approx_add.v x1_accu_add.v tb_x16_approx_mul.v
	vvp tb_x16_approx_mul

# Compile and run x16_approx_mul simulation for the benchmark: 
x16_approx_mul_benchmark: x16_approx_mul.v x1_approx_add.v x1_accu_add.v tb_x16_approx_mul_benchmark.v
	iverilog -o tb_x16_approx_mul x16_approx_mul.v x1_approx_add.v x1_accu_add.v tb_x16_approx_mul_benchmark.v
	vvp tb_x16_approx_mul

# Compile and run ext_pcpi_core_test simulation:
ext_pcpi_core_test: ext_pcpi_core_test.v tb_ext_pcpi_core_test.v x16_approx_mul.v x1_accu_add.v
	iverilog -o tb_ext_pcpi_core_test ext_pcpi_core_test.v tb_ext_pcpi_core_test.v x16_approx_mul.v x1_accu_add.v
	vvp tb_ext_pcpi_core_test

# Compile and run ext_pcpi_core simulation:
# This simulated the same for but without looking at internal variables like state, counter etc. 
#ext_pcpi_core: ext_pcpi_core.v tb_ext_pcpi_core.v x16_approx_mul.v x1_accu_add.v
#	iverilog -o tb_ext_pcpi_core ext_pcpi_core.v tb_ext_pcpi_core.v x16_approx_mul.v x1_accu_add.v
#	vvp tb_ext_pcpi_core

# Clean generated files
clean_sub_mul:
	rm -f *.vcd 
	rm -f tb_x1_approx_add tb_x1_accu_add tb_x2_accu_mul tb_x2_approx_mul tb_x4_approx_add tb_x8_approx_add tb_x16_approx_add tb_x4_approx_mul tb_x8_approx_mul tb_x16_approx_mul tb_ext_pcpi_core tb_ext_pcpi_core_test

# ===== END : Simulation multiplier submodules  ===== 

# ======= START : Executing Software on Simulated Hardware section ======

# Borrowed and adapted from the picorv32 repo dhrystone makefile:
test_sim: tb_software_exec.vvp sim.hex
	vvp -N tb_software_exec.vvp

tb_software_exec.vvp: tb_software_exec.v picorv32.v ext_pcpi_core.v x16_approx_mul.v
	iverilog -o tb_software_exec.vvp tb_software_exec.v picorv32.v ext_pcpi_core.v x16_approx_mul.v x32_approx_add.v x16_approx_add.v x8_approx_mul.v x8_approx_add.v x4_approx_mul.v x2_approx_mul.v x1_approx_add.v x1_accu_add.v
	chmod -x tb_software_exec.vvp

sim.hex: sim.elf
	$(TOOLCHAIN_PREFIX)objcopy -O verilog $< $@

sim.elf: $(SIM_OBJS) sections_sim.lds
	$(TOOLCHAIN_PREFIX)gcc $(CFLAGS_SIM) -Wl,-Bstatic,-T,sections_sim.lds,-Map,sim.map,--strip-debug -o $@ $(SIM_OBJS) -lgcc
	chmod -x $@

%.o: %.c
	$(TOOLCHAIN_PREFIX)gcc -c $(CFLAGS_SIM) $<

%.o: %.S
	$(TOOLCHAIN_PREFIX)gcc -c $(CFLAGS_SIM) $<

main_sim.o: CFLAGS_SIM += -Wno-implicit-int -Wno-implicit-function-declaration

clean_sim:
	rm -rf *.o *.d sim.elf sim.map sim.bin sim.hex timing.vvp timing.txt tb_software_exec.vvp tb_software_exec.vcd



# .PHONY if we dont use files in targets we can set these targets  here 
# -include *.d  Not needed when executing test_sim
# ======= END: Executing Software on Simulated Hardware section ======

# ===== START : Synthesis and Hardware implementation section  ===== 
# Borrowed and adapted from the picosoc repo makefile:



# ---- Firmware analysis ----

size: icebreaker_fw.elf
	$(CROSS)size icebreaker_fw.elf

dis: icebreaker_fw.elf
	$(CROSS)objdump -d icebreaker_fw.elf

disdump: icebreaker_fw.elf
	$(CROSS)objdump -D icebreaker_fw.elf > icebreaker_fw.s

# ---- iCE40 IceBreaker Board ----

icebreaker.json: icebreaker.v ext_pcpi_core.v x16_approx_mul.v x32_approx_add.v x8_approx_mul.v x16_approx_add.v x4_approx_mul.v x1_accu_add.v x8_approx_add.v x2_approx_mul.v x1_approx_add.v spimemio.v simpleuart.v picosoc.v ice40up5k_spram.v picorv32.v icebreaker_fw_random.hex
	yosys -f verilog -v3 -ql icebreaker.log -p 'synth_ice40 -dsp -top icebreaker -json icebreaker.json'  $(filter %.v, $^)

icebreaker.asc: icebreaker.pcf icebreaker.json
	nextpnr-ice40 --freq 13 --up5k --package sg48 --asc icebreaker.asc --pcf icebreaker.pcf --json icebreaker.json

# This requires a reset address of 0x0010_0000 and the .text section mapped to FLASH in the linker script
icebreaker_flash.bin: icebreaker.asc
	icetime -d up5k -c 12 -mtr icebreaker.rpt icebreaker.asc
	icepack icebreaker.asc icebreaker_flash.bin

icebreaker_bram.bin: icebreaker_bram.asc
	icetime -d up5k -c 12 -mtr icebreaker.rpt icebreaker_bram.asc
	icepack icebreaker_bram.asc icebreaker_bram.bin

prog_bram: icebreaker_bram.bin
	iceprog icebreaker_bram.bin

prog_fw: icebreaker_fw.bin
	iceprog -o 1M icebreaker_fw.bin

icebreaker_sections.lds: sections_hw.lds
	$(CROSS)cpp -P -DICEBREAKER -o $@ $^

icebreaker_fw.elf: icebreaker_sections.lds start.s main_hw.c $(HW_SRCS)
	$(CROSS)gcc $(CFLAGS_HW) -DICEBREAKER -DTIME -DRISCV -DUSE_MYSTDLIB -ffreestanding -nostdlib -mabi=ilp32 -march=rv32$(RISCV_ISA) -Wl,-Bstatic,-T,icebreaker_sections.lds,-Map,icebreaker_fw.map,--strip-debug -o icebreaker_fw.elf start.s main_hw.c $(HW_SRCS) -Wno-implicit-int -Wno-implicit-function-declaration -lgcc

icebreaker_fw.hex: icebreaker_fw.elf
	$(CROSS)objcopy -O verilog icebreaker_fw.elf icebreaker_fw.hex

icebreaker_fw_bram.hex: icebreaker_fw.bin
	python3 firmware/makehex.py $< $(BRAM_SIZE) > $@

icebreaker_fw.bin: icebreaker_fw.elf
	$(CROSS)objcopy -O binary icebreaker_fw.elf icebreaker_fw.bin

icebreaker_fw_random.hex:
	icebram -g 32 $(BRAM_SIZE) > icebreaker_fw_random.hex

icebreaker_bram.asc: icebreaker_fw_bram.hex icebreaker_fw_random.hex icebreaker.asc
	icebram -v icebreaker_fw_random.hex icebreaker_fw_bram.hex < icebreaker.asc > icebreaker_bram.asc


# ---- Clean ----

clean_hw:
	rm -f testbench.vvp testbench.vcd spiflash_tb.vvp spiflash_tb.vcd
	rm -f icebreaker_fw.elf icebreaker_fw.hex icebreaker_fw.bin icebreaker_fw.map icebreaker_fw.d
	rm -f icebreaker.json icebreaker.log icebreaker.asc icebreaker.rpt icebreaker_flash.bin
	rm -f icebreaker_syn.v icebreaker_syn_tb.vvp icebreaker_tb.vvp
	rm -f icebreaker_fw_random.hex icebreaker_bram.asc icebreaker_bram.bin icebreaker_fw_bram.hex
	rm -f icebreaker_fw.s icebreaker_sections.lds

.PHONY: spiflash_tb clean_hw
.PHONY: prog_flash prog_bram prog_fw sim synsim

# ===== END : Synthesis and Hardware implementation section =====



# Help target to display available options
help:
	@echo "----------------------------------------------------------" 
	@echo "Targets for building and testing submodules:"
	@echo "----------------------------------------------------------" 
	@echo "x1_approx_add     			: Compile and run tb_x1_approx_add simulation"
	@echo "x2_accu_mul       			: Compile and run tb_x2_accu_mul simulation"
	@echo "x2_approx_mul     			: Compile and run tb_x2_approx_mul simulation"
	@echo "x4_approx_add     			: Compile and run tb_x4_approx_add simulation" 
	@echo "x8_approx_add     			: Compile and run tb_x8_approx_add simulation" 
	@echo "x16_approx_add    			: Compile and run tb_x16_approx_add simulation" 
	@echo "x4_approx_mul     			: Compile and run tb_x4_approx_mul simulation"
	@echo "x8_approx_mul     			: Compile and run tb_x8_approx_mul simulation"
	@echo "x16_approx_mul    			: Compile and run tb_x8_approx_mul simulation"
	@echo "x16_approx_mul_benchmark  		: Compile and run x16 multiplier the benchmark"      	
	@echo "ext_pcpi_core_test			: Compile and run tb_ext_pcpi_core_test simulation"   	
	@echo "clean_sub_mul     			: Remove generated files and VCD files"
	@echo "help              			: Display this help message"
	@echo "----------------------------------------------------------" 
	@echo "Simulation  targets:" 
	@echo "----------------------------------------------------------" 
	@echo "test_sim	    			: Simulation code execution on pico hardware"
	@echo "clean_sim        			: Remove generated sim files: .vcd, .o, .d, .elf, .bin, .lds, .hex, .vvp, .txt"
	@echo "----------------------------------------------------------" 
	@echo "Hardware  targets:" 
	@echo "----------------------------------------------------------" 
	@echo "icebreaker_bram.bin		    	: Build icebreaker_bram.bin"
	@echo "prog_bram        		   	: (Build and) transfer the icebreaker_bram.bin onto the FPGA, N4, N8, N16 can be modified inside icebreaker.v"
	@echo "clean_hw       				: Remove generated hw files"
