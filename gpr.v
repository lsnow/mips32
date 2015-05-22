`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:29:57 03/24/2014 
// Design Name: 
// Module Name:    gpr 
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
module gpr(clk, regwrite, data_in, reg_addr1, reg_addr2, write_addr, reg_out1, reg_out2
    );
    input   clk;
    input   regwrite;
    input   [31:0]  data_in;
    input   [4:0]   reg_addr1, reg_addr2;
    input   [4:0]   write_addr;

    output  [31:0]  reg_out1, reg_out2;

    reg    [31:0] gpr_reg [31:0];
    
    always @(posedge clk) begin
        if(regwrite && write_addr != 5'h00)
            gpr_reg[write_addr] <= data_in;
    end
    assign reg_out1 = (reg_addr1 == 5'b00) ? 32'b0 : gpr_reg[reg_addr1];
    assign reg_out2 = (reg_addr2 == 5'b00) ? 32'b0 : gpr_reg[reg_addr2];

endmodule
