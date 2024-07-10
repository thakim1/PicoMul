module tb_x8_approx_add;

    // Inputs
    reg [7:0] a;
    reg [7:0] b;
    reg cin;

    // Output
    wire [7:0] sum;
    wire cout;

    // Set parameter N4 here
    // N4_MIN = 0, N4_MAX = 8
    localparam N4 = 5;

    // Instantiate the adder
    x8_approx_add #(N4) UUT(
        .a(a),
        .b(b),
        .cin_8bit(cin),
        .sum(sum),
        .cout_8bit(cout)
    );

    // Stimulus
    initial begin
        // Open VCD file for dumping
        $dumpfile("tb_x8_approx_add.vcd");
        // Dump variables
        // $dumpvars(0, tb_x8_approx_add);

        // Test some combinations of inputs
        for (integer i = 0; i < 256; i = i + 1) begin
            for (integer j = 0; j < 256; j = j + 1) begin
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
