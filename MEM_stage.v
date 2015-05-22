`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:55:25 05/11/2014 
// Design Name: 
// Module Name:    MEM_stage 
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
module MEM_stage(/*AUTOARG*/
    //Inputs
    clk, rst, M_flush, M_stall, WB_stall, M_regwrite, 
    M_memtoreg, M_alu_out, M_rt_rd, M_readdata,

    //Outputs
    WB_regwrite, WB_memtoreg, WB_alu_out, WB_rt_rd,WB_readdata);
    input   clk;
    input   rst;
    input   M_flush;
    input   M_stall;
    input   WB_stall;
    input   M_regwrite;
    input   M_memtoreg;
    input   [31:0]  M_alu_out;
    input   [31:0]  M_readdata;
    input   [4:0]   M_rt_rd;

    output  reg WB_regwrite;
    output  reg WB_memtoreg;
    output  reg [31:0]  WB_readdata;
    output  reg [31:0]  WB_alu_out;
    output  reg [4:0]   WB_rt_rd;

    always @(posedge clk) begin
        WB_regwrite  <= rst ? 0     : (WB_stall ? WB_regwrite : ((M_flush | M_stall ) ? 0 : M_regwrite));
        WB_memtoreg  <= rst ? 0     : (WB_stall ? WB_memtoreg : M_memtoreg);
        WB_alu_out   <= rst ? 32'b0 : (WB_stall ? WB_alu_out  : M_alu_out);
        WB_readdata  <= rst ? 32'b0 : (WB_stall ? WB_readdata : M_readdata);
        WB_rt_rd     <= rst ? 5'b0  : (WB_stall ? WB_rt_rd    : M_rt_rd);
    end

endmodule
