//=======================================================================

// Filename           :cloz.v
// Author             :(RDC)
// Created On         :2014-04-28 09:31
// Last Modified      : 
// Update Count       :2014-04-28 09:31
// Description        :To Count the number of leading ones/zero in a word
//                     
//                     
//=======================================================================

module cloz(/*AUTOARG*/
    //Inputs
    data_in, io, 

    //Outputs
    data_out);
    input  [31:0]  data_in;
    input          io;

    output [31:0]  data_out;
    /* 
    reg    [31:0]  v, c, data_out;
    always @* begin
        if (io == 1)
            v = ~(data_in ^ (data_in - 1));
        else 
            v = data_in ^ (data_in - 1);
       
        for (c=0; v; c=c+1)
            v = v>>1;
        data_out = c;
    end
    */
    wire    [31:0]  result = 32'b0;
    wire    [31:0]  value;
    wire    [15:0]  val16;
    wire    [7:0]   val8;
    wire    [3:0]   val4;
    assign  value = io ? ~data_in : data_in;
    assign  result[4] = (value[31:16] == 16'b0);
    assign  val16     = result[4] ? value[15:0] : value[31:16];
    assign  result[3] = (val16[15:8] == 8'b0);
    assign  val8      = result[3] ? val16[7:0] : val16[15:8];
    assign  result[2] = (val8[7:4] == 4'b0);
    assign  val4      = result[2] ? val8[3:0] : val8[7:4];
    assign  result[1] = (val4[3:2] == 2'b0);
    assign  result[0] = result[1] ? ~val4[1] : ~val4[3];
    
    assign  data_out = result;
endmodule
