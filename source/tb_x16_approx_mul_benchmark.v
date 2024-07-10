`include "x2_approx_mul.v"
`include "x4_approx_mul.v"
`include "x8_approx_add.v"
`include "x8_approx_mul.v"
`include "x16_approx_add.v"
`include "x32_approx_add.v"


module tb_x16_approx_mul_benchmark;

    // Inputs
    reg [15:0] a;
    reg [15:0] b;

    // Output
    wire [31:0] out;

    // Set parameter N8
    // N8_MIN = 0, N8_MAX = 4
    // #################### CHANGE PARAMETERS HERE AND ONLY HERE #######
    localparam N16 = 32;
    localparam N8 = 16;
    localparam N4 = 8;
    // ################################################################

    // Declare the file variable
    reg file;

    // Instantiate the mul
    x16_approx_mul #(N16, N8, N4) uut (
        .a(a),
        .b(b),
        .out(out)
    );

    // Stimulus
    initial begin
        // Open VCD file for dumping
        $dumpfile("tb_x8_approx_mul.vcd");
        // Test some combinations of inputs
        for (integer j = 0; j < 500; j = j + 1) begin
            // Set inputs
            a = $urandom%65535;
            b = $urandom%65535; 
        
            // Wait for a while
            #100;

            // Display output 
            $display("%d", out);
        end

        // End simulation
        $finish;
    end
endmodule
