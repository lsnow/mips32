//=======================================================================
// Created by         :lt
// Filename           :cmp.v
// Author             :(RDC)
// Created On         :2014-04-28 10:34
// Last Modified      : 
// Update Count       :2014-04-28 10:34
// Description        :compare
//                     
//                     
//=======================================================================
module cmp(/*AUTOARG*/
    //Inputs
    data_a, data_b, 

    //Outputs
    res);
    input  [31:0]  data_a;
    input  [31:0]  data_b;

    output [1:0]   res;
    wire           res;
    //wire   [31:0]  tmp;

    //always @* begin
    //assign   tmp = data_a ^ data_b;

    assign   res = (data_a == data_b) ? 2'b00 : (data_a > data_b ? 2'b10 : 2'b01);
endmodule
