`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:28:24 03/24/2014 
// Design Name: 
// Module Name:    decode 
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
/*********************************************************************************

                    6        5       5       5       5         6  
             +---------+--------+--------+--------+--------+----------+
R-type format| Op-code |    Rs  |  Rt    |   Rd   |   SA   |Funct-code| 
             +---------+--------+--------+--------+--------+--------+-+
 
                    6        5       5                  16 
             +---------+--------+--------+----------------------------+
I-type format| Op-code |     Rs |   Rt   |  2's complement constant   | 
             +---------+--------+--------+----------------------------+
 
                    6                             26 
             +---------+----------------------------------------------+ 
J-type format| Op-code |                jump_target                   | 
             +---------+----------------------------------------------+ 
              ^                                                       ^ 
              |                                                       | 
         bit 31                                                   bit 0 
         
*********************************************************************************/

module decode(/*AUTOARG*/
    //Inputs
    clk, ID_stall, inst_in, regrs_data, regrt_data, PCin, 
    //Outputs
    PCout, ret_addr, aluc,op_a,op_b,op_sa,sign,nop, ssnop,jump, branch, rs, rt, rd,
    load, store, move, load_op, store_op, move_op, regwrite, memread, memwrite, memaddr, memtoreg, regdst);
    input         clk;
    input         ID_stall;
    input   [31:0]  inst_in;
    reg     [31:0]  inst;
    input   [31:0]  regrs_data, regrt_data;
    input   [31:0]  PCin;
    output  reg [31:0]  PCout, ret_addr;
    //Alu
    wire 		  add, sub, mul, div, madd, msub;
    wire    [2:0]  shift;
    wire    [3:0]  _logic;
    wire          cmp;
    wire    [2:0]  clzo;
    output  [20:0] aluc;
    assign        aluc = {add, sub, mul, div, madd, msub, shift, _logic, cmp, clzo};

    output  [31:0]  op_a, op_b, op_sa;
   
    output      sign;
    output  reg [4:0] rs, rt, rd;
    output 		nop, ssnop;
	output 		jump;
    output  reg branch;
	//output 		base, offset;
    output      load, store, move;
	output  wire    [8:0] load_op;
    output  wire    [5:0] store_op;
    output  wire    [3:0] move_op;

    output  regwrite, memwrite, memread, memtoreg;
    output  [31:0]  memaddr;
    output  [4:0]   regdst;// write reg
    wire    [5:0] 	op   = inst[31:26];
	wire    [5:0] 	func = inst[5:0];

    wire      cop0     = (op == 6'b010000);
    wire 	  imm_op   = (op[5:3] == 3'b001);
	wire 	  regimm   = (op == 6'b000001);
	wire      special  = (op == 6'b000000);
	wire      special2 = (op == 6'b011100);
	wire      special3 = (op == 6'b011111);
	
    //target_offset -> sign_extend(offset || 00)
    //PC -> PC + target_offset
    wire    [15:0]  offset = inst[15:0];
    wire    [31:0]  target_offset = PCin + (offset[15] ? {14'h3fff, offset, 2'b00} : {14'h0000, offset, 2'b00});
    assign  memaddr = regrs_data + offset;

    wire    [31:0] immediate = inst[15] ? {16'hffff, inst[15:0]} : {16'b0, inst[15:0]};
    assign  op_a = (special | special2) ? regrt_data : immediate;
    assign  op_b = regrs_data;
    assign  op_sa = inst[10:6];

    //PC -> PC[GPRLEN-1..28] || instr_index || 00
    wire    [25:0]  inst_idx = inst[25:0];
	
    assign 		add = (special && func[5:1]==5'b10000) || (op==5'b00100);
	assign		sub = (special && func[5:1]==5'b10001);
	assign      mul = (special2 & func == 6'b000010) || (special && func[5:1]==5'b01100);
    assign      div = (special && func[5:1]==5'b01101);
    assign     msub = (special2 && func[5:1]==5'b00010);
    assign     madd = (special2 && func[5:1]==5'b00000);

    assign     sign = (add && op[0]) || ((add | sub | mul | div| madd | msub)&&func[0]);

    wire        sll = (special && func == 6'b000000);
    wire       sllv = (special && func == 6'b000100);
    wire        sra = (special && func == 6'b000011);
    wire       srav = (special && func == 6'b000111);
    wire        srl = (special && func == 6'b000010);
    wire       srlv = (special && func == 6'b000110);
    assign    shift = {(sll|sllv), (sra|srav), (srl|srlv)};

    wire       _and = (special && func == 6'b100100);
    wire      _andi = (op == 6'b001100);
    wire        _or = (special && func == 6'b100101);
    wire       _ori = (op == 6'b001101);
    wire       _nor = (special && func == 6'b100111);
    wire       _xor = (special && func == 6'b100110);
    wire      _xori = (op == 6'b001110);
    assign   _logic = {_xor, _nor, (_and|_andi), (_or|_ori)};

    // jump
    wire          j = op == 6'b000010;
    wire        jal = op == 6'b000011;
    wire       jalr = (special && func == 6'b001001);
    wire         jr = (special && func == 6'b001000);
    //wire       jump = (op[5:1] == 5'b00001) || (special && func[5:1] == 5'b00100);
    //assign     jump = {j, jal, jalr, jr};
    assign     jump = j | jal | jalr | jr;    

    // branch
    wire          b = (op == 6'b000100 && rs == 5'b00000 && rt == 5'b00000);
    wire        bal = (regimm && rs == 5'b00000 && rt == 5'b10001);
    wire        beq = op == 6'b000100;
    wire       beql = op == 6'b010100;
    wire       bgez = (regimm && rt == 5'b00001);
    wire     bgezal = (regimm && rt == 5'b10001);
    wire    bgezall = (regimm && rt == 5'b10011);
    wire      bgezl = (regimm && rt == 5'b00011);
    wire       bgtz = op == 6'b000111;
    wire      bgtzl = op == 6'b010111;
    wire       blez = op == 6'b000110;
    wire      blezl = op == 6'b010110;
    wire       bltz = (regimm && rt == 5'b00000);
    wire     bltzal = (regimm && rt == 5'b10000);
    wire    bltzall = (regimm && rt == 5'b10010);
    wire      bltzl = (regimm && rt == 5'b00010);
    wire        bne = op == 6'b000101;
    wire       bnel = op == 6'b010101;
    //assign   branch = b | bal | beq | beql | bgtz | bgtzl | blez | blezl | bne | bnel | regimm;
    always @* begin
        case ({b,bal,beq,beql,bgez,bgezal,bgezall,bgezl,bgtz,bgtzl,blez,blezl,bltz,bltzal,bltzall,bltzl,bne,bnel})
            18'b10000000000000000 : branch <= 1; // b
            18'b01000000000000000 : branch <= 1; // bal
            // beq, beql
            18'b00100000000000000 ,
            18'b00010000000000000 : branch <= (regrs_data == regrt_data) ? 1 : 0;
            // bgez,bgezal,bgezall,bgezl
            18'b00001000000000000 , //begin branch <= (regrs_data >= 32'b0)      ? 1 : 0; end
            18'b00000100000000000 , //begin branch <= (regrs_data >= 32'b0)      ? 1 : 0; end
            18'b00000010000000000 , //begin branch <= (regrs_data >= 32'b0)      ? 1 : 0; end
            18'b00000001000000000 : begin branch <= (regrs_data >= 32'b0)      ? 1 : 0; end
            // blez,blezl
            18'b00000000100000000 , //begin branch <= (regrs_data >  32'b0)      ? 1 : 0; end
            18'b00000000010000000 : begin branch <= (regrs_data >  32'b0)      ? 1 : 0; end
            // bltz,bltzal,bltzall,bltzl
            18'b00000000001000000 , //begin branch <= (regrs_data <= 32'b0)      ? 1 : 0; end
            18'b00000000000100000 , //begin branch <= (regrs_data <= 32'b0)      ? 1 : 0; end
            18'b00000000000010000 , //begin branch <= (regrs_data <  32'b0)      ? 1 : 0; end
            18'b00000000000001000 , //begin branch <= (regrs_data <  32'b0)      ? 1 : 0; end
            18'b00000000000000100 : begin branch <= (regrs_data <  32'b0)      ? 1 : 0; end
            // bne, bnel
            18'b00000000000000010 , //begin branch <= (regrs_data != regrt_data) ? 1 : 0; end
            18'b00000000000000001 : begin branch <= (regrs_data != regrt_data) ? 1 : 0; end

        endcase
    end

    wire      break = (special && func == 6'b001101);
    wire      cache = op == 6'b101111;

    wire        clo = special2 && (func == 6'b100001);
    wire        clz = special2 && (func == 6'b100000);
    assign     cloz = {clz, clo};

    // load
    wire         lb = (op == 6'b100000);
    wire        lbu = (op == 6'b100100);
    wire         lh = (op == 6'b100001);
    wire        lhu = (op == 6'b100101);
    wire         ll = (op == 6'b110000);
    wire        lui = (op == 6'b001111);
    wire         lw = (op == 6'b100011);
    wire        lwl = (op == 6'b100010);
    wire        lwr = (op == 6'b100110);
    assign     load = (lb | lbu | lh | lhu | ll | lui | lw | lwl | lwr);
    assign  load_op = {lb, lbu, lh, lhu, ll, lui, lw, lwl, lwr};
    // store
    wire         sb = (op == 6'b101000);
    wire         sc = (op == 6'b111000);
    wire         sh = (op == 6'b101001);
    wire         sw = (op == 6'b101011);
    wire        swl = (op == 6'b101010);
    wire        swr = (op == 6'b101110);
    assign    store = (sb | sc | sh | sw | swl | swr);
    assign store_op = {sb, sc, sh, sw, swl, swr};

    // sync
    wire       sync = (special && func == 6'b001111);
    wire      stype = inst[10:6];

    // trap
    // teq teqi tge tgei tgeiu tgeu tlt tlti tltiu tltu tne tnei 
    wire        teq = (special && func == 6'b110100);
    wire       teqi = (regimm && rt == 5'b01100);
    wire        tge = (special && func == 6'b110000);
    wire       tgei = (regimm && rt == 5'b01000);
    wire      tgeiu = (regimm && rt == 5'b01001);
    wire       tgeu = (special && func == 5'b11001);
    wire        tlt = (special && func == 6'b110010);
    wire       tlti = (regimm && rt == 5'b01010);
    wire      tltiu = (regimm && rt == 5'b01011);
    wire       tltu = (special && func == 6'b110011);
    wire        tne = (special && func == 6'b110110);
    wire       tnei = (regimm && rt == 5'b01110);
    // wait
    //wire      _wait = (cop0 && co == 1 && func == 6'b100000);

    // MFHI MFLO MOVN MOVZ MTHI MTLO
    wire       mfhi = (special && func == 6'b010000);
    wire       mflo = (special && func == 6'b010010);
    wire       movn = (special && func == 6'b001011);
    wire       movz = (special && func == 6'b001010);
    assign     move = (mfhi | mflo | movn | movz);
    assign  move_op = {mfhi, mflo, movn, movz};
    // PREF PREFX to move data between memory and cache
    // prefetch_memory(GPR[base] + offset)
    // prefetch_memory(GPR[base] + GPR[index])
    wire       pref = (op == 6'b110011);
    //wire      prefx = (op == 6'b010011 && func == 6'b001111);

    assign  regwrite = (add|sub|(|shift)|(|_logic)|move|load|bal|bgezal|bgezall|bgezl|bltzal|bltzall|jal|jalr);
    assign  memwrite = store;
    assign  memread  = load;
    assign  memtoreg = load;

    assign  regdst   = (special && (op != 6'b001000)) ? rd : rt;

    always @(posedge clk) begin
        inst <= ID_stall ? inst : inst_in;
        case ({ID_stall, j, jal, jalr, jr,branch})
            6'b100000 : PCout <= PCin;
            6'b010000 : PCout <= {PCin[31:28], inst_idx, 2'b00};
            6'b001000 : PCout <= {PCin[31:28], inst_idx, 2'b00};
            6'b000100 : PCout <= regrs_data;
            6'b000010 : PCout <= regrs_data;
            6'b000001 : PCout <= target_offset;
        endcase
    end
    always @* begin
        rs <= inst[25:21];
        rt <= inst[20:16];

        if (bal | bgezal | bgezall | bgezl | bltzal | bltzall | jal | jalr) begin
            ret_addr <= PCin + 32'h0000008;
            rd       <= 5'b11111;
        end else begin
            rd <= inst[15:11];
        end
    end
   
endmodule

