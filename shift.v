`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:30:12 03/26/2014 
// Design Name: 
// Module Name:    shift 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module shift(/*AUTOARG*/
    //Inputs
    d, sa, c, 

    //Outputs
    res);
    input  [31:0]   d;
    input  [4:0]    sa;
    input  [2:0]    c;

    output reg  [31:0]   res;

    /*AUTOREG*/

    always @* begin
        case (c)
            3'b001: res <= d >> sa; //shift right logic
            3'b010: res <= $signed(d) >>> sa; // shift right arithmetic
            3'b100: res <= d << sa; // shift left logic
        endcase
    end
   
endmodule
