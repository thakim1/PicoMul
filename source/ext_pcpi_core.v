/*
 *  Implements external pcpi core for picoSoC
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

module ext_pcpi_core #(
    parameter N16 = 0, // Parameters for x16_approx_mul
    parameter N8 = 0,
    parameter N4 = 0
) (
    input clk, resetn,
    input             pcpi_valid,
    input      [31:0] pcpi_insn,
    input      [31:0] pcpi_rs1,
    input      [31:0] pcpi_rs2,
    output reg        pcpi_wr,
    output reg [31:0] pcpi_rd,
    output reg        pcpi_wait,
    output reg        pcpi_ready
);

    // State Declaration
    localparam IDLE = 0,
               CHECK = 1,
               EXECUTE = 2,
               WRITE_BACK = 3;

    reg [2:0] state, next_state;
    reg operation_done;
    reg [15:0] a, b;
    wire [31:0] result;
    reg instr_approx_mul;

    // Instantiate approximation hardware with 
    // zero approximation in the adders:
    x16_approx_mul #(.N4(N4), .N8(N8), .N16(N16)) mul_instance (
        .a(a),
        .b(b),
        .out(result)
    );

    // State change on clock or reset
    always @(posedge clk) begin
        if (!resetn)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Counter to count cycles and handle reset state for a and b
    always @(posedge clk) begin
        if (!resetn) begin
            a <= 16'b0;
            b <= 16'b0;
        end else if (state == EXECUTE) begin
                a <= pcpi_rs1[15:0];
                b <= pcpi_rs2[15:0];
        end
    end

    always @(posedge clk) begin
        instr_approx_mul <= 0; 

        // Check if the current instruction matches the approx_mul macro 
        if (resetn && pcpi_valid && pcpi_insn[6:0] == 7'b01011 && pcpi_insn[31:25] == 7'b0000001 && pcpi_insn[14:12] == 3'b000) begin
            instr_approx_mul <= 1; // Set flag if instruction matches
        end
    end

    // Determine state transitions
    always @(*) begin
        case (state)
            IDLE:
                next_state = pcpi_valid ? CHECK : IDLE;

            CHECK:
                if (instr_approx_mul && pcpi_valid)
                    next_state = EXECUTE;
                else
                    next_state = IDLE;

            EXECUTE:
                next_state = WRITE_BACK;

            WRITE_BACK:
                next_state = IDLE;  // After writing back, go to idle

            default:
                next_state = IDLE;  // Default state is Idle
        endcase
    end

    // Manage output registers and flags
    always @(posedge clk) begin
        if (!resetn) begin
            pcpi_ready <= 0;
            pcpi_wait <= 0;
            pcpi_rd <= 32'b0;
            pcpi_wr <= 0;
		end else begin
            pcpi_ready <= (state == WRITE_BACK);
            pcpi_wait <= (state == EXECUTE);
            if (state == WRITE_BACK) begin
                pcpi_rd <= result;
                pcpi_wr <= 1'b1;
            end else begin
                pcpi_rd <= 32'b0; // Clear output if not writing back
                pcpi_wr <= 1'b0;  // Clear write flag if not writing back
            end
        end
    end
endmodule