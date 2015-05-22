`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:51:58 03/24/2014 
// Design Name: 
// Module Name:    MIPS32 
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
module mips32(/*AUTOARG*/
	// Outputs
	port_PC, port_inst, port_alu,
	// Inputs
	rst, clk, interrupts
	);
    input        rst;
    input        clk;
    //input        port_in;
    input   [4:0]   interrupts;

    output  reg     [31:0]    port_PC, port_inst, port_alu;
  
    reg     [31:0]  PC;
    reg     [31:0]  PCadd4;
    wire    [31:0]  PCout, PCnext;
    wire    [31:0]  HI;
    wire    [31:0]  LO;
	 
    wire    [31:0]  inst;
    wire    [31:0]  immediate;
	wire    [4:0]   rs, rt, rd;

    wire    load, store, move, ssnop, nop,jump, branch,sign, regwrite,memtoreg,memread, memwrite;
    wire    [20:0]  aluc;
    wire    [3:0]   move_op;
    wire    [8:0]   load_op;
    wire    [5:0]   store_op;
    wire    [31:0]  regrs_data, regrt_data;
    
    wire    [31:0]  memaddr;
    wire    [31:0]  memdata_in;
    // IF stage
    wire    IF_stall;
    wire    IF_flush;
    wire    [31:0]  IF_inst;
    reg     [31:0]  IF_PC, IF_PCnext;
    //wire    [31:0]  ID_inst;
    //wire    [31:0]  ID_PCnext;

    // ID stage
    wire    ID_stall;
    wire    ID_flush;
    wire    [31:0]  ID_inst;
    wire    [31:0]  ID_PCnext;
    wire    [4:0]   ID_reg_dst;
    wire    [31:0]  ID_data_a, ID_data_b, ID_data_c;
    //wire    [20:0]  aluc;
    wire    ID_sign;
    wire    ID_memread, ID_memwrite;
    wire    [31:0]  ID_memaddr;
    wire    [8:0]   ID_load_op;
    wire    [5:0]   ID_store_op;
    wire    ID_memtoreg, ID_regwrite;
    wire    [31:0]  EX_data_a, EX_data_b, EX_data_c;
    wire    [20:0]  EX_aluc;
    wire    EX_sign;
    wire    EX_memread, EX_memwrite;
    wire    [31:0]  EX_memaddr;
    wire    [8:0]   EX_load_op;
    wire    [5:0]   EX_store_op;
    wire    EX_memtoreg, EX_regwrite;

    // EXE stage:
    wire    EX_stall;
    wire    EX_flush;
    wire    [31:0]  EX_alu_out;
    wire    [31:0]  EX_alu_out_t;
    wire    [4:0]   EX_rt_rd;

    wire    M_regwrite;
    wire    M_memtoreg;
    wire    M_memread;
    wire    M_memwrite;
    wire    [31:0]  M_memaddr;
    wire    [8:0]   M_load_op;
    wire    [5:0]   M_store_op;
    wire    [31:0]  M_alu_out;
    wire    [31:0]  M_readdata;
    wire    [4:0]   M_rt_rd;

    wire    M_flush;
    wire    M_stall;
    wire    WB_stall;
    
    wire    WB_regwrite;
    wire    WB_memtoreg;
    wire    [31:0]  WB_readdata;
    wire    [31:0]  WB_alu_out;
    wire    [4:0]   WB_rtrd;


    IF_stage IF_stage_0(/*AUTOINST*/
						// Outputs
						.ID_inst		(ID_inst),
						.ID_PCnext		(ID_PCnext),
						// Inputs
						.clk			(clk),
						.rst			(rst),
						.IF_stall		(IF_stall),
						.IF_flush		(IF_flush),
						.ID_stall		(ID_stall),
						.IF_inst		(IF_inst),
						.IF_PCnext		(IF_PCnext),
						.IF_PC			(IF_PC));

    always @(posedge clk) begin
        if (rst) begin
            PC <= 32'b0;
            //PCnext <= 32'b0;
            IF_PCnext <= 32'b0;
        end else begin
            PC <= PCnext;
            IF_PCnext <= PC;
            PCadd4 <= PC + 32'h0000_0004;
        end
    end
    mux2 #(.WIDTH(32)) PC_mux(
        .sel    (jump|branch),
        .in0    (PCadd4),
        .in1    (PCout),
        .out    (PCnext)
        );
    rom rom_0(
        .PC     (PC),
        .inst   (IF_inst),
        .clk    (clk)
    );

    
    //wire    [31:0]  target_offset;
    //wire    [25:0]  inst_idx;
    //wire    [4:0]   regdst;
    decode decode_0(
        .clk         (clk),
        .inst_in     (ID_inst),
        .PCin        (ID_PCnext),
        .regrs_data  (regrs_data),
        .regrt_data  (regrt_data),
        //Outputs
        .PCout       (PCout),
        .jump        (jump),
        .ssnop       (ssnop),
        .branch      (branch),
        .aluc        (ID_aluc),
        .sign        (ID_sign),
        //.base        (base),
        //.immediate   (immediate),
        .store       (store),
        .store_op    (ID_store_op),
        .op_a        (ID_data_a),
        .op_b        (ID_data_b),
        .op_sa       (ID_data_c),
        .move        (move),
        .move_op     (move_op),
        .rs          (rs),
        .rt          (rt),
        .rd          (rd),
        .nop         (nop),
        .load        (load),
        .load_op     (ID_load_op),
        //.target_offset(target_offset),
        //.inst_idx    (inst_idx),
        .regwrite    (ID_regwrite),
        .memtoreg    (ID_memtoreg),
        .memread     (ID_memread),
        .regdst      (ID_reg_dst),
        .memwrite    (ID_memwrite),
        .memaddr     (ID_memaddr)
        );

    ID_stage ID_stage_0(/*AUTOINST*/
						// Outputs
						.EX_data_a		(EX_data_a[31:0]),
						.EX_data_b		(EX_data_b[31:0]),
						.EX_data_c		(EX_data_c[31:0]),
						.EX_aluc		(EX_aluc[20:0]),
						.EX_sign		(EX_sign),
						.EX_memread		(EX_memread),
						.EX_memwrite	(EX_memwrite),
                        .EX_memaddr     (EX_memaddr),
						.EX_load_op		(EX_load_op[8:0]),
						.EX_store_op	(EX_store_op[5:0]),
						.EX_memtoreg	(EX_memtoreg),
						.EX_regwrite	(EX_regwrite),
						// Inputs
						.clk			(clk),
						.rst			(rst),
						.ID_stall		(ID_stall),
						.ID_flush		(ID_flush),
						.EX_stall		(EX_stall),
						.ID_reg_dst		(ID_reg_dst[4:0]),
						.ID_data_a		(ID_data_a[31:0]),
						.ID_data_b		(ID_data_b[31:0]),
						.ID_data_c		(ID_data_c[31:0]),
						.ID_aluc		(ID_aluc),
						.ID_sign		(ID_sign),
						.ID_memread		(ID_memread),
						.ID_memwrite	(ID_memwrite),
                        .ID_memaddr     (ID_memaddr),
						.ID_load_op		(ID_load_op[8:0]),
						.ID_store_op	(ID_store_op[5:0]),
						.ID_memtoreg	(ID_memtoreg),
						.ID_regwrite	(ID_regwrite));
    alu alu_0(
        //Inputs
        //.data_c     (ID_data_c),
        .clk        (clk),
        .aluc       (EX_aluc),
        .sign       (EX_sign),
        .data_a     (EX_data_a),
        .data_b     (EX_data_b),
        .data_c     (EX_data_c),
        //Outputs
        .data_out_t (EX_alu_out_t),
        .overflow   (overflow),
        .ready      (ready),
        .data_out   (EX_alu_out));
       
 
    EX_stage EX_stage_0(
						// Outputs
						.M_regwrite		(M_regwrite),
						.M_memtoreg		(M_memtoreg),
						.M_memread		(M_memread),
						.M_memwrite		(M_memwrite),
                        .M_memaddr      (M_memaddr),
						.M_load_op		(M_load_op[8:0]),
						.M_store_op		(M_store_op[5:0]),
						.M_alu_out		(M_alu_out[31:0]),
						.M_rt_rd		(M_rt_rd[4:0]),
						// Inputs
						.clk			(clk),
						.rst			(rst),
						.EX_stall		(EX_stall),
						.EX_flush		(EX_flush),
						.M_stall		(M_stall),
						.EX_regwrite	(EX_regwrite),
                        //.EX_reg_dst     (ID_reg_dst),
						.EX_memtoreg	(EX_memtoreg),
						.EX_memread		(EX_memread),
						.EX_memwrite	(EX_memwrite),
                        .EX_memaddr     (EX_memaddr),
						.EX_load_op		(EX_load_op[8:0]),
						.EX_store_op	(EX_store_op[5:0]),
						.EX_alu_out		(EX_alu_out[31:0]),
						.EX_alu_out_t	(EX_alu_out_t[31:0]),
                        .EX_rt_rd		(ID_reg_dst));
    
    reg [31:0]  gpr_data_in;
    always @* begin
        case (WB_memtoreg)
            1'b1: gpr_data_in <= WB_readdata;
            1'b0: gpr_data_in <= WB_alu_out;
        endcase
    end
    gpr gpr_0(
			  // Outputs
			  .reg_out1				(regrt_data),
			  .reg_out2				(regrs_data),
			  // Inputs
			  .clk					(clk),
			  .regwrite			    (WB_regwrite),
			  .data_in				(gpr_data_in),
              .write_addr           (WB_rtrd),
			  .reg_addr1			(rs),
			  .reg_addr2			(rt));

    data_ram data_ram_0(
                        .clk            (clk),
                        .rst            (rst),
                        .m_read         (M_memread),
                        .m_write        (M_memwrite),
                        .m_addr         (M_memaddr),
                        .m_din          (memdata_in),
                        // Outputs
                        .m_dout         (M_readdata)
                    );
       
    MEM_stage MEM_stage_0(
						  // Outputs
						  .WB_regwrite			(WB_regwrite),
						  .WB_memtoreg			(WB_memtoreg),
                          .WB_readdata          (WB_readdata),
						  .WB_alu_out			(WB_alu_out[31:0]),
						  .WB_rt_rd				(WB_rtrd),
						  // Inputs
						  .clk					(clk),
						  .rst					(rst),
						  .M_flush				(M_flush),
						  .M_stall				(M_stall),
						  .WB_stall				(WB_stall),
						  .M_regwrite			(M_regwrite),
						  .M_memtoreg			(M_memtoreg),
                          .M_readdata           (M_readdata),
						  .M_alu_out			(M_alu_out[31:0]),
						  .M_rt_rd				(M_rt_rd[4:0]));
    always @(posedge clk) begin
        port_PC   <= PCnext;
        port_alu  <= WB_alu_out;
        port_inst <= IF_inst;
    end
endmodule










































