/*
 *   Implements 4bit approximate multiplier
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


module x4_approx_mul #(parameter N4 = 0)(
            // N4 is being "used" by giving it to the x8 adder
    input [3:0] a, // 4-bit input A
    input [3:0] b, // 4-bit input B
    output [7:0] out // 8-bit output result
);
    // define intermediate results
    wire [3:0] p0, p1, p2, p3;

    wire [7:0] s0, s1, s2;
    
    wire carry_bit_0;
    wire carry_bit_1;
    wire carry_bit_2;
    
    // instatiaiate 4 multiplyers
    x2_approx_mul M0(a[1:0], b[1:0],p0); 
    x2_approx_mul M1(a[1:0], b[3:2],p1); 
    x2_approx_mul M2(a[3:2], b[1:0],p2); 
    x2_approx_mul M3(a[3:2], b[3:2],p3); 

    // instantiate 3 adders
    x8_approx_add #(N4) A1({4'b0000, p0}, {2'b00, p1, 2'b00}, 1'b0, s0, carry_bit_0); // a,b,cin,sum,cout
    x8_approx_add #(N4) A2({2'b00, p2, 2'b00}, {p3, 4'b0000}, 1'b0, s1, carry_bit_1); 
    x8_approx_add #(N4) A3(s0, s1, 1'b0, s2, carry_bit_2);
    // the carrys can just be forgotten, because the structure forces them to be zero even with maximum input

    assign out = s2; 

endmodule
