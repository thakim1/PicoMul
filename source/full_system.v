/*
 *  PicoSoC - A simple example SoC using PicoRV32
 *
 *  Copyright (C) 2017  Claire Xenia Wolf <claire@yosyshq.com>
 *
 *  Permission to use, copy, modify, and/or distribute this software for any
 *  purpose with or without fee is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 *  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 *  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 *  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 *  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 *  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 */

 /*
  Modified by 
  Authors: Marcus Meysel, Karel Rusy, Hakim Tayari
  Date: 2024-07-10
 */

`ifdef PICOSOC_V
`error "full_system.v must be read before picosoc.v!"
`endif

// SRAM only usable if the program is located in Flash
// `define PICOSOC_MEM ice40up5k_spram

module full_system #(
    parameter N4 = 0,
    parameter N8 = 0,
    parameter N16 = 0
) (
	input clk,

	output ser_tx, // needed for UART ?       
	input ser_rx, // needed for UART ?

);
	parameter integer MEM_WORDS = 3072; //32768 if SRAM is used, 3072 for BRAM

	reg [5:0] reset_cnt = 0;
	wire resetn = &reset_cnt;

	always @(posedge clk) begin
		reset_cnt <= reset_cnt + !resetn;
	end

	wire        iomem_valid;
	reg         iomem_ready;
	wire [3:0]  iomem_wstrb;
	wire [31:0] iomem_addr;
	wire [31:0] iomem_wdata;
	reg  [31:0] iomem_rdata;
  wire 			  iomem_instr;
  
  // wires for pcpi interconnection
    wire pcpi_valid_w;
    wire [31:0] pcpi_insn_w;
    wire [31:0] pcpi_rs1_w;
    wire [31:0] pcpi_rs2_w;

    wire pcpi_ready_w;
    wire [31:0] pcpi_rd_w;
    wire pcpi_wait_w;
    wire pcpi_wr_w;


    // Pico SoC instantiation
	picosoc #(
		.ENABLE_COMPRESSED(0), // maybe later
    .ENABLE_PCPI(1), // needed to communicate with our custom hardware 
		.MEM_WORDS(MEM_WORDS),
    .STACKADDR('h10000), // depends on our software/linker?
		.PROGADDR_RESET(32'h0000_0000)  // BRAM  
	) soc (
		.clk          (clk         ),
		.resetn       (resetn      ),

		.ser_tx       (ser_tx      ), //UART?
		.ser_rx       (ser_rx      ), //UART?

		.iomem_valid  (iomem_valid ),
    .iomem_instr  (iomem_instr ),
		.iomem_ready  (iomem_ready ),
		.iomem_wstrb  (iomem_wstrb ),
		.iomem_addr   (iomem_addr  ),
		.iomem_wdata  (iomem_wdata ),
		.iomem_rdata  (iomem_rdata ), 
    
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
        .N4(N4),
        .N8(N8),
        .N16(N16)
    ) custom_pcpi_core(
        // Clk & Rst
        .clk(clk),
        .reset(reset),
        
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

endmodule