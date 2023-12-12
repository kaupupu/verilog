//----------------------------------------------------------------------
//File name   : cpu2apb.v
//Title       : 
//Created     : 2021
//Description : Simple 8051 cpu external memory interface to APB bridge
//Notes       : 
//----------------------------------------------------------------------

`timescale 1ps/1ps

//`define APB_SLAVE0
`define APB_SLAVE1
//`define APB_SLAVE2
//`define APB_SLAVE3
//`define APB_SLAVE4
//`define APB_SLAVE5
//`define APB_SLAVE6

module cpu2apb
(
  // AHB signals
  clk,
  resetn,
  xaddress,
  xdatao,
  xdatai,
  xdataz,
  xdatawr,
  xdatard,
  ready,
  
  // APB signals common to all APB slaves
  pclk, // pclk must synchrous to clk
  presetn,
  paddr,
  penable,
  pwrite,
  pprot,
  pstrb,
  pwdata
  
  // // Slave 0 signals
  // `ifdef APB_SLAVE0
  // ,psel0
  // ,pready0
  // ,prdata0
  // ,pslverr0
  // `endif
  
  // Slave 1 signals
  `ifdef APB_SLAVE1
  ,psel1
  ,pready1
  ,prdata1
  ,pslverr1
  `endif
  
  // Slave 2 signals
  `ifdef APB_SLAVE2
  ,psel2
  ,pready2
  ,prdata2
  ,pslverr2
  `endif
  
  // Slave 3 signals
  `ifdef APB_SLAVE3
  ,psel3
  ,pready3
  ,prdata3
  ,pslverr3
  `endif
  
  // Slave 4 signals
  `ifdef APB_SLAVE4
  ,psel4
  ,pready4
  ,prdata4
  ,pslverr4
  `endif
  
  // // Slave 5 signals
  // `ifdef APB_SLAVE5
  // ,psel5
  // ,pready5
  // ,prdata5
  // ,pslverr5
  // `endif
  
  // Slave 6 signals
  `ifdef APB_SLAVE6
  ,psel6
  ,pready6
  ,prdata6
  ,pslverr6
  `endif
  
  // // Slave 7 signals
  // `ifdef APB_SLAVE7
  // ,psel7
  // ,pready7
  // ,prdata7
  // ,pslverr7
  // `endif
  // 
  // // Slave 8 signals
  // `ifdef APB_SLAVE8
  // ,psel8
  // ,pready8
  // ,prdata8
  // ,pslverr8
  // `endif
  // 
  // // Slave 9 signals
  // `ifdef APB_SLAVE9
  // ,psel9
  // ,pready9
  // ,prdata9
  // ,pslverr9
  // `endif
  // 
  // // Slave 10 signals
  // `ifdef APB_SLAVE10
  // ,psel10
  // ,pready10
  // ,prdata10
  // ,pslverr10
  // `endif
  // 
  // // Slave 11 signals
  // `ifdef APB_SLAVE11
  // ,psel11
  // ,pready11
  // ,prdata11
  // ,pslverr11
  // `endif
  // 
  // // Slave 12 signals
  // `ifdef APB_SLAVE12
  // ,psel12
  // ,pready12
  // ,prdata12
  // ,pslverr12
  // `endif
  // 
  // // Slave 13 signals
  // `ifdef APB_SLAVE13
  // ,psel13
  // ,pready13
  // ,prdata13
  // ,pslverr13
  // `endif
  // 
  // // Slave 14 signals
  // `ifdef APB_SLAVE14
  // ,psel14
  // ,pready14
  // ,prdata14
  // ,pslverr14
  // `endif
  // 
  // // Slave 15 signals
  // `ifdef APB_SLAVE15
  // ,psel15
  // ,pready15
  // ,prdata15
  // ,pslverr15
  // `endif

  ,reg_slverr_clr
  ,slverr     // interrupt,  

);

