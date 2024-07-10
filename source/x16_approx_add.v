/*
 *  Implements 16bit approximate adder
 *
 *  Authors: Marcus Meysel, Karel Rusy, Hakim Tayari
 *  Date: 2024-07-10
 *
 *  Permission to use, copy, modify, and/or distribute this software for any
 *  purpose with or without fee is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHORS DISCLAIM ALL WARRANTIES
 *  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR
 *  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 *  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 *  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 *  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 */


module x16_approx_add #(parameter N8 = 0)(
    input [15:0] a,           // 16-bit input A
    input [15:0] b,           // 16-bit input B
    input cin_16bit,          // 1-bit input carry-in
    output [15:0] sum,        // 16-bit output sum
    output cout_16bit         // 1-bit output carry-out
);

    // Wire declarations
    wire [15:0] s;
    wire [15:0] c;

    // Instantiate approx adders and accu adders
    generate
        if (N8 == 0) begin
            // Use 16 x1_accu_add.v
            genvar i;
            for (i = 0; i < 16; i = i + 1) begin
                x1_accu_add a_inst(
                    .a(a[i]),
                    .b(b[i]),
                    .cin(i == 0 ? cin_16bit : c[i-1]),
                    .sum(sum[i]),
                    .cout(c[i])
                );
            end
            assign cout_16bit = c[15];
        end else begin
            // Use approx and accu adders based on N8
            genvar j;

            for (j = 0; j < N8; j = j + 1) begin
                x1_approx_add appr_inst(
                    .a(a[j]),
                    .b(b[j]),
                    .cin(j == 0 ? cin_16bit : c[j-1]),
                    .sum(sum[j]),
                    .cout(c[j])
                );
            end 

            genvar k;
            for (k = N8; k < 16; k = k + 1) begin
                x1_accu_add acc_inst(
                    .a(a[k]),
                    .b(b[k]),
                    .cin(k == N8 ? c[N8-1] : c[k-1]),
                    .sum(s[k]),
                    .cout(c[k])
                );
            end

            assign cout_16bit = c[15];
        end
    endgenerate

    // Output connections
    assign sum = {s[15:0]};

endmodule
