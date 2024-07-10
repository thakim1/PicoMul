module tb_x1_approx_add;

    // Inputs
    reg a;
    reg b;
    reg cin;

    // Output
    wire sum;
    wire cout;

    // Set parameter N4
    localparam N4 = 1; // Setting N4 to 1 for a 1-bit adder

    // Instantiate the adder
    x1_approx_add #(N4) UUT(
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );

    // Stimulus
    initial begin
        // Open VCD file for dumping
        $dumpfile("tb_x1_approx_add.vcd");
        // Dump variables
        //$dumpvars(0, tb_x1_approx_add);

        // Test some combinations of inputs
        // You can extend this loop to cover more cases if needed
        for (integer i = 0; i < 2; i = i + 1) begin
            for (integer j = 0; j < 2; j = j + 1) begin
                // Set inputs
                a = i;
                b = j;
                cin = 1'b0; // Set carry-in to 0 for simplicity
                
                // Display inputs and wait for a while
                $display("Input: a=%b, b=%b, cin=%b", a, b, cin);
                #10;
                
                // Display output
                $display("Output: sum=%b, cout=%b", sum, cout);
            end
        end
        
        // End simulation
        $finish;
    end
endmodule
