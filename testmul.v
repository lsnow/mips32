`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:47:53 04/08/2014
// Design Name:   mul
// Module Name:   E:/eda/mul/testmul.v
// Project Name:  mul
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mul
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testmul;

	// Inputs
	reg [31:0] data_a;
	reg [31:0] data_b;
	reg sign;

	// Outputs
	wire [63:0] data_c;

	// Instantiate the Unit Under Test (UUT)
	mul uut (
		.data_c(data_c), 
		.data_a(data_a), 
		.data_b(data_b), 
		.sign(sign)
	);

	initial begin
		// Initialize Inputs
		data_a = 0;
		data_b = 0;
		sign = 1;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
    initial begin
        forever #20 data_b = data_b + 1;
    end
    always begin
        #200 data_a = 32'hffff0001;
          
    end
      
endmodule

