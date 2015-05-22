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
module alu(/*AUTOARG*/
    //Inputs
    clk, data_a, data_b, data_c, aluc,
    sign, 

    //Outputs
    data_out, data_out_t,overflow, ready);
    input         clk;
    input  [31:0] data_a; // rs , imm
    input  [31:0] data_b; // rt
    input  [31:0] data_c;
    input  [20:0] aluc;

    wire 	      add, sub, mul, div, madd, msub;
    wire   [2:0]  shift;
    wire   [3:0]  _logic;
    wire          cmp;
    wire   [2:0]  cloz;
    assign  {add, sub, mul, div, madd, msub, shift, _logic, cmp, cloz} = aluc; 
    input 	      sign;
   

    output reg    [31:0] data_out, data_out_t;
    output        overflow, ready;
    
    reg           start, tmp;
    wire          done;
	// End of automatics
    
    wire   [1:0]  out_mux;
    //res_0: addsub
    //res_1: shift
    //res_2: logic
    wire   [31:0] res_0, res_1, res_2, res_cloz;
    wire   [63:0] res_3, res_4;
    wire   [1:0]  res_cmp; 
    always @(posedge clk) begin
        if(div) begin
            start <= 1;
            tmp <= 1;
        end
        if(div == 1 && tmp == 1)
            start <= 0;
    end

    wire    addsub = {add, sub};
    addsub addsub_0(.overflow           (overflow),
                    .data_c				(res_0),
					//.clk				(clk),
					.data_a				(data_a[31:0]),
					.data_b				(data_b[31:0]),
					.sign				(sign),
					.addsub		    	(addsub));

    mul mul_0(
              .sign(sign),
              .data_a(data_a),
              .data_b(data_b),
              .data_c(res_3));

    div div_0(.clk(clk),
              .sign(sign),
              .start(start),
              .done(done),
              .data_a(data_a),
              .data_b(data_b),
              .data_q(res_4[63:32]),
              .data_r(res_4[31:0]));

    shift shift_0(.d(data_a),
                  .sa(data_c),
                  .c(shift),
                  .res(res_1));

    logic logic_0(.data_a(data_a),
                  .data_b(data_b),
                  .c(_logic),
                  .res(res_2));
    cmp     cmp_0(/*AUTOINST*/
        //Inputs
        .data_a (data_a),
        .data_b (data_b),
        //Outputs
        .res    (res_cmp));
    cloz   cloz_0(/*AUTOINST*/
        .io       (cloz),
        .data_in  (data_b),
        .data_out (res_cloz));
       
    always @* begin
        case ({add, sub, mul, div, madd, msub, |shift, |_logic, cmp, |cloz})
            10'b1000000000: data_out <= res_0;
            10'b0100000000: data_out <= res_0;
            10'b0010000000: {data_out, data_out_t} <= res_3;
            10'b0001000000: {data_out, data_out_t} <= res_4;
            10'b0000100000: {data_out, data_out_t} <= res_3;
            10'b0000010000: {data_out, data_out_t} <= res_3;
            10'b0000001000: data_out <= res_1;
            10'b0000000100: data_out <= res_2;
            10'b0000000010: data_out <= {30'b0,res_cmp};
            10'b0000000001: data_out <= res_cloz;
            default: {data_out, data_out_t} <= 64'b0;
        endcase
    end
    assign ready = div ? done : 1;
endmodule
