`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:55:01 05/11/2014 
// Design Name: 
// Module Name:    EXE_stage 
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
module EX_stage(/*AUTOARG*/
    //Inputs
    clk, rst, EX_stall, EX_flush, M_stall, EX_regwrite, 
    EX_memtoreg, EX_memread, EX_memwrite, EX_memaddr, 
    EX_load_op, EX_store_op, EX_alu_out, EX_alu_out_t, 
    EX_rt_rd, 

    //Outputs
    M_regwrite, M_memtoreg, M_memread,
    M_memwrite, M_memaddr, M_load_op,
    M_store_op, M_alu_out, M_rt_rd);
    input   clk;
    input   rst;
    input   EX_stall;
    input   EX_flush;
    input   M_stall;
    input   EX_regwrite;
    input   EX_memtoreg;
    input   EX_memread;
    input   EX_memwrite;
    input   [31:0]  EX_memaddr;
    input   [8:0]   EX_load_op;
    input   [5:0]   EX_store_op;
    input   [31:0]  EX_alu_out;
    input   [31:0]  EX_alu_out_t;
    input   [4:0]   EX_rt_rd;

    output  reg M_regwrite;
    output  reg M_memtoreg;
    output  reg M_memread;
    output  reg M_memwrite;
    output  reg [31:0]  M_memaddr;
    output  reg [8:0]   M_load_op;
    output  reg [5:0]   M_store_op;
    output  reg [31:0]  M_alu_out;
    output  reg [4:0]   M_rt_rd;

    always @(posedge clk) begin
        M_regwrite  <= rst ? 0     : (M_stall ? M_regwrite : ((EX_stall | EX_flush) ? 0 : EX_regwrite));
        M_memtoreg  <= rst ? 0     : (M_stall ? M_memtoreg : EX_memtoreg);
        M_memwrite  <= rst ? 0     : (M_stall ? M_memwrite : ((EX_stall | EX_flush) ? 0 : EX_memwrite));
        M_memread   <= rst ? 0     : (M_stall ? M_memread  : ((EX_stall | EX_flush) ? 0 : EX_memread));
        M_memaddr   <= rst ? 0     : (M_stall ? M_memaddr  : ((EX_stall | EX_flush) ? 0 : EX_memaddr));
        M_load_op   <= rst ? 9'b0  : (M_stall ? M_load_op  : EX_load_op);
        M_store_op  <= rst ? 6'b0  : (M_stall ? M_store_op : EX_store_op);
        M_alu_out   <= rst ? 32'b0 : (M_stall ? M_alu_out  : EX_alu_out);
        M_rt_rd     <= rst ? 5'b0  : (M_stall ? M_rt_rd    : EX_rt_rd);
    end

endmodule
