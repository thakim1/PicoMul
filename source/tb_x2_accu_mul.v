module tb_x2_accu_mul;

    // Inputs
    reg [1:0] a;
    reg [1:0] b;

    // Output
    wire [3:0] out;

    // Instantiate the multiplier
    x2_accu_mul UUT(
        .a(a),
        .b(b),
        .out(out)
    );

    // Stimulus
    initial begin
        // Open VCD file for dumping
        $dumpfile("tb_x2_accu_mul.vcd");
        // Dump variables
        //$dumpvars(0, tb_x2_accu_mul);

        // Test all possible combinations of inputs
        for (integer i = 0; i < 4; i++) begin
            for (integer j = 0; j < 4; j++) begin
                // Set inputs
                a = i;
                b = j;
                
                // Display inputs in binary and decimal formats
                $display("Input: a=%b (%d), b=%b (%d)", a, a, b, b);
                
                // Wait for a while
                #10;
                
                // Display output
                $display("Output: out=%b, out_dec=%d", out, out);
            end
        end
        
        // End simulation
        $finish;
    end
endmodule
