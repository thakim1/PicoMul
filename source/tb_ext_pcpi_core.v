`include "x2_approx_mul.v"
`include "x4_approx_mul.v"
`include "x8_approx_mul.v"

`include "x8_approx_add.v"
`include "x16_approx_add.v"
`include "x32_approx_add.v"

 
module tb_ext_pcpi_core;

    // Inputs
    reg clk;
    reg reset;
    reg pcpi_valid;
    reg [31:0] pcpi_insn;
    reg [31:0] pcpi_rs1;
    reg [31:0] pcpi_rs2;

    // Outputs
    wire pcpi_ready;
    wire [31:0] pcpi_rd;
    wire pcpi_wait;
    wire pcpi_wr;

    // Instantiate the Unit Under Test (UUT)
    ext_pcpi_core uut (
        .clk(clk),
        .resetn(reset),
        .pcpi_valid(pcpi_valid),
        .pcpi_insn(pcpi_insn),
        .pcpi_rs1(pcpi_rs1),
        .pcpi_rs2(pcpi_rs2),
        .pcpi_ready(pcpi_ready),
        .pcpi_rd(pcpi_rd),
        .pcpi_wait(pcpi_wait),
        .pcpi_wr(pcpi_wr)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin
        // Initialize Inputs
        reset = 1;
        pcpi_valid = 0;
        pcpi_insn = 0;
        pcpi_rs1 = 0;
        pcpi_rs2 = 0;

        // Wait for the global reset to finish
        #10;
        reset = 0;

        // Test 1: Apply a valid supported instruction
        #10;
        pcpi_valid = 1;
        pcpi_insn[6:0] = 7'hB;  // example supported instruction
        pcpi_rs1 = 16'h0003;  // some test value for rs1
        pcpi_rs2 = 16'h0004;  // some test value for rs2
        #20;
        pcpi_valid = 0;

        // Wait for the result
        #100;
        `ifdef ASSERTIONS
        assert (state == 3'b000 && pcpi_ready && pcpi_wr && pcpi_rd == (16'h0003 * 16'h0004))
            else $fatal("Test 1 failed");
        `endif

        // Test 2: Apply an unsupported instruction
        #10;
        pcpi_valid = 1;
        pcpi_insn[6:0] = 7'b1110110;  // example unsupported instruction
        pcpi_rs1 = 16'h0005;  // some test value for rs1
        pcpi_rs2 = 16'h0006;  // some test value for rs2
        #20;
        pcpi_valid = 0;

        // Wait for the result
        #100;
        `ifdef ASSERTIONS
        assert (state == 3'b000 && !pcpi_ready && !pcpi_wr && pcpi_rd == (16'h0000))
            else $fatal("Test 2 failed");
        `endif

        // Test 3: Reset during execution
        #10;
        pcpi_valid = 1;
        pcpi_insn[6:0] = 7'hB;  // example supported instruction
        pcpi_rs1 = 16'h0007;  // some test value for rs1
        pcpi_rs2 = 16'h0008;  // some test value for rs2
        #20;
        reset = 1;  // Reset during execution
        #10;
        reset = 0;
        pcpi_valid = 0;

        // Wait for the result
        #100;
        `ifdef ASSERTIONS
        assert (state == 3'b000 && !pcpi_ready && !pcpi_wr)
            else $fatal("Test 3 failed");
        `endif

        // Test 4: Apply multiple valid instructions
        #10;
        pcpi_valid = 1;
        pcpi_insn[6:0] = 7'hB;  // example supported instruction
        pcpi_rs1 = 16'h0009;  // some test value for rs1
        pcpi_rs2 = 16'h000A;  // some test value for rs2
        #20;
        pcpi_valid = 0;
        #100;

        `ifdef ASSERTIONS
        assert (state == 3'b000 && pcpi_ready && pcpi_wr && pcpi_rd == (16'h0009 * 16'h000A))
            else $fatal("Test 4.1 failed");
        `endif
        #10;
        pcpi_valid = 1;
        pcpi_insn[6:0] = 7'hB;  // another supported instruction
        pcpi_rs1 = 16'h000B;  // another test value for rs1
        pcpi_rs2 = 16'h000C;  // another test value for rs2
        #20;
        pcpi_valid = 0;
        #100;

        `ifdef ASSERTIONS
        assert (state == 3'b000 && pcpi_ready && pcpi_wr && pcpi_rd == (16'h000B * 16'h000C))
            else $fatal("Test 4.2 failed");
        `endif

        // Test 5: Apply an unsupported instruction and then a supported one
        #10;
        pcpi_valid = 1;
        pcpi_insn[6:0] = 7'b1010111;  // example unsupported instruction
        pcpi_rs1 = 16'h000D;  // some test value for rs1
        pcpi_rs2 = 16'h000E;  // some test value for rs2
        #20;
        pcpi_valid = 0;
        #100;

        `ifdef ASSERTIONS
        assert (state == 3'b000 && !pcpi_ready && !pcpi_wr)
            else $fatal("Test 5.1 failed");
        `endif

        #10;
        pcpi_valid = 1;
        pcpi_insn[6:0] = 7'hB;  // example supported instruction
        pcpi_rs1 = 16'h000F;  // some test value for rs1
        pcpi_rs2 = 16'h0010;  // some test value for rs2
        #20;
        pcpi_valid = 0;
        #100;
        `ifdef ASSERTIONS
        assert (state == 3'b000 && pcpi_ready && pcpi_wr && pcpi_rd == (16'h000F * 16'h0010))
            else $fatal("Test 5.2 failed");
        `endif

        // Finish the simulation
        $finish;
    end
    
    // Monitor outputs only when pcpi_valid is 1
    always @(posedge clk) begin
        if (pcpi_wait | pcpi_ready) begin
            $display("%d, reset = %b, pcpi_valid = %b, pcpi_insn = %h, pcpi_rs1 = %d, pcpi_rs2 = %d, pcpi_ready = %b, pcpi_rd = %d, pcpi_wait = %b, pcpi_wr = %b", 
                 $time, reset, pcpi_valid, pcpi_insn, pcpi_rs1, pcpi_rs2, pcpi_ready, pcpi_rd, pcpi_wait, pcpi_wr);
        end
    end
 
    //Monitor outputs
    /*
    initial begin
        $monitor("clk = %b, reset = %b, pcpi_valid = %b, pcpi_insn = %h, pcpi_rs1 = %b, pcpi_rs2 = %b, pcpi_ready = %b, pcpi_rd = %h, pcpi_wait = %b, pcpi_wr = %b, operation_done = %b, ctr = %b, state = %b", 
                 clk, reset, pcpi_valid, pcpi_insn, pcpi_rs1, pcpi_rs2, pcpi_ready, pcpi_rd, pcpi_wait, pcpi_wr, operation_done, counter, state);
    end
    */
endmodule
