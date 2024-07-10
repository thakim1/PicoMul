`include "x2_approx_mul.v"
`include "x4_approx_mul.v"
`include "x8_approx_add.v"
`include "x16_approx_add.v"


module tb_x8_approx_mul;

    // Inputs
    reg [7:0] a;
    reg [7:0] b;

    // Output
    wire [15:0] out;

    // Set parameter N8
    // N8_MIN = 0, N8_MAX = 4
    localparam N8 = 0;
    localparam N4 = 0;

    // Instantiate the mul
    x8_approx_mul #(N8, N4) uut (
        .a(a),
        .b(b),
        .out(out)
    );


    // Stimulus
    initial begin
        // Open VCD file for dumping
        $dumpfile("tb_x8_approx_mul.vcd");
        // Dump variables
        // $dumpvars(0, tb_x8_approx_mul);
        // Test some combinations of inputs
        for (integer i = 0; i < 255; i = i + 1) begin
            for (integer j = 0; j < 255; j = j + 1) begin
                // Set inputs
                a = i;
                b = j;
                
                // Display inputs in binary and decimal formats
                //$display("Input: a=%b (%d), b=%b (%d)", a, a, b, b);
                
                // Wait for a while
                #100;
                
                // Display output in binary and decimal formats
                //$display("Output: product=%b (%d)", out, out);
                $display("%d * %d = %d", a, b, out);
            end
        end
        
        // End simulation
        $finish;
    end
endmodule
