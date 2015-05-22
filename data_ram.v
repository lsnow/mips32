`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:29:03 05/06/2014 
// Design Name: 
// Module Name:    data_ram 
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
module data_ram(/*AUTOARG*/
    //Inputs
    clk, rst, m_read, m_write, m_addr, m_din, 

    //Outputs
    m_dout);
    input           clk, rst;
    input           m_read;
    input           m_write;
    //input           m_strobe;
    input   [31:0]  m_addr;
    input   [31:0]  m_din;
    output  reg     [31:0]  m_dout;
    reg             m_ready;
    integer i;
    reg     [31:0]  ram  [2<<10 - 1:0];
    wire    [9:0]   r_addr = m_addr[9:0];

    always @(posedge clk) begin
        if(rst) begin
     
            for (i = 0; i < 1024; i = i+1)
                ram[i] <= 32'b0;
        end else if (m_write) begin // write
            ram[r_addr] <= m_din;
            m_ready <= 1'b1;
        end
    end
    always @(posedge clk) begin
        if (m_read == 1'b1)
            m_dout = ram[r_addr];
    end
endmodule
