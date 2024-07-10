`include "x2_approx_mul.v"
`include "x4_approx_mul.v"
`include "x8_approx_mul.v"

`include "x8_approx_add.v"
`include "x16_approx_add.v"
`include "x32_approx_add.v"

module tb_x16_approx_mul;

    // Inputs
    reg clk;
    reg reset;
    reg [15:0] a;
    reg [15:0] b;

    // Output
    wire [31:0] out;

    // Set parameter N8
    // N8_MIN = 0, N8_MAX = 4

    // #################### CHANGE PARAMETERS HERE AND ONLY HERE #######
    localparam N16 = 0;
    localparam N8 = 0;
    localparam N4 = 0;
    // ################################################################

    // Instantiate the mul
    x16_approx_mul #(N16, N8, N4) uut (

        //clk(clk),
        //.reset(reset),
        
        .a(a),
        .b(b),
        .out(out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz clock
    end

    // Stimulus
    initial begin
        // Open VCD file for dumping
        $dumpfile("tb_x16_approx_mul.vcd");
        $dumpvars(0, tb_x16_approx_mul);

        // Reset the DUT
        reset = 1;
        #10;
        reset = 0;
        
        // Test some combinations of inputs
        for (integer i = 0; i < 60000; i = i + 1000) begin // WARNING not all values are tested here for speed
            for (integer j = 0; j < 60000; j = j + 1000) begin
                // Set inputs
                a = i;
                b = j;
                
                // Wait for the result to propagate
                #20;
                
                // Display output in decimal format
                $display("%d * %d = %d", a, b, out);
            end
        end
        
        // End simulation
        $finish;
    end
endmodule