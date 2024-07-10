// A version of the dhrystone test bench that isn't using the look-ahead interface


`timescale 1 ns / 1 ps

module testbench;
	reg clk = 1;
	reg resetn = 0;
	wire trap;

	always #5 clk = ~clk;

	initial begin
		repeat (100) @(posedge clk);
		resetn <= 1;
	end

    // Wires and Regs for pico soc memory
	wire mem_valid;
	wire mem_instr;
	reg  mem_ready;
	wire [31:0] mem_addr;
	wire [31:0] mem_wdata;
	wire [3:0]  mem_wstrb;
	reg  [31:0] mem_rdata;

	// wires for pcpi interconnection
    wire pcpi_valid_w;
    wire [31:0] pcpi_insn_w;
    wire [31:0] pcpi_rs1_w;
    wire [31:0] pcpi_rs2_w;

    wire pcpi_ready_w;
    wire [31:0] pcpi_rd_w;
    wire pcpi_wait_w;
    wire pcpi_wr_w;




    // picorv instantiation 
	picorv32 #(
		.COMPRESSED_ISA(0), // might change later to save space
		.ENABLE_MUL(0), // might change later to compute faster but needs more space 
        .ENABLE_PCPI(1), // we need it for the communication with external pcpi core 
		.PROGADDR_RESET('h10000), // depends on our software/linker? 
		.STACKADDR('h10000) // depends on our software/linker?
	) uut (

        // basic stuff 
		.clk         (clk        ),
		.resetn      (resetn     ),
		.trap        (trap       ),
		.mem_valid   (mem_valid  ),
		.mem_instr   (mem_instr  ),
		.mem_ready   (mem_ready  ),
		.mem_addr    (mem_addr   ),
		.mem_wdata   (mem_wdata  ),
		.mem_wstrb   (mem_wstrb  ),
		.mem_rdata   (mem_rdata  ),

		// pcpi interconnect inputs 
        .pcpi_valid(pcpi_valid_w),
        .pcpi_insn(pcpi_insn_w),
        .pcpi_rs1(pcpi_rs1_w),
        .pcpi_rs2(pcpi_rs2_w),
        // pcpi interconnet outpus
        .pcpi_ready(pcpi_ready_w),
        .pcpi_rd(pcpi_rd_w),
        .pcpi_wait(pcpi_wait_w),
        .pcpi_wr(pcpi_wr_w)
	);

	// State machine instantiation
    ext_pcpi_core #(
        .N4(0), // 8 at max
        .N8(0), // 16 
        .N16(0) // 32
    ) custom_pcpi_core(
        // Clk & Rst
        .clk(clk),
        .resetn(resetn),

        // pcpi interconnect Outpus 
        .pcpi_valid(pcpi_valid_w),
        .pcpi_insn(pcpi_insn_w),
        .pcpi_rs1(pcpi_rs1_w),
        .pcpi_rs2(pcpi_rs2_w),

        // pcpi interconnect Inputs 
        .pcpi_ready(pcpi_ready_w),
        .pcpi_rd(pcpi_rd_w),
        .pcpi_wait(pcpi_wait_w),
        .pcpi_wr(pcpi_wr_w)
    );


	reg [7:0] memory [0:256*1024-1]; // determine size of .hex file
	initial $readmemh("sim.hex", memory); // determine name of .hex file

	always @(posedge clk) begin
		mem_ready <= 1'b0;

		mem_rdata[ 7: 0] <= 'bx;
		mem_rdata[15: 8] <= 'bx;
		mem_rdata[23:16] <= 'bx;
		mem_rdata[31:24] <= 'bx;

		if (mem_valid & !mem_ready) begin
			if (|mem_wstrb) begin
				mem_ready <= 1'b1;

				case (mem_addr)
					32'h1000_0000: begin // not sure about this address? 
						$write("%c", mem_wdata);
						$fflush();
					end
					default: begin
						if (mem_wstrb[0]) memory[mem_addr + 0] <= mem_wdata[ 7: 0];
						if (mem_wstrb[1]) memory[mem_addr + 1] <= mem_wdata[15: 8];
						if (mem_wstrb[2]) memory[mem_addr + 2] <= mem_wdata[23:16];
						if (mem_wstrb[3]) memory[mem_addr + 3] <= mem_wdata[31:24];
					end
				endcase
			end
			else begin
				mem_ready <= 1'b1;

				mem_rdata[ 7: 0] <= memory[mem_addr + 0];
				mem_rdata[15: 8] <= memory[mem_addr + 1];
				mem_rdata[23:16] <= memory[mem_addr + 2];
				mem_rdata[31:24] <= memory[mem_addr + 3];
			end
		end
	end

	initial begin
		$dumpfile("tb_software_exec.vcd");
		$dumpvars(0, testbench);
	end

	always @(posedge clk) begin
		if (resetn && trap) begin
			repeat (10) @(posedge clk);
			$display("TRAP");
			$finish;
		end
	end
endmodule
