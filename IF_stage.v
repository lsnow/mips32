//=======================================================================
// Created by         :
// Filename           :pc.v
// Author             :(RDC)
// Created On         :2014-05-08 08:49
// Last Modified      : 
// Update Count       :2014-05-08 08:49
// Description        :
//                     
//                     
//=======================================================================
module IF_stage(/*AUTOARG*/
    //Inputs
    clk, rst, IF_stall, IF_flush, ID_stall, IF_inst, 
    IF_PCnext, IF_PC, 

    //Outputs
    ID_inst,ID_PCnext);
    input           clk;
    input           rst;
    input           IF_stall;
    input           IF_flush;
    input           ID_stall;
    input   [31:0]  IF_inst;
    input   [31:0]  IF_PCnext;
    input   [31:0]  IF_PC;
    //outputs
    output  reg     [31:0]  ID_inst;
    output  reg     [31:0]  ID_PCnext;
    
    always @(posedge clk) begin
        ID_inst <= rst ? 32'b0 : (ID_stall ? ID_inst : ((IF_stall | IF_flush) ? 32'b0 : IF_inst));
        ID_PCnext <= rst ? 32'b0 : (ID_stall ? ID_PCnext : IF_PCnext);

    end
endmodule
