`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:30:32 03/24/2014 
// Design Name: 
// Module Name:    rom 
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
// A module used to mimic inst memory, for the EC413 project.
// Returns hardcoded instructions based on the current PC.
//
// DATA_WIDTH: instruction and data width (i.e 32 bits).
//
// IMPORTANT!
// Which test program to use:
// - PROGRAM_1: first simple hello world example.
`define PROGRAM_1
// Change the previous line to try a different program,
// when available.
// ----------------------------------------------------

module rom(
           PC,
           inst,
		   clk);

parameter DATA_WIDTH= 32;
`ifdef PROGRAM_1
	parameter PROG_LENGTH= 16;
`endif
//-------------Input Ports-----------------------------
input [DATA_WIDTH-1:0] PC;
input clk;
//-------------Output Ports----------------------------
output [DATA_WIDTH-1:0] inst;
reg [DATA_WIDTH-1:0] inst;
//------------Code Starts Here-------------------------
always @(posedge clk)
begin
case(PC)
`ifdef PROGRAM_1

	//
	// First part: 
	// Load values into:
	// $R0 = -1
	// $R1 = 0
	// $R2 = 2
	// Add $R0 and $R2 and get an answer in $R3: 
	// -1 + 2 = 1
	//

	// LI   $R0, 0xFFFF
	32'h0000_0000 : inst<= 32'b111001_00000_00000_1111111111111111;
	// LUI  $R0, 0xFFFF
	32'h0000_0004: inst<= 32'b111010_00000_00000_1111111111111111;
	// LI   $R1, 0x0000
	32'h0000_0008: inst<= 32'b111001_00001_00000_0000000000000000;
	// LUI  $R1, 0x0000
	32'h0000_000c: inst<= 32'b111010_00001_00000_0000000000000000;
	// LI   $R2, 0x0002
	32'h0000_0010: inst<= 32'b111001_00010_00000_0000000000000010;
	// LUI  $R2, 0x0000
	32'h0000_0014: inst<= 32'b111010_00010_00000_0000000000000000;
	// ADD  $R3, $R0, $R2
	32'h0000_0018: inst<= 32'b010010_00011_00000_00010_00000000000;

	//
	// Second part: store and load, should store $R3
	// (contains 1) into address 5.  Then load from 
	// address 5 into register $R1.  $R1 should then 
	// contain 1.
	//

	// SWI  $R3, [0x5]
	32'h0000_001c: inst<= 32'b111100_00011_00000_0000000000000101;
	// LWI  $R1, [0x5]
	32'h0000_0020: inst<= 32'b111011_00001_00000_0000000000000101;


	//
	// Third part: simple loop test, loop $R0 from -1 to 1
	//

	// ADDI $R0, $R0, 0x0001
	32'h0000_0024: inst<= 32'b110010_00000_00000_0000000000000001;
	// SLT  $R31, $R0, $R1
	32'h0000_0028: inst<= 32'b010111_11111_00000_00001_00000000000;
	// BNEZ $R31, 0xFFFD
	32'h0000_002c: inst<= 32'b100001_11111_00000_1111111111111101;

	//
	// Fourth part: test jump by _skipping_ load instructions
	// at PCs 13 and 14.  Contents of $R0 should still be 1.
	// Afterwards 1 is subtracted with SUBI and final output 
	// should be 0.
	//

	// J    15
	32'h0000_0030: inst<= 32'b000001_00000000000000000000001111;
	// LI   $R0, 0xFFFF
	32'h0000_0034: inst<= 32'b111001_00000_00000_1111111111111111;
	// LUI  $R0, 0xFFFF
	32'h0000_0038: inst<= 32'b111010_00000_00000_1111111111111111;
	// SUBI $R0, $R0, 0x0001
	32'h0000_003c: inst<= 32'b110011_00000_00000_0000000000000001;
`endif
	default: inst<= 0; //NOOP
endcase
end

endmodule