//parameter 
//  APB_SLAVE0_START_ADDR  = 12'h00003,
//  APB_SLAVE0_END_ADDR    = 12'h00004,
//  APB_SLAVE1_START_ADDR  = 12'h00005,
//  APB_SLAVE1_END_ADDR    = 12'h00005,
//  APB_SLAVE2_START_ADDR  = 12'h00006,
//  APB_SLAVE2_END_ADDR    = 12'h00006,
//  APB_SLAVE3_START_ADDR  = 12'h00007,
//  APB_SLAVE3_END_ADDR    = 12'h00007,
//  APB_SLAVE4_START_ADDR  = 12'h00008,
//  APB_SLAVE4_END_ADDR    = 12'h00008,
//  APB_SLAVE5_START_ADDR  = 12'h00009,
//  APB_SLAVE5_END_ADDR    = 12'h00009,
//  APB_SLAVE6_START_ADDR  = 12'h0000A,
//  APB_SLAVE6_END_ADDR    = 12'h0000A,
//  APB_SLAVE7_START_ADDR  = 12'h00000,
//  APB_SLAVE7_END_ADDR    = 12'h00000,
//  APB_SLAVE8_START_ADDR  = 12'h00000,
//  APB_SLAVE8_END_ADDR    = 12'h00000,
//  APB_SLAVE9_START_ADDR  = 12'h00000,
//  APB_SLAVE9_END_ADDR    = 12'h00000,
//  APB_SLAVE10_START_ADDR  = 12'h00000,
//  APB_SLAVE10_END_ADDR    = 12'h00000,
//  APB_SLAVE11_START_ADDR  = 12'h00000,
//  APB_SLAVE11_END_ADDR    = 12'h00000,
//  APB_SLAVE12_START_ADDR  = 12'h00000,
//  APB_SLAVE12_END_ADDR    = 12'h00000,
//  APB_SLAVE13_START_ADDR  = 12'h00000,
//  APB_SLAVE13_END_ADDR    = 12'h00000,
//  APB_SLAVE14_START_ADDR  = 12'h00000,
//  APB_SLAVE14_END_ADDR    = 12'h00000,
//  APB_SLAVE15_START_ADDR  = 12'h00000,
//  APB_SLAVE15_END_ADDR    = 12'h00000;

  // cpu signals
input        clk;
input        resetn;
input[23:0]  xaddress;
input[7:0]   xdatao;
input        xdataz;
input        xdatawr;
input        xdatard;
output[7:0]  xdatai;
output       ready;
  
  // APB signals common to all APB slaves
input        pclk;
input        presetn;
output[31:0] paddr;
reg   [31:0] paddr;
output       penable;
reg          penable;
output       pwrite;
reg          pwrite;
output[2:0]  pprot;
output       pstrb;
output[7:0]  pwdata;
  
//   // Slave 0 signals
// `ifdef APB_SLAVE0
//   output      psel0;
//   input       pready0;
//   input[7:0]  prdata0;
//   input       pslverr0;
// `endif
  
  // Slave 1 signals
`ifdef APB_SLAVE1
  output      psel1;
  input       pready1;
  input[7:0] prdata1;
  input       pslverr1;
`endif
  
  // Slave 2 signals
`ifdef APB_SLAVE2
  output      psel2;
  input       pready2;
  input[7:0] prdata2;
  input       pslverr2;
`endif
  
  // Slave 3 signals
`ifdef APB_SLAVE3
  output      psel3;
  input       pready3;
  input[7:0] prdata3;
  input       pslverr3;
`endif
  
  // Slave 4 signals
`ifdef APB_SLAVE4
  output      psel4;
  input       pready4;
  input[7:0] prdata4;
  input       pslverr4;
`endif
  
//   // Slave 5 signals
// `ifdef APB_SLAVE5
//   output      psel5;
//   input       pready5;
//   input[7:0] prdata5;
//   input       pslverr5;
// `endif
  
  // Slave 6 signals
`ifdef APB_SLAVE6
  output      psel6;
  input       pready6;
  input[7:0] prdata6;
  input       pslverr6;
`endif
  
