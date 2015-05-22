`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:56:25 03/27/2014 
// Design Name: 
// Module Name:    alu 
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

module addsub(/*AUTOARG*/
	// Outputs
	data_c,overflow,
	// Inputs
	data_a, data_b, sign, addsub
	);
	// input            clk;
	
	input  [31:0]    data_a;
	input  [31:0] 	 data_b;
	//input  [31:0] 	 data_c;
	input 			 sign;
	input 			 addsub;

	output           overflow;
	reg    [32:0]    temp;
	
	output reg  [31:0] data_c;
    

	always @(/*AUTOSENSE*/addsub or data_a or data_b or sign) begin
		case ({addsub, sign})
			00:
				temp <= {data_a[31], data_a} + {data_b[31], data_b};
			    
			01:
			    temp[31:0] <= data_a + data_b;
			10:
				temp <= {data_b[31], data_b} - {data_a[31], data_a};
			11:
				temp[31:0] <= data_b - data_a;
			default:
				data_c <= 32'h00000000;
		endcase // case ({add_sub, sign})
		data_c <= temp[31:0];
 
	end
	assign overflow = temp[32] != temp[31];
	
endmodule // addsub
