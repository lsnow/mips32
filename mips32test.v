`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:31:02 05/20/2014
// Design Name:   mips32
// Module Name:   F:/mips32/mips32test.v
// Project Name:  mips32
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mips32
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module mips32test;

	// Inputs
	reg rst;
	reg clk;
	reg [4:0] interrupts;

	// Outputs
	wire [31:0] port_PC;
	wire [31:0] port_inst;
	wire [31:0] port_alu;

	// Instantiate the Unit Under Test (UUT)
	mips32 uut (
		.port_PC(port_PC), 
		.port_inst(port_inst), 
		.port_alu(port_alu), 
		.rst(rst), 
		.clk(clk), 
		.interrupts(interrupts)
	);

	initial begin
		// Initialize Inputs
		rst = 0;
		clk = 0;
		interrupts = 0;

		// Wait 100 ns for global reset to finish
		#100 rst = 1;
        #20  rst = 0;
        
		// Add stimulus here

	end
    initial begin
        forever #20 clk = ~clk;
    end
endmodule

