`timescale 1ns / 1ps
/*
 * File         : Mux2.v
 * Project      : University of Utah, XUM Project MIPS32 core
 * Creator(s)   : Grant Ayers (ayers@cs.utah.edu)
 *
 * Modification History:
 *   Rev   Date         Initials  Description of Change
 *   1.0   7-Jun-2011   GEA       Initial design.
 *
 * Standards/Formatting:
 *   Verilog 2001, 4 soft tab, wide column.
 *
 * Description:
 *   A 2-input Mux of variable width, defaulting to 32-bit width.
 */
module mux2 #(parameter WIDTH = 32)(
    input  sel,
    input  [(WIDTH-1):0] in0, in1,
    output reg [(WIDTH-1):0] out
    );

    always @* begin
        case (sel)
            1'b0    : out <= in0;
            1'b1    : out <= in1;
            default : out <= in0;
        endcase
    end
endmodule

