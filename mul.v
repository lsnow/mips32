`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:29:32 03/26/2014 
// Design Name: 
// Module Name:    mul 
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
module mul(/*AUTOARG*/
	// Outputs
	data_c,
	// Inputs
	data_a, data_b, sign
	);
	input  [31:0]  data_a, data_b;
	input 		   sign;

	output [63:0]  data_c;

	wire   [63:0]  tmp_data_a, tmp_data_c, tmp_data_cu;
	reg    [31:0]  tmp_data_b;
	reg    [4:0]   i;

	/*AUTOWIRE*/
	/*AUTOREG*/
/*
	always @ * begin	
		tmp_data_a = ({32'h00000000, data_a});
		tmp_data_b = data_b;
		tmp_data_c = 0;
		for (i=0; i<5'b10000; i=i+1) begin
			if ((tmp_data_b & 1) == 1)
				tmp_data_c = tmp_data_c + tmp_data_a;
			tmp_data_a = tmp_data_a << 1;
			tmp_data_b = tmp_data_b >> 1;
		end
	end // always @ *

	
*/
    wire [31:0] ab0  = data_b[0] ? data_a : 32'b0;
    wire [31:0] ab1  = data_b[1] ? data_a : 32'b0;
    wire [31:0] ab2  = data_b[2] ? data_a : 32'b0;
    wire [31:0] ab3  = data_b[3] ? data_a : 32'b0;
    wire [31:0] ab4  = data_b[4] ? data_a : 32'b0;
    wire [31:0] ab5  = data_b[5] ? data_a : 32'b0;
    wire [31:0] ab6  = data_b[6] ? data_a : 32'b0;
    wire [31:0] ab7  = data_b[7] ? data_a : 32'b0;
    wire [31:0] ab8  = data_b[8] ? data_a : 32'b0;
    wire [31:0] ab9  = data_b[9] ? data_a : 32'b0;
    wire [31:0] ab10 = data_b[10] ? data_a : 32'b0;
    wire [31:0] ab11 = data_b[11] ? data_a : 32'b0;
    wire [31:0] ab12 = data_b[12] ? data_a : 32'b0;
    wire [31:0] ab13 = data_b[13] ? data_a : 32'b0;
    wire [31:0] ab14 = data_b[14] ? data_a : 32'b0; 
    wire [31:0] ab15 = data_b[15] ? data_a : 32'b0;
    wire [31:0] ab16 = data_b[16] ? data_a : 32'b0;
    wire [31:0] ab17 = data_b[17] ? data_a : 32'b0;
    wire [31:0] ab18 = data_b[18] ? data_a : 32'b0;
    wire [31:0] ab19 = data_b[19] ? data_a : 32'b0;
    wire [31:0] ab20 = data_b[20] ? data_a : 32'b0;
    wire [31:0] ab21 = data_b[21] ? data_a : 32'b0;
    wire [31:0] ab22 = data_b[22] ? data_a : 32'b0;
    wire [31:0] ab23 = data_b[23] ? data_a : 32'b0;
    wire [31:0] ab24 = data_b[24] ? data_a : 32'b0;
    wire [31:0] ab25 = data_b[25] ? data_a : 32'b0;
    wire [31:0] ab26 = data_b[26] ? data_a : 32'b0;
    wire [31:0] ab27 = data_b[27] ? data_a : 32'b0;
    wire [31:0] ab28 = data_b[28] ? data_a : 32'b0;
    wire [31:0] ab29 = data_b[29] ? data_a : 32'b0;
    wire [31:0] ab30 = data_b[30] ? data_a : 32'b0;
    wire [31:0] ab31 = data_b[31] ? data_a : 32'b0;

    assign tmp_data_cu = (((({32'b0, ab0[31:0]}           +
                            {31'b0, ab1[31:0],  1'b0})   +
                           ({30'b0, ab2[31:0],  2'b0}    +
                            {29'b0, ab3[31:0],  3'b0}))  +
                          (({28'b0, ab4[31:0],  4'b0}    +
                            {27'b0, ab5[31:0],  5'b0})   +
                           ({26'b0, ab6[31:0],  6'b0}    +
                            {25'b0, ab7[31:0],  7'b0}))) +
                         ((({24'b0, ab8[31:0],  8'b0}    +
                            {23'b0, ab9[31:0],  9'b0})   +
                           ({22'b0, ab10[31:0], 10'b0}   +
                            {21'b0, ab11[31:0], 11'b0})) +
                          (({20'b0, ab12[31:0], 12'b0}   +
                            {19'b0, ab13[31:0], 13'b0})  +
                           ({18'b0, ab14[31:0], 14'b0}   +
                            {17'b0, ab15[31:0], 15'b0}))))  +
                        (((({16'b0, ab16[31:0], 16'b0}   +
                            {15'b0, ab17[31:0], 17'b0})  +
                           ({14'b0, ab18[31:0], 18'b0}   +
                            {13'b0, ab19[31:0], 19'b0})) +
                          (({12'b0, ab20[31:0], 20'b0}   +
                            {11'b0, ab21[31:0], 21'b0})  +
                           ({10'b0, ab22[31:0], 22'b0}   +
                            { 9'b0, ab23[31:0], 23'b0})))+
                         ((({ 8'b0, ab24[31:0], 24'b0}   +
                            { 7'b0, ab25[31:0], 25'b0})  +
                           ({ 6'b0, ab26[31:0], 26'b0}   +
                            { 5'b0, ab27[31:0], 27'b0})) +
                          (({ 4'b0, ab28[31:0], 28'b0}   +
                            { 3'b0, ab29[31:0], 29'b0})  +
                           ({ 2'b0, ab30[31:0], 30'b0}   +
                            { 1'b0, ab31[31:0], 31'b0}))));
    assign tmp_data_c = (((({32'b1, ~ab0[31], ab0[30:0]}           +
                            {31'b0, ~ab1[31], ab1[30:0],  1'b0})   +
                           ({30'b0, ~ab2[31], ab2[30:0],  2'b0}    +
                            {29'b0, ~ab3[31], ab3[30:0],  3'b0}))  +
                          (({28'b0, ~ab4[31], ab4[30:0],  4'b0}    +
                            {27'b0, ~ab5[31], ab5[30:0],  5'b0})   +
                           ({26'b0, ~ab6[31], ab6[30:0],  6'b0}    +
                            {25'b0, ~ab7[31], ab7[30:0],  7'b0}))) +
                         ((({24'b0, ~ab8[31], ab8[30:0],  8'b0}    +
                            {23'b0, ~ab9[31], ab9[30:0],  9'b0})   +
                           ({22'b0, ~ab10[31], ab10[30:0], 10'b0}   +
                            {21'b0, ~ab11[31], ab11[30:0], 11'b0})) +
                          (({20'b0, ~ab12[31], ab12[30:0], 12'b0}   +
                            {19'b0, ~ab13[31], ab13[30:0], 13'b0})  +
                           ({18'b0, ~ab14[31], ab14[30:0], 14'b0}   +
                            {17'b0, ~ab15[31], ab15[30:0], 15'b0}))))  +
                        (((({16'b0, ~ab16[31], ab16[30:0], 16'b0}   +
                            {15'b0, ~ab17[31], ab17[30:0], 17'b0})  +
                           ({14'b0, ~ab18[31], ab18[30:0], 18'b0}   +
                            {13'b0, ~ab19[31], ab19[30:0], 19'b0})) +
                          (({12'b0, ~ab20[31], ab20[30:0], 20'b0}   +
                            {11'b0, ~ab21[31], ab21[30:0], 21'b0})  +
                           ({10'b0, ~ab22[31], ab22[30:0], 22'b0}   +
                            { 9'b0, ~ab23[31], ab23[30:0], 23'b0})))+
                         ((({ 8'b0, ~ab24[31], ab24[30:0], 24'b0}   +
                            { 7'b0, ~ab25[31], ab25[30:0], 25'b0})  +
                           ({ 6'b0, ~ab26[31], ab26[30:0], 26'b0}   +
                            { 5'b0, ~ab27[31], ab27[30:0], 27'b0})) +
                          (({ 4'b0, ~ab28[31], ab28[30:0], 28'b0}   +
                            { 3'b0, ~ab29[31], ab29[30:0], 29'b0})  +
                           ({ 2'b0, ~ab30[31], ab30[30:0], 30'b0}   +
                            { 1'b1, ab31[31], ~ab31[30:0], 31'b0}))));
                        
    assign data_c = sign ? tmp_data_c : tmp_data_cu;
endmodule
