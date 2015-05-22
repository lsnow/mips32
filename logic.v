//=======================================================================
// Created by         :lt
// Filename           :logic.v
// Author             :(RDC)
// Created On         :2014-04-17 10:53
// Last Modified      : 
// Update Count       :2014-04-17 10:53
// Description        :
//                     
//                     
//=======================================================================
module logic(/*AUTOARG*/
    // inputs
    data_a, data_b, c,
    // outputs
    res
    );
    input  [31:0]  data_a;
    input  [31:0]  data_b;
    input  [3:0]   c;

    output [31:0]   res;
    reg    [31:0]   res;

    always @* begin
        case(c)
            4'b0001: res <= data_a | data_b;
            4'b0010: res <= data_a & data_b;
            4'b0100: res <= ~(data_a ^ data_b);
            4'b1000: res <= data_a ^ data_b;
            default: res <= 32'h00000000;
        endcase
    end
endmodule

