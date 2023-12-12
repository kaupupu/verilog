module dqsi_delay(
clk, //FmClk
RST, // reset_chip
DIN,
DOUT, // to flash controller
test_mode,
rd_cmd,
ddr_mode,
FreqSel,
dly_adj,
dly_adj_en,
dly_count_adj,
ddr_read_dat_end_pulse,
Fm_autotrim_done,
Fm_dly_control,
F200M,
FlashReN_in,
//test
dly_line_in_prob
);

(* dont_touch = "true", mark_debug = "true" *) input       clk;
input       RST;
(* dont_touch = "true", mark_debug = "true" *) input       DIN;
(* dont_touch = "true", mark_debug = "true" *) output      DOUT;

input test_mode;
input rd_cmd;
(* dont_touch = "true", mark_debug = "true" *) input ddr_mode;
(* dont_touch = "true", mark_debug = "true" *) input [3:0] FreqSel;
(* dont_touch = "true", mark_debug = "true" *) input [6:0]dly_adj;
(* dont_touch = "true", mark_debug = "true" *) input dly_adj_en;
(* dont_touch = "true", mark_debug = "true" *) output dly_count_adj;
input ddr_read_dat_end_pulse;
(* dont_touch = "true", mark_debug = "true" *) output Fm_autotrim_done;
(* dont_touch = "true", mark_debug = "true" *) input [7:0] Fm_dly_control;

input F200M;
input FlashReN_in; //SDR clock in
//test
output dly_line_in_prob;

wire RST_n;
(* dont_touch = "true", mark_debug = "true" *) wire FmClk_inv; 
(* dont_touch = "true", mark_debug = "true" *) reg FmClk_div2; // = ReN = DQSi
(* dont_touch = "true", mark_debug = "true" *) reg FmClk_div2_90d;
reg FmClk_div4;

wire FmClk_dly;
(* dont_touch = "true", mark_debug = "true" *) reg  [63:0] dly_count; //64 is temp
(* dont_touch = "true", mark_debug = "true" *) wire delay_line_out;

(* dont_touch = "true", mark_debug = "true" *) wire dly_line_in;
(* dont_touch = "true", mark_debug = "true" *) wire DOUT_sel;
(* dont_touch = "true", mark_debug = "true" *) reg dll_reset; // when change speed
///wire ddr_in_endpulse;
reg [3:0] FreqSel_d1;
reg [3:0] FreqSel_d2;
reg [6:0] dll_cnt_sv;
(* dont_touch = "true", mark_debug = "true" *) reg [6:0]dly_count_adj;
reg [63:0]adj_x;
reg [6:0]dly_adj_d1;
reg [6:0]dly_adj_d2;
(* dont_touch = "true", mark_debug = "true" *) reg Fm_autotrim_done;
(* dont_touch = "true", mark_debug = "true" *) reg fm_autotrim_reset;
reg [7:0] Fm_dly_control_sync1;
reg [7:0] Fm_dly_control_sync2;

//////////// code start ////////////////
clk_inv dnth_FmClk_inv ( .I(clk), .O(FmClk_inv) );

assign DOUT = ~DOUT_sel? DIN : delay_line_out;

assign RST_n = ~RST;

assign DOUT_sel = Fm_dly_control_sync2[1]; 
//async Fm_dly_control_sync -> from cpu
always @(posedge RST or posedge clk)begin
    if (RST)begin
        Fm_dly_control_sync1 <= 8'b0;
        Fm_dly_control_sync2 <= 8'b0;
    end else  begin
        Fm_dly_control_sync1 <= Fm_dly_control;
        Fm_dly_control_sync2 <= Fm_dly_control_sync1;
    end
end

//async FreqSel -> from cpu
always @(posedge RST or posedge clk)begin
    if (RST)begin
        FreqSel_d1 <= 4'b0;
        FreqSel_d2 <= 4'b0;
    end else  begin
        FreqSel_d1 <= FreqSel;
        FreqSel_d2 <= FreqSel_d1;
    end
end
//// creat dll_reset pulse when flash speed changed
always @(posedge RST or posedge clk)begin
    if (RST)begin
        dll_reset <= 1'b0;
    end else if (FreqSel_d2 != FreqSel)begin
        dll_reset <= 1'b1;
    end else  begin
        dll_reset <= 1'b0;
    end
end

always @(posedge RST or posedge clk)begin
    if (RST)
        FmClk_div2 <= 1'b0;
    else
        FmClk_div2 <= ~FmClk_div2;
end


always @(posedge RST or posedge FmClk_div2)begin
    if (RST)
        FmClk_div4 <= 1'b0;
    else
        FmClk_div4 <= ~FmClk_div4;
end


