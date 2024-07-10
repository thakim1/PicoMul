/*
 *  Implements 16bit clocked approximate multiplier
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


module x16_approx_mul #(parameter N16 = 0, parameter N8 = 0, parameter N4 = 0)(
    input clk,            // Clock signal
    input reset,          // Reset signal
    input [15:0] a,       // 16-bit input A
    input [15:0] b,       // 16-bit input B
    output reg [31:0] out // 32-bit output result
);
    // define intermediate results
    reg [15:0] p0, p1, p2, p3;
    reg [31:0] s0, s1, s2;
    
    wire carry_bit_0;
    wire carry_bit_1;
    wire carry_bit_2;

    // Intermediate wires for multiplier outputs
    wire [15:0] p0_w, p1_w, p2_w, p3_w;
    wire [31:0] s0_w, s1_w, s2_w;

    // Instantiate 4 multipliers
    x8_approx_mul #(N8, N4) M0(a[7:0], b[7:0], p0_w); 
    x8_approx_mul #(N8, N4) M1(a[7:0], b[15:8], p1_w); 
    x8_approx_mul #(N8, N4) M2(a[15:8], b[7:0], p2_w); 
    x8_approx_mul #(N8, N4) M3(a[15:8], b[15:8], p3_w); 

    // Instantiate 3 adders
    x32_approx_add #(N16) A1({16'b0, p0}, {8'b0, p1, 8'b0}, 1'b0, s0_w, carry_bit_0); 
    x32_approx_add #(N16) A2({8'b0, p2, 8'b0}, {p3, 16'b0}, 1'b0, s1_w, carry_bit_1); 
    x32_approx_add #(N16) A3(s0_w, s1_w, 1'b0, s2_w, carry_bit_2);

    // Register assignments
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            p0 <= 16'b0;
            p1 <= 16'b0;
            p2 <= 16'b0;
            p3 <= 16'b0;
            s0 <= 32'b0;
            s1 <= 32'b0;
            s2 <= 32'b0;
            out <= 32'b0;
        end else begin
            p0 <= p0_w;
            p1 <= p1_w;
            p2 <= p2_w;
            p3 <= p3_w;
            s0 <= s0_w;
            s1 <= s1_w;
            s2 <= s2_w;
            out <= s2_w;
        end
    end

endmodule
