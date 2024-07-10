/*
 *  Implements 2bit approximate multiplier
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


/*module x2_approx_mul ( // Accureate Module for testing
    
    input [1:0] a, // 2-bit input A
    input [1:0] b, // 2-bit input B
    output [3:0] out // 4-bit output result
);
    assign out = a*b;

endmodule
*/


module x2_approx_mul (

    input [1:0] a, // 2-bit input A
    input [1:0] b, // 2-bit input B
    output [3:0] out // 4-bit output result
);

assign out[0] = a[0] & b[0];
assign out[1] = (a[0] & b[1]) ^ (a[1] & b[0]);
assign out[2] = a[1] & b[1];
assign out[3] = a[1] & b[1];

endmodule