//   // Slave 7 signals
// `ifdef APB_SLAVE7
//   output      psel7;
//   input       pready7;
//   input[7:0] prdata7;
//   input       pslverr7;
// `endif
//   
//   // Slave 8 signals
// `ifdef APB_SLAVE8
//   output      psel8;
//   input       pready8;
//   input[7:0] prdata8;
//   input       pslverr8;
// `endif
//   
//   // Slave 9 signals
// `ifdef APB_SLAVE9
//   output      psel9;
//   input       pready9;
//   input[7:0] prdata9;
//   input       pslverr9;
// `endif
//   
//   // Slave 10 signals
// `ifdef APB_SLAVE10
//   output      psel10;
//   input       pready10;
//   input[7:0] prdata10;
//   input       pslverr10;
// `endif
//   
//   // Slave 11 signals
// `ifdef APB_SLAVE11
//   output      psel11;
//   input       pready11;
//   input[7:0] prdata11;
//   input       pslverr11;
// `endif
//   
//   // Slave 12 signals
// `ifdef APB_SLAVE12
//   output      psel12;
//   input       pready12;
//   input[7:0] prdata12;
//   input       pslverr12;
// `endif
//   
//   // Slave 13 signals
// `ifdef APB_SLAVE13
//   output      psel13;
//   input       pready13;
//   input[7:0] prdata13;
//   input       pslverr13;
// `endif
//   
//   // Slave 14 signals
// `ifdef APB_SLAVE14
//   output      psel14;
//   input       pready14;
//   input[7:0] prdata14;
//   input       pslverr14;
// `endif
//   
//   // Slave 15 signals
// `ifdef APB_SLAVE15
//   output      psel15;
//   input       pready15;
//   input[7:0] prdata15;
//   input       pslverr15;
// `endif
 
  input       reg_slverr_clr;
  output      slverr;
  reg         slverr;

wire        valid_cpu_cmd;
wire        pready_muxed;
wire [7:0] prdata_muxed;
reg  [2:0]  apb_state;
wire [2:0]  apb_state_idle;
wire [2:0]  apb_state_setup;
wire [2:0]  apb_state_access;
reg  [15:0] slave_select;
wire [15:0] pready_vector;
wire [15:0] pslverr_vector;
reg  [15:0] psel_vector;
wire        pslverr_muxed;
wire [7:0] prdata0_q;
wire [7:0] prdata1_q;
wire [7:0] prdata2_q;
wire [7:0] prdata3_q;
wire [7:0] prdata4_q;
wire [7:0] prdata5_q;
wire [7:0] prdata6_q;
wire [7:0] prdata7_q;
wire [7:0] prdata8_q;
wire [7:0] prdata9_q;
wire [7:0] prdata10_q;
wire [7:0] prdata11_q;
wire [7:0] prdata12_q;
wire [7:0] prdata13_q;
wire [7:0] prdata14_q;
wire [7:0] prdata15_q;