always @(posedge RST or posedge FmClk_inv)begin
    if (RST)
        FmClk_div2_90d <= 1'b0;
    else if (FmClk_div2 == 1'b1)
        FmClk_div2_90d <= 1'b1;
    else
        FmClk_div2_90d <= 1'b0;
end

//===== Decode the dly_en_mstr to dly_cnt for DLL slave =====//
function [6:0] dly_cnt;
input [63:0] di;
reg j;
integer          i;
begin
  dly_cnt = 7'h00;
  j = 1;
  for(i=64;i>0;i=i-1)
  begin
    if(di[i-1] & j)
    begin
      dly_cnt = i[6:0];
      j = 0;
    end
  end
end
endfunction

//===== Latch the last four dly_cnt of fm_clk_d90 =====//
reg [63:0] fmclk_div2_d90_count;

always @(posedge RST or posedge clk) begin
    if (RST)begin 
        fmclk_div2_d90_count <= 64'b00;
    end else if ( dly_adj_en ==1'b0)begin // manually dly
        fmclk_div2_d90_count <= dly_count;
    //end else if (Fm_dly_control_sync2[2]==1'b1)begin //when input is PAD_DQS
    //    fmclk_div2_d90_count <=  latch_deg90_count;   
    end else begin
        fmclk_div2_d90_count <= fmclk_div2_d90_count;
    end
end


//dll_cnt_sv = fmclk_div2_d90_count [63] + [62]....
always @(posedge RST or posedge clk) begin
    if (RST) begin 
        dll_cnt_sv <= 7'b0;
    end else begin
        if (fmclk_div2_d90_count[55])
            dll_cnt_sv <= fmclk_div2_d90_count [63] + fmclk_div2_d90_count [62] + fmclk_div2_d90_count [61] + fmclk_div2_d90_count [60] + fmclk_div2_d90_count [59] + fmclk_div2_d90_count [58] + fmclk_div2_d90_count [57] + fmclk_div2_d90_count [56] + 63'H38;
        else if (fmclk_div2_d90_count[47])
            dll_cnt_sv <= fmclk_div2_d90_count [48] + fmclk_div2_d90_count [49] + fmclk_div2_d90_count [50] + fmclk_div2_d90_count [51] + fmclk_div2_d90_count [52] + fmclk_div2_d90_count [53] + fmclk_div2_d90_count [54] + 63'H30;
        else if (fmclk_div2_d90_count[39])
            dll_cnt_sv <= fmclk_div2_d90_count [40] + fmclk_div2_d90_count [41] + fmclk_div2_d90_count [42] + fmclk_div2_d90_count [43] + fmclk_div2_d90_count [44] + fmclk_div2_d90_count [45] + fmclk_div2_d90_count [46] + 63'H28;
        else if (fmclk_div2_d90_count[31])
            dll_cnt_sv <= fmclk_div2_d90_count [32] + fmclk_div2_d90_count [33] + fmclk_div2_d90_count [34] + fmclk_div2_d90_count [35] + fmclk_div2_d90_count [36] + fmclk_div2_d90_count [37] + fmclk_div2_d90_count [38] + 63'H20;
        else if (fmclk_div2_d90_count[23])
            dll_cnt_sv <= fmclk_div2_d90_count [24] + fmclk_div2_d90_count [25] + fmclk_div2_d90_count [26] + fmclk_div2_d90_count [27] + fmclk_div2_d90_count [28] + fmclk_div2_d90_count [29] + fmclk_div2_d90_count [30] + 63'H18;
        else if (fmclk_div2_d90_count[15])
            dll_cnt_sv <= fmclk_div2_d90_count [16] + fmclk_div2_d90_count [17] + fmclk_div2_d90_count [18] + fmclk_div2_d90_count [19] + fmclk_div2_d90_count [20] + fmclk_div2_d90_count [21] + fmclk_div2_d90_count [22] + 63'H10;
        else if (fmclk_div2_d90_count[7])
            dll_cnt_sv <= fmclk_div2_d90_count [8] + fmclk_div2_d90_count [9] + fmclk_div2_d90_count [10] + fmclk_div2_d90_count [11] + fmclk_div2_d90_count [12] + fmclk_div2_d90_count [13] + fmclk_div2_d90_count [14] + 63'H08;
        else
            dll_cnt_sv <= fmclk_div2_d90_count [6] + fmclk_div2_d90_count [5] + fmclk_div2_d90_count [4] + fmclk_div2_d90_count [3] + fmclk_div2_d90_count [2] + fmclk_div2_d90_count [1] + fmclk_div2_d90_count [0];
    end
end

//**********************delay count + adj************************
//async dly_adj -> from cpu
always @(posedge RST or posedge clk)begin
    if (RST)begin
        dly_adj_d1 <= 7'b0;
        dly_adj_d2 <= 7'b0;
    end else begin
        dly_adj_d1 <= dly_adj;
        dly_adj_d2 <= dly_adj_d1;
    end
end

always @(posedge RST or posedge clk)begin
    if (RST)
        dly_count_adj <= 1'b0;
    //Manual
    else if (dly_adj_en)
        dly_count_adj <= dly_adj;
    //Auto
    else 
        dly_count_adj <= dll_cnt_sv;
end

always@(dly_count_adj) begin
    case(dly_count_adj)
        7'h00:  adj_x = 64'h0000000000000000;
        7'h01:  adj_x = 64'h0000000000000001;
        7'h02:  adj_x = 64'h0000000000000003;
        7'h03:  adj_x = 64'h0000000000000007;
        7'h04:  adj_x = 64'h000000000000000f;
        7'h05:  adj_x = 64'h000000000000001f;
        7'h06:  adj_x = 64'h000000000000003f;
        7'h07:  adj_x = 64'h000000000000007f;
        7'h08:  adj_x = 64'h00000000000000ff;
        7'h09:  adj_x = 64'h00000000000001ff;
        7'h0a:  adj_x = 64'h00000000000003ff;
        7'h0b:  adj_x = 64'h00000000000007ff;
        7'h0c:  adj_x = 64'h0000000000000fff;
        7'h0d:  adj_x = 64'h0000000000001fff;
        7'h0e:  adj_x = 64'h0000000000003fff;
        7'h0f:  adj_x = 64'h0000000000007fff;
        7'h10:  adj_x = 64'h000000000000ffff;
        7'h11:  adj_x = 64'h000000000001ffff;
        7'h12:  adj_x = 64'h000000000003ffff;
        7'h13:  adj_x = 64'h000000000007ffff;
        7'h14:  adj_x = 64'h00000000000fffff;
        7'h15:  adj_x = 64'h00000000001fffff;
        7'h16:  adj_x = 64'h00000000003fffff;
        7'h17:  adj_x = 64'h00000000007fffff;
        7'h18:  adj_x = 64'h0000000000ffffff;
        7'h19:  adj_x = 64'h0000000001ffffff;
        7'h1a:  adj_x = 64'h0000000003ffffff;
        7'h1b:  adj_x = 64'h0000000007ffffff;
        7'h1c:  adj_x = 64'h000000000fffffff;
        7'h1d:  adj_x = 64'h000000001fffffff;
        7'h1e:  adj_x = 64'h000000003fffffff;
        7'h1f:  adj_x = 64'h000000007fffffff;
        7'h20:  adj_x = 64'h00000000ffffffff;
        7'h21:  adj_x = 64'h00000001ffffffff;
        7'h22:  adj_x = 64'h00000003ffffffff;
        7'h23:  adj_x = 64'h00000007ffffffff;
        7'h24:  adj_x = 64'h0000000fffffffff;
        7'h25:  adj_x = 64'h0000001fffffffff;
        7'h26:  adj_x = 64'h0000003fffffffff;
        7'h27:  adj_x = 64'h0000007fffffffff;
        7'h28:  adj_x = 64'h000000ffffffffff;
        7'h29:  adj_x = 64'h000001ffffffffff;
        7'h2a:  adj_x = 64'h000003ffffffffff;
        7'h2b:  adj_x = 64'h000007ffffffffff;
        7'h2c:  adj_x = 64'h00000fffffffffff;
        7'h2d:  adj_x = 64'h00001fffffffffff;
        7'h2e:  adj_x = 64'h00003fffffffffff;
        7'h2f:  adj_x = 64'h00007fffffffffff;
        7'h30:  adj_x = 64'h0000ffffffffffff;
        7'h31:  adj_x = 64'h0001ffffffffffff;
        7'h32:  adj_x = 64'h0003ffffffffffff;
        7'h33:  adj_x = 64'h0007ffffffffffff;
        7'h34:  adj_x = 64'h000fffffffffffff;
        7'h35:  adj_x = 64'h001fffffffffffff;
        7'h36:  adj_x = 64'h003fffffffffffff;
        7'h37:  adj_x = 64'h007fffffffffffff;
        7'h38:  adj_x = 64'h00ffffffffffffff;
        7'h39:  adj_x = 64'h01ffffffffffffff;
        7'h3a:  adj_x = 64'h03ffffffffffffff;
        7'h3b:  adj_x = 64'h07ffffffffffffff;
        7'h3c:  adj_x = 64'h0fffffffffffffff;
        7'h3d:  adj_x = 64'h1fffffffffffffff;
        7'h3e:  adj_x = 64'h3fffffffffffffff;
        7'h3f:  adj_x = 64'h7fffffffffffffff;
        default:adj_x = 64'hffffffffffffffff;
    endcase
end
//**********************delay count************************
//delay up
//delay down
wire dly_upi;
reg dly_up;
wire dly_dni;
reg dly_dn;

assign dly_upi = delay_line_out;
//assign dly_dni = FmClk_div2_90d;


always @(posedge RST or posedge FmClk_div2_90d)begin
    if (RST)
        dly_up <= 1'b0;
    else
        dly_up <= dly_upi;
end
/*
always @(posedge RST or posedge delay_line_out)begin
    if (RST)
        dly_dn <= 1'b0;
    else
        dly_dn <= dly_dni;
end
*/

//assign dly_update_en = (dly_up ^ dly_dn) & FmClk_div4;
//assign fm_autotrim_reset = Fm_dly_control[0];
always @(posedge RST or posedge clk)begin
    if (RST)
        fm_autotrim_reset <= 1'b0;
    else
        fm_autotrim_reset <= Fm_dly_control_sync2[0];
end

always @(posedge RST or posedge FmClk_div2_90d)begin
    if (RST)
        dly_count <= 64'b0;
    else if (dll_reset | fm_autotrim_reset) //reset when 1. speed change 2. FW set
        dly_count <= 64'b0;
    else if (dly_adj_en) //// adjust delay when ddr_read
        dly_count <= adj_x;
    else if (Fm_autotrim_done==1'b1) //when Fm_autotrim_done
        dly_count <= dly_count;
    else if (dly_up)
        dly_count <= {dly_count[62:0],1'b1};
    //else if (dly_dn && ~rd_cmd)
    //    dly_count <= {1'b0,dly_count[63:1]};
    else
        dly_count <= dly_count;
end

//**********************delay in************************
wire dly_line_in_prob = dly_line_in;
//assign dly_line_in = ddr_in_en  ?  DIN : FmClk_div2; //while in read_mode & dqs_in FlashDqs_oe = 1'b0
assign dly_line_in = Fm_dly_control_sync2[1]  ?  DIN : FmClk_div2; 


//**********************delay line************************

`ifdef FPGA_MODE

wire [4:0] cnt_value;
  IDELAYE2 #(
    .CINVCTRL_SEL("FALSE"), // Enable dynamic clock inversion (FALSE, TRUE)
    .DELAY_SRC("DATAIN"), // Delay input (IDATAIN, DATAIN)
    .HIGH_PERFORMANCE_MODE("FALSE"), // Reduced jitter ("TRUE"), Reduced power ("FALSE")
    .IDELAY_TYPE("VAR_LOAD"), // FIXED, VARIABLE, VAR_LOAD, VAR_LOAD_PIPE
    .IDELAY_VALUE(0), // Input delay tap setting (0-31)
    .PIPE_SEL("FALSE"), // Select pipelined mode, FALSE, TRUE
    .REFCLK_FREQUENCY(200.0), // IDELAYCTRL clock input frequency in MHz (190.0-210.0, 290.0-310.0).
    .SIGNAL_PATTERN("DATA") // DATA, CLOCK input signal
 )
 IDELAYE2_inst2 (
    .CNTVALUEOUT(cnt_value), // 5-bit output: Counter value output
    .DATAOUT(delay_line_out), // 1-bit output: Delayed data output
    .C(F200M), // 1-bit input: Clock input
    .CE(1'b0), // 1-bit input: Active high enable increment/decrement input
    .CINVCTRL(1'b0), // 1-bit input: Dynamic clock inversion input
    .CNTVALUEIN(dly_count_adj[4:0]), // 5-bit input: Counter value input
    .DATAIN(dly_line_in), // 1-bit input: Internal delay data input
    .IDATAIN(1'b0), // 1-bit input: Data input from the I/O
    .INC(1'b0), // 1-bit input: Increment / Decrement tap delay input
    .LD(1'b1), // 1-bit input: Load IDELAY_VALUE input
    .LDPIPEEN(1'b0), // 1-bit input: Enable PIPELINE register to load data input
 .REGRST(1'b0) // 1-bit input: Active-high reset tap-delay input
 );
`else

dqsi_delay_line dqsi_delay_line64_00(
    .rst_n(RST_n), .test_mode(test_mode), 
    .si(dly_line_in), .adj(dly_count), .so(delay_line_out)
);
`endif

//Fm_autotrim_done
always @(posedge RST or posedge clk)begin
    if (RST)
        Fm_autotrim_done <= 1'b0;
    else if (dly_count == adj_x && dly_count[0] !== 1'b0)
        Fm_autotrim_done <= 1'b1;
    else
        Fm_autotrim_done <= 1'b0;
end

endmodule
