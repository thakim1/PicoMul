/*
 *  Implements 8bit approximate multiplier
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


module x8_approx_mul #(parameter N8 = 0, parameter N4 = 0)(
        // N8 is "used" by giving it to the x16 adder, N4 is passed down do the next lower mul
    input [7:0] a, // 8-bit input A
    input [7:0] b, // 8-bit input B
    output [15:0] out // 16-bit output result
);
    // define intermediate results
    wire [7:0] p0, p1, p2, p3;

    wire [15:0] s0, s1, s2;
    
    wire carry_bit_0;
    wire carry_bit_1;
    wire carry_bit_2;
    
    // instatiaiate 4 multiplyers
    x4_approx_mul #(N4) M0(a[3:0], b[3:0],p0); 
    x4_approx_mul #(N4) M1(a[3:0], b[7:4],p1); 
    x4_approx_mul #(N4) M2(a[7:4], b[3:0],p2); 
    x4_approx_mul #(N4) M3(a[7:4], b[7:4],p3); 

    // instantiate 3 adders
    x16_approx_add #(N8) A1({8'b00000000, p0}, {4'b0000, p1, 4'b0000}, 1'b0, s0, carry_bit_0); // a,b,cin,sum,cout
    x16_approx_add #(N8) A2({4'b0000, p2, 4'b0000}, {p3, 8'b00000000}, 1'b0, s1, carry_bit_1); 
    x16_approx_add #(N8) A3(s0, s1, 1'b0, s2, carry_bit_2);
    // the carrys can just be forgotten, because the structure forces them to be zero even with maximum input

    assign out = s2; 

endmodule
