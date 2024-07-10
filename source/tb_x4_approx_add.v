module tb_x4_approx_add;

    // Inputs
    reg [3:0] a;
    reg [3:0] b;
    reg cin;

    // Output
    wire [3:0] sum;
    wire cout;

    // Set parameter N2
    // N2_MIN = 0, N2_MAX = 4
    localparam N2 = 0;

    // Instantiate the adder
    x4_approx_add #(N2) UUT(
        .a(a),
        .b(b),
        .cin_4bit(cin),
        .sum(sum),
        .cout_4bit(cout)
    );

    // Stimulus
    initial begin
        // Open VCD file for dumping
        $dumpfile("tb_x4_approx_add.vcd");
        // Dump variables
        // $dumpvars(0, tb_x4_approx_add);

        // Test some combinations of inputs
        for (integer i = 0; i < 16; i = i + 1) begin
            for (integer j = 0; j < 16; j = j + 1) begin
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
