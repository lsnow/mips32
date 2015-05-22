`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:29:54 03/26/2014 
// Design Name: 
// Module Name:    div 
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
module div(/*AUTOARG*/
	// Outputs
	data_q, data_r, done,
	// Inputs
	clk, start, data_a, data_b, sign
	);
    input           clk, start;
    input   [31:0]  data_a, data_b;
    input           sign;              /* sign or unsigned */

    output  [31:0]  data_q, data_r;
    output          done;

    /*AUTOREG*/
	// Beginning of automatic regs (for this module's undeclared outputs)
	reg					done;
	// End of automatics
    /*AUTOWIRE*/
    wire    [32:0]  sub_add;
    wire    [31:0]  data_r_t;
    reg     [31:0]  reg_q;
    reg     [31:0]  reg_r;
    reg     [31:0]  reg_b;
    reg     [5:0]   count;
    reg             r_sign;
    reg             isneg;

    always @(posedge clk) begin
        if(start) begin
            reg_r   <= 32'b0;
            reg_q   <= (data_a[31] & sign) ? {~data_a[31:0] + 1} : data_a;
            reg_b   <= (data_b[31] & sign) ? {~data_b[31:0] + 1} : data_b;
            count   <= 6'b0;
            r_sign  <= 0;
            done    <= 0;
            isneg   <= data_a[31] ^ data_b[31];
        end else if(~done) begin
            reg_r   <= sub_add[31:0];
            r_sign  <= sub_add[32];
            reg_q   <= {reg_q[30:0], ~sub_add[32]};
            count   <= count + 6'b000001;
            if (count == 6'b011111) done <= 1;
        end
    end
    assign  sub_add = r_sign ? {reg_r, reg_q[31]} + {1'b0, reg_b} : {reg_r, reg_q[31]} - {1'b0, reg_b};
    assign  data_r_t = r_sign ? reg_r + reg_b : reg_r;
    assign  data_r = data_a[31] ? ~data_r_t + 1 : data_r_t;
    assign  data_q = (isneg & sign) ? {~reg_q[31:0] + 1} : reg_q;

endmodule