reg        ready_mask;
// cpu clk domain
assign ready = (((apb_state == apb_state_idle)&(valid_cpu_cmd == 1'b1 ))|
                (apb_state == apb_state_setup)) ? 1'b0 : 1'b1;
assign xdatai = prdata_muxed;

// pclk damain
reg [7:0]  pwdata;

assign pprot    = 3'h2;
assign pstrb    = 1'b1;

// Respond to cpu transfers
assign valid_cpu_cmd = xdatawr | xdatard;

always @(posedge clk or negedge resetn) begin
  if (resetn == 1'b0) begin
    ready_mask <= 1'b0;
  end else if (apb_state == apb_state_access && pready_muxed == 1'b1) begin 
    ready_mask <= 1'b1;
  end else begin  
    ready_mask <= 1'b0;
  end  
end

always @(posedge clk or negedge resetn) begin
  if (resetn == 1'b0) begin
    slverr <= 1'b0;
  end else if (reg_slverr_clr) begin 
    slverr <= 1'b0;
  end else if (apb_state == apb_state_access && pready_muxed == 1'b1) begin  
    slverr <= pslverr_muxed;
  end  
end

// APB state machine state definitions
assign apb_state_idle   = 3'b001;
assign apb_state_setup  = 3'b010;
assign apb_state_access = 3'b100;

// APB state machine
always @(posedge pclk or negedge presetn) begin
  if (presetn == 1'b0) begin
    apb_state   <= apb_state_idle;
    psel_vector <= 16'b0;
    penable     <= 1'b0;
    paddr       <= 1'b0;
    pwrite      <= 1'b0;
    pwdata      <= 8'b0;
  end  
  else begin
    
    // IDLE -> SETUP
    if (apb_state == apb_state_idle) begin
      if (valid_cpu_cmd == 1'b1  ) begin
        apb_state   <= apb_state_setup;
        psel_vector <= slave_select;
        paddr       <= xaddress;
        pwrite      <= xdatawr;
        pwdata      <= xdatao;
      end  
    end
    
    // SETUP -> TRANSFER
    //if ((apb_state == apb_state_setup)&(psel1|psel2|psel3|psel4|psel6)) begin
    if (apb_state == apb_state_setup) begin
        //if (psel1|psel2|psel3|psel4|psel6) begin //modify by jay 20220928
        if (psel1) begin
            apb_state <= apb_state_access;
            penable   <= 1'b1;
        end else begin
            apb_state <= apb_state_idle;
            penable   <= 1'b0;
        end
    end
    
    // TRANSFER -> IDLE
    if (apb_state == apb_state_access) begin
      if (pready_muxed == 1'b1) begin
        // TRANSFER -> IDLE
        apb_state   <= apb_state_idle;      
        penable     <= 1'b0;
        psel_vector <= 'b0;
      end
    end
    
  end
end

always @(*) begin
  slave_select = 16'b0;
  case(xaddress[17]) // regif is address[16] is i 
   /*`ifdef APB_SLAVE0
    12'hC, 12'hD : slave_select[0]   = 1'b1;
   `endif*/
   `ifdef APB_SLAVE1
    1'b1 : slave_select[1]   = 1'b1;
   `endif  
   /*`ifdef APB_SLAVE2  
    12'h7 : slave_select[2]   = 1'b1;
   `endif  
   `ifdef APB_SLAVE3  
    12'h8 : slave_select[3]   = 1'b1;
   `endif  
   `ifdef APB_SLAVE4  
    12'h9 : slave_select[4]   = 1'b1;
   `endif  
   `ifdef APB_SLAVE5  
    12'hA : slave_select[5]   = 1'b1;
   `endif  
   `ifdef APB_SLAVE6  
    12'hB : slave_select[6]   = 1'b1;
   `endif*/  
    default : slave_select = 16'b0;
  endcase
end

assign pready_muxed  = |(psel_vector & pready_vector);
assign pslverr_muxed = |(psel_vector & pslverr_vector);
assign prdata_muxed  = prdata0_q  | prdata1_q  | prdata2_q  | prdata3_q  |
                       prdata4_q  | prdata5_q  | prdata6_q  | prdata7_q  |
                       prdata8_q  | prdata9_q  | prdata10_q | prdata11_q |
                       prdata12_q | prdata13_q | prdata14_q | prdata15_q ;

`ifdef APB_SLAVE0
  assign psel0            = psel_vector[0];
  assign pready_vector[0] = pready0;
  assign pslverr_vector[0] = pslverr0;
  assign prdata0_q        = (psel0 == 1'b1) ? prdata0 : 'b0;
`else
  assign pready_vector[0] = 1'b0;
  assign pslverr_vector[0] = 1'b0;
  assign prdata0_q        = 'b0;
`endif

`ifdef APB_SLAVE1
  assign psel1            = psel_vector[1];
  assign pready_vector[1] = pready1;
  assign pslverr_vector[1] = pslverr1;
  assign prdata1_q        = (psel1 == 1'b1) ? prdata1 : 'b0;
`else
  assign pready_vector[1] = 1'b0;
  assign pslverr_vector[1] = 1'b0;
  assign prdata1_q        = 'b0;
`endif

`ifdef APB_SLAVE2
  assign psel2            = psel_vector[2];
  assign pready_vector[2] = pready2;
  assign pslverr_vector[2] = pslverr2;
  assign prdata2_q        = (psel2 == 1'b1) ? prdata2 : 'b0;
`else
  assign pready_vector[2] = 1'b0;
  assign pslverr_vector[2] = 1'b0;
  assign prdata2_q        = 'b0;
`endif

`ifdef APB_SLAVE3
  assign psel3            = psel_vector[3];
  assign pready_vector[3] = pready3;
  assign pslverr_vector[3] = pslverr3;
  assign prdata3_q        = (psel3 == 1'b1) ? prdata3 : 'b0;
`else
  assign pready_vector[3] = 1'b0;
  assign pslverr_vector[3] = 1'b0;
  assign prdata3_q        = 'b0;
`endif

`ifdef APB_SLAVE4
  assign psel4            = psel_vector[4];
  assign pready_vector[4] = pready4;
  assign pslverr_vector[4] = pslverr4;
  assign prdata4_q        = (psel4 == 1'b1) ? prdata4 : 'b0;
`else
  assign pready_vector[4] = 1'b0;
  assign pslverr_vector[4] = 1'b0;
  assign prdata4_q        = 'b0;
`endif

`ifdef APB_SLAVE5
  assign psel5            = psel_vector[5];
  assign pready_vector[5] = pready5;
  assign pslverr_vector[5] = pslverr5;
  assign prdata5_q        = (psel5 == 1'b1) ? prdata5 : 'b0;
`else
  assign pready_vector[5] = 1'b0;
  assign pslverr_vector[5] = 1'b0;
  assign prdata5_q        = 'b0;
`endif

`ifdef APB_SLAVE6
  assign psel6            = psel_vector[6];
  assign pready_vector[6] = pready6;
  assign pslverr_vector[6] = pslverr6;
  assign prdata6_q        = (psel6 == 1'b1) ? prdata6 : 'b0;
`else
  assign pready_vector[6] = 1'b0;
  assign pslverr_vector[6] = 1'b0;
  assign prdata6_q        = 'b0;
`endif

`ifdef APB_SLAVE7
  assign psel7            = psel_vector[7];
  assign pready_vector[7] = pready7;
  assign pslverr_vector[7] = pslverr7;
  assign prdata7_q        = (psel7 == 1'b1) ? prdata7 : 'b0;
`else
  assign pready_vector[7] = 1'b0;
  assign pslverr_vector[7] = 1'b0;
  assign prdata7_q        = 'b0;
`endif

`ifdef APB_SLAVE8
  assign psel8            = psel_vector[8];
  assign pready_vector[8] = pready8;
  assign pslverr_vector[8] = pslverr8;
  assign prdata8_q        = (psel8 == 1'b1) ? prdata8 : 'b0;
`else
  assign pready_vector[8] = 1'b0;
  assign pslverr_vector[8] = 1'b0;
  assign prdata8_q        = 'b0;
`endif

`ifdef APB_SLAVE9
  assign psel9            = psel_vector[9];
  assign pready_vector[9] = pready9;
  assign pslverr_vector[9] = pslverr9;
  assign prdata9_q        = (psel9 == 1'b1) ? prdata9 : 'b0;
`else
  assign pready_vector[9] = 1'b0;
  assign pslverr_vector[9] = 1'b0;
  assign prdata9_q        = 'b0;
`endif

`ifdef APB_SLAVE10
  assign psel10            = psel_vector[10];
  assign pready_vector[10] = pready10;
  assign pslverr_vector[10] = pslverr10;
  assign prdata10_q        = (psel10 == 1'b1) ? prdata10 : 'b0;
`else
  assign pready_vector[10] = 1'b0;
  assign pslverr_vector[10] = 1'b0;
  assign prdata10_q        = 'b0;
`endif

`ifdef APB_SLAVE11
  assign psel11            = psel_vector[11];
  assign pready_vector[11] = pready11;
  assign pslverr_vector[11] = pslverr11;
  assign prdata11_q        = (psel11 == 1'b1) ? prdata11 : 'b0;
`else
  assign pready_vector[11] = 1'b0;
  assign pslverr_vector[11] = 1'b0;
  assign prdata11_q        = 'b0;
`endif

`ifdef APB_SLAVE12
  assign psel12            = psel_vector[12];
  assign pready_vector[12] = pready12;
  assign pslverr_vector[12] = pslverr12;
  assign prdata12_q        = (psel12 == 1'b1) ? prdata12 : 'b0;
`else
  assign pready_vector[12] = 1'b0;
  assign pslverr_vector[12] = 1'b0;
  assign prdata12_q        = 'b0;
`endif

`ifdef APB_SLAVE13
  assign psel13            = psel_vector[13];
  assign pready_vector[13] = pready13;
  assign pslverr_vector[13] = pslverr13;
  assign prdata13_q        = (psel13 == 1'b1) ? prdata13 : 'b0;
`else
  assign pready_vector[13] = 1'b0;
  assign pslverr_vector[13] = 1'b0;
  assign prdata13_q        = 'b0;
`endif

`ifdef APB_SLAVE14
  assign psel14            = psel_vector[14];
  assign pready_vector[14] = pready14;
  assign pslverr_vector[14] = pslverr14;
  assign prdata14_q        = (psel14 == 1'b1) ? prdata14 : 'b0;
`else
  assign pready_vector[14] = 1'b0;
  assign pslverr_vector[14] = 1'b0;
  assign prdata14_q        = 'b0;
`endif

`ifdef APB_SLAVE15
  assign psel15            = psel_vector[15];
  assign pready_vector[15] = pready15;
  assign pslverr_vector[15] = pslverr15;
  assign prdata15_q        = (psel15 == 1'b1) ? prdata15 : 'b0;
`else
  assign pready_vector[15] = 1'b0;
  assign pslverr_vector[15] = 1'b0;
  assign prdata15_q        = 'b0;
`endif

endmodule
