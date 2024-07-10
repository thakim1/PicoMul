/*
 *  Implements 16bit approximate multiplier
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
            // N16 is "used" by giving it to the x32 adder, N8 and N4 are passed down do the next lower mul
    input [15:0] a, // 16-bit input A
    input [15:0] b, // 16-bit input B
    output [31:0] out // 32-bit output result
);
    // define intermediate results
    wire [15:0] p0, p1, p2, p3;

    wire [31:0] s0, s1, s2;
    
    wire carry_bit_0;
    wire carry_bit_1;
    wire carry_bit_2;

    // Instantiate 4 multipliers
    x8_approx_mul #(N8, N4) M0(a[7:0], b[7:0],p0); 
    x8_approx_mul #(N8, N4) M1(a[7:0], b[15:8],p1); 
    x8_approx_mul #(N8, N4) M2(a[15:8], b[7:0],p2); 
    x8_approx_mul #(N8, N4) M3(a[15:8], b[15:8],p3);

    x32_approx_add #(N16) A1({16'b0000000000000000, p0}, {8'b00000000, p1, 8'b00000000}, 1'b0, s0, carry_bit_0); // a,b,cin,sum,cout
    x32_approx_add #(N16) A2({8'b00000000, p2, 8'b00000000}, {p3, 16'b0000000000000000}, 1'b0, s1, carry_bit_1); 
    x32_approx_add #(N16) A3(s0, s1, 1'b0, s2, carry_bit_2);
    // the carrys can just be forgotten, because the structure forces them to be zero even with maximum input
    assign out = s2;
endmodule
