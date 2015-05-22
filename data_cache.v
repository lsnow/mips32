//=======================================================================
// Created by         :
// Filename           :cache.v
// Author             :(RDC)
// Created On         :2014-04-28 10:57
// Last Modified      : 
// Update Count       :2014-04-28 10:57
// Description        :
//                     
//                     
//=======================================================================
module data_cache(/*AUTOARG*/);
    input   [31:0]  p_a;
    input   [31:0]  p_dout;
    input           p_strobe;
    input           p_rw;
    input           clk, rst;
    output  [31:0]  p_din;
    output          p_ready;
    output  [31:0]  m_a;
    output  [31:0]  m_din;
    output          m_strobe;
    output          m_rw;
    input           m_ready;

    reg             d_valid  [0:63];
    reg     [23:0]  d_tags   [0:63];
    reg     [31:0]  d_data   [0:63];
    wire     [5:0]  index = p_a[7:2];
    wire    [23:0]  tag   = p_a[31:8];

    always @(posedge clk) begin
        if(rst == 1) begin
            integer i;
            for (i = 0; i < 64; i++)
                d_valid[i] <= 1'b0;
        end else if(c_write)
            d_valid[index] <= 1'b1;
    end

    always @(posedge clk) begin
        if(c_write) begin
            d_tags[index] <= tag;
            d_data[index] <= c_din;
        end
    end

    wire            valid  = d_valid[index];
    wire    [23:0]  tagout = d_tags[index];
    wire    [31:0]  c_dout = d_data[index];

    wire            cache_hit = valid & (tagout == tag);
    wire            cache_miss= ~cache_hit;
    assign          m_din     = p_dout;
    assign          m_a       = p_a;
    assign          m_rw      = p_strobe & p_rw;
    assign          m_strobe  = p_strobe & ( p_rw | cache_miss);
    assign          p_ready   = ~p_rw & cache_hit | (cache_miss | p_rw) & m_ready;
    wire            c_write   = p_rw | cache_miss & m_ready;
    wire            sel_in    = p_rw;
    wire            sel_out   = cache_hit;
    wire    [31:0]  c_din     = sel_in ? p_dout : m_dout;
    assign          p_din     = sel_out ? c_dout : m_dout;
endmodule


