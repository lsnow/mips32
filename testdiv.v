`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:44:35 04/13/2014
// Design Name:   div
// Module Name:   E:/eda/div/testdiv.v
// Project Name:  div
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: div
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testdiv;

	// Inputs
	reg clk;
	reg start;
	reg [31:0] data_a;
	reg [31:0] data_b;
	reg u;

	// Outputs
	wire [31:0] data_q;
	wire [31:0] data_r;
	wire done;

	// Instantiate the Unit Under Test (UUT)
	div uut (
		.data_q(data_q), 
		.data_r(data_r), 
		.done(done), 
		.clk(clk), 
		.start(start), 
		.data_a(data_a), 
		.data_b(data_b), 
		.sign(u)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		start = 0;
		data_a = 0;
		data_b = 0;
		u = 0;

		// Wait 100 ns for global reset to finish
		#100 start = 1;
             u     = 1;   
        #20  start = 0;
       
		// Add stimulus here
	end
    initial begin
        forever #20 clk = ~clk;
    end
    always begin
        //#50 data_a = 32'h000000ff;
        //    data_b = 32'h00000030;
        #50
             data_a = 32'hffffff01;
             data_b = 32'h00000030;
    end
endmodule

