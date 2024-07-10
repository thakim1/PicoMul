module tb_x16_approx_add;

    // Inputs
    reg [15:0] a;
    reg [15:0] b;
    reg cin;

    // Output
    wire [15:0] sum;
    wire cout;

    // Set parameter N8
    // N8_MIN = 0, N8_MAX = 16
    localparam N8 = 0;

    // Instantiate the adder
    x16_approx_add #(N8) UUT(
        .a(a),
        .b(b),
        .cin_16bit(cin),
        .sum(sum),
        .cout_16bit(cout)
    );

    // Stimulus
    initial begin
        // Open VCD file for dumping
        $dumpfile("tb_x16_approx_add.vcd");
        // Dump variables
        // $dumpvars(0, tb_x16_approx_add);

        // Test some combinations of inputs
        for (integer i = 0; i < 65536; i = i + 1) begin
            for (integer j = 0; j < 65536; j = j + 1) begin
                // Set inputs
                a = i;
                b = j;
                cin = 1'b0; // Set carry-in to 0 for simplicity
                
                // Display inputs in binary and decimal formats
                $display("Input: a=%b (%d), b=%b (%d), cin=%b", a, a, b, b, cin);
                
                // Wait for a while
                #10;
                
                // Display output in binary and decimal formats
                $display("Output: sum=%b (%d), cout=%b", sum, sum, cout);
            end
        end
        
        // End simulation
        $finish;
    end
endmodule
