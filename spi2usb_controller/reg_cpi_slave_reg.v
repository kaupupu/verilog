// $RCSfile: $
// $Revision: $
// $Script Version: 1.7.9 $
// $Author:  $
// $Project: venus $
// $SubSystem:  $
// $Module: spi_slave_reg $
// $RegisterBank Version: V 1.0.00 $
// $Date: Thu, 29 Dec 2022 03:35:32 PM $
//

module reg_spi_slave_reg (
// register output to IP by APB writing (field)
output reg [ 7: 0] reg_rdata_address_H,
output reg [ 7: 0] reg_rdata_address_HS,
output reg [ 7: 0] reg_rdata_address_L,
output reg [ 7: 0] reg_status0,
output reg [ 7: 0] reg_status1,
output reg [ 7: 0] reg_status2,
output reg [ 7: 0] reg_wdata_address_H,
output reg [ 7: 0] reg_wdata_address_HS,
output reg [ 7: 0] reg_wdata_address_L,
// register output to IP set signal : set
// register output to IP clear signal : clear
output reg [ 7: 0] reg_status3_clr,
// register enable output by APB writing (register)
// register input from IP for APB reading
input [ 7: 0] reg_status3,
input [ 7: 0] reg_vnedor_cmd0,
input [ 7: 0] reg_vnedor_cmd1,
input [ 7: 0] reg_vnedor_cmd10,
input [ 7: 0] reg_vnedor_cmd11,
input [ 7: 0] reg_vnedor_cmd12,
input [ 7: 0] reg_vnedor_cmd2,
input [ 7: 0] reg_vnedor_cmd3,
input [ 7: 0] reg_vnedor_cmd4,
input [ 7: 0] reg_vnedor_cmd5,
input [ 7: 0] reg_vnedor_cmd6,
input [ 7: 0] reg_vnedor_cmd7,
input [ 7: 0] reg_vnedor_cmd8,
input [ 7: 0] reg_vnedor_cmd9,
// reset & clock
input         cpu_clk,
input         presetn,
// APB programming interface
input  [11:0] paddr,
input         pwrite,
input         psel,
input         penable,
input  [2:0]  pprot,    //[0]: 1 = privileged access,  0 = normal access
                        //[1]: 1 = nonsecure access,   0 = secure access
                        //[2]: 1 = instruction access, 0 = data access
input  [0:0]  pstrb,    // for APB 4
input  [7:0] pwdata,   // upper 16-bit is write mask if mask function is enabled
input         pready_ack,
output reg  [7:0] prdata,
output reg         pready,
output reg         pslverr
);
parameter RD=0;

// definition here
parameter REG_SPI_SLAVE_REG_SPI_CFG_0 = 12'h0;
parameter REG_SPI_SLAVE_REG_SPI_CFG_1 = 12'h1;
parameter REG_SPI_SLAVE_REG_SPI_CFG_2 = 12'h2;
parameter REG_SPI_SLAVE_REG_SPI_CFG_3 = 12'h3;
parameter REG_SPI_SLAVE_REG_SPI_CFG_4 = 12'h4;
parameter REG_SPI_SLAVE_REG_SPI_CFG_5 = 12'h5;
parameter REG_SPI_SLAVE_REG_SPI_CFG_6 = 12'h6;
parameter REG_SPI_SLAVE_REG_SPI_CFG_7 = 12'h7;
parameter REG_SPI_SLAVE_REG_SPI_CFG_8 = 12'h8;
parameter REG_SPI_SLAVE_REG_SPI_CFG_9 = 12'h9;
parameter REG_SPI_SLAVE_REG_SPI_CFG_10 = 12'ha;
parameter REG_SPI_SLAVE_REG_SPI_CFG_11 = 12'hb;
parameter REG_SPI_SLAVE_REG_SPI_CFG_12 = 12'hc;
parameter REG_SPI_SLAVE_REG_SPI_CFG_13 = 12'hd;
parameter REG_SPI_SLAVE_REG_SPI_CFG_14 = 12'he;
parameter REG_SPI_SLAVE_REG_SPI_CFG_15 = 12'hf;
parameter REG_SPI_SLAVE_REG_SPI_CFG_16 = 12'h10;
parameter REG_SPI_SLAVE_REG_SPI_CFG_17 = 12'h11;
parameter REG_SPI_SLAVE_REG_SPI_CFG_18 = 12'h12;
parameter REG_SPI_SLAVE_REG_SPI_CFG_19 = 12'h13;
parameter REG_SPI_SLAVE_REG_SPI_CFG_20 = 12'h14;
parameter REG_SPI_SLAVE_REG_SPI_CFG_21 = 12'h15;
parameter REG_SPI_SLAVE_REG_SPI_CFG_22 = 12'h16;

// register init here
parameter REG_STATUS0_INIT = 8'hf0;
parameter REG_STATUS1_INIT = 8'hf1;
parameter REG_STATUS2_INIT = 8'hf2;
parameter REG_STATUS3_INIT = 8'h06;
parameter REG_VNEDOR_CMD0_INIT = 8'hf3;
parameter REG_VNEDOR_CMD1_INIT = 8'hf4;
parameter REG_VNEDOR_CMD2_INIT = 8'hf5;
parameter REG_VNEDOR_CMD3_INIT = 8'hf6;
parameter REG_VNEDOR_CMD4_INIT = 8'hf7;
parameter REG_VNEDOR_CMD5_INIT = 8'hf8;
parameter REG_VNEDOR_CMD6_INIT = 8'hf9;
parameter REG_VNEDOR_CMD7_INIT = 8'hfa;
parameter REG_VNEDOR_CMD8_INIT = 8'hfb;
parameter REG_VNEDOR_CMD9_INIT = 8'hfc;
parameter REG_VNEDOR_CMD10_INIT = 8'hfd;
parameter REG_VNEDOR_CMD11_INIT = 8'hfe;
parameter REG_VNEDOR_CMD12_INIT = 8'hff;
parameter REG_WDATA_ADDRESS_HS_INIT = 8'h1;
parameter REG_WDATA_ADDRESS_H_INIT = 8'h2;
parameter REG_WDATA_ADDRESS_L_INIT = 8'h3;
parameter REG_RDATA_ADDRESS_HS_INIT = 8'h1;
parameter REG_RDATA_ADDRESS_H_INIT = 8'h2;
parameter REG_RDATA_ADDRESS_L_INIT = 8'h3;

// register internal declare

// address read enable control
reg pready_pre;
wire rdata_en = psel & ~pwrite;
wire rd_en    = penable & psel & ~pwrite & pready_pre;

// address write enable control
wire wr_en = psel & pwrite & ~penable;
wire wr_en_mask = wr_en;
wire [7:0] pwstrb_mask = {{8{pstrb[0]}}};
wire [7:0] pwstrb_mask_pwdata = pwstrb_mask[7:0] & pwdata[7:0];
wire en_addr_0000 = (paddr[11:0] == REG_SPI_SLAVE_REG_SPI_CFG_0) & wr_en;
wire en_addr_0001 = (paddr[11:0] == REG_SPI_SLAVE_REG_SPI_CFG_1) & wr_en;
wire en_addr_0002 = (paddr[11:0] == REG_SPI_SLAVE_REG_SPI_CFG_2) & wr_en;
wire en_addr_0003 = (paddr[11:0] == REG_SPI_SLAVE_REG_SPI_CFG_3) & wr_en;
wire en_addr_0004 = (paddr[11:0] == REG_SPI_SLAVE_REG_SPI_CFG_4) & wr_en;
wire en_addr_0005 = (paddr[11:0] == REG_SPI_SLAVE_REG_SPI_CFG_5) & wr_en;
wire en_addr_0006 = (paddr[11:0] == REG_SPI_SLAVE_REG_SPI_CFG_6) & wr_en;
wire en_addr_0007 = (paddr[11:0] == REG_SPI_SLAVE_REG_SPI_CFG_7) & wr_en;
wire en_addr_0008 = (paddr[11:0] == REG_SPI_SLAVE_REG_SPI_CFG_8) & wr_en;
wire en_addr_0009 = (paddr[11:0] == REG_SPI_SLAVE_REG_SPI_CFG_9) & wr_en;
wire en_addr_000a = (paddr[11:0] == REG_SPI_SLAVE_REG_SPI_CFG_10) & wr_en;
wire en_addr_000b = (paddr[11:0] == REG_SPI_SLAVE_REG_SPI_CFG_11) & wr_en;
wire en_addr_000c = (paddr[11:0] == REG_SPI_SLAVE_REG_SPI_CFG_12) & wr_en;
wire en_addr_000d = (paddr[11:0] == REG_SPI_SLAVE_REG_SPI_CFG_13) & wr_en;
wire en_addr_000e = (paddr[11:0] == REG_SPI_SLAVE_REG_SPI_CFG_14) & wr_en;
wire en_addr_000f = (paddr[11:0] == REG_SPI_SLAVE_REG_SPI_CFG_15) & wr_en;
wire en_addr_0010 = (paddr[11:0] == REG_SPI_SLAVE_REG_SPI_CFG_16) & wr_en;
wire en_addr_0011 = (paddr[11:0] == REG_SPI_SLAVE_REG_SPI_CFG_17) & wr_en;
wire en_addr_0012 = (paddr[11:0] == REG_SPI_SLAVE_REG_SPI_CFG_18) & wr_en;
wire en_addr_0013 = (paddr[11:0] == REG_SPI_SLAVE_REG_SPI_CFG_19) & wr_en;
wire en_addr_0014 = (paddr[11:0] == REG_SPI_SLAVE_REG_SPI_CFG_20) & wr_en;
wire en_addr_0015 = (paddr[11:0] == REG_SPI_SLAVE_REG_SPI_CFG_21) & wr_en;
wire en_addr_0016 = (paddr[11:0] == REG_SPI_SLAVE_REG_SPI_CFG_22) & wr_en;

// read data normal
reg [7:0] prdata_p;
reg        pslverr_p;
always@* begin : REG_PRDATA
    pslverr_p = 1'b0;
    case(paddr[11:0])
      REG_SPI_SLAVE_REG_SPI_CFG_0  : prdata_p =  {reg_status0[7:0]} ;
      REG_SPI_SLAVE_REG_SPI_CFG_1  : prdata_p =  {reg_status1[7:0]} ;
      REG_SPI_SLAVE_REG_SPI_CFG_2  : prdata_p =  {reg_status2[7:0]} ;
      REG_SPI_SLAVE_REG_SPI_CFG_3  : prdata_p =  {reg_status3[7:0]} ;
      REG_SPI_SLAVE_REG_SPI_CFG_4  : prdata_p =  {reg_vnedor_cmd0[7:0]} ;
      REG_SPI_SLAVE_REG_SPI_CFG_5  : prdata_p =  {reg_vnedor_cmd1[7:0]} ;
      REG_SPI_SLAVE_REG_SPI_CFG_6  : prdata_p =  {reg_vnedor_cmd2[7:0]} ;
      REG_SPI_SLAVE_REG_SPI_CFG_7  : prdata_p =  {reg_vnedor_cmd3[7:0]} ;
      REG_SPI_SLAVE_REG_SPI_CFG_8  : prdata_p =  {reg_vnedor_cmd4[7:0]} ;
      REG_SPI_SLAVE_REG_SPI_CFG_9  : prdata_p =  {reg_vnedor_cmd5[7:0]} ;
      REG_SPI_SLAVE_REG_SPI_CFG_10 : prdata_p =  {reg_vnedor_cmd6[7:0]} ;
      REG_SPI_SLAVE_REG_SPI_CFG_11 : prdata_p =  {reg_vnedor_cmd7[7:0]} ;
      REG_SPI_SLAVE_REG_SPI_CFG_12 : prdata_p =  {reg_vnedor_cmd8[7:0]} ;
      REG_SPI_SLAVE_REG_SPI_CFG_13 : prdata_p =  {reg_vnedor_cmd9[7:0]} ;
      REG_SPI_SLAVE_REG_SPI_CFG_14 : prdata_p =  {reg_vnedor_cmd10[7:0]} ;
      REG_SPI_SLAVE_REG_SPI_CFG_15 : prdata_p =  {reg_vnedor_cmd11[7:0]} ;
      REG_SPI_SLAVE_REG_SPI_CFG_16 : prdata_p =  {reg_vnedor_cmd12[7:0]} ;
      REG_SPI_SLAVE_REG_SPI_CFG_17 : prdata_p =  {reg_wdata_address_HS[7:0]} ;
      REG_SPI_SLAVE_REG_SPI_CFG_18 : prdata_p =  {reg_wdata_address_H[7:0]} ;
      REG_SPI_SLAVE_REG_SPI_CFG_19 : prdata_p =  {reg_wdata_address_L[7:0]} ;
      REG_SPI_SLAVE_REG_SPI_CFG_20 : prdata_p =  {reg_rdata_address_HS[7:0]} ;
      REG_SPI_SLAVE_REG_SPI_CFG_21 : prdata_p =  {reg_rdata_address_H[7:0]} ;
      REG_SPI_SLAVE_REG_SPI_CFG_22 : prdata_p =  {reg_rdata_address_L[7:0]} ;

      default:begin
          prdata_p = 8'h00;
          pslverr_p = 1'b0;
          // synopsys translate_off
          `ifndef DIS_REGB_DECERR
            #0;
            if (psel & (wr_en | rdata_en)) begin
              $display($stime, ":[RegBank Report]:ERROR! %0s invalid address:0x%04h at %m", (pwrite) ? "WRITE" : "READ", paddr);
            end
          `endif
          // synopsys translate_on
        end
    endcase
end

///////////////////
//generate pslverr,prdata//
///////////////////
always @(posedge cpu_clk or negedge presetn)
begin:blk_prdata_pslverr
  if(~presetn) begin
    prdata <= #RD 8'h0;
  end
  else if(rdata_en) begin
    prdata <= #RD prdata_p;
  end
end
  
////////////////////
// generate pready & pslverr//
////////////////////
always @(posedge cpu_clk or negedge presetn) 
begin:blk_pready_pre
  if(~presetn)
    pready_pre <= #RD 1'b0;
  else if(psel & !penable)
    pready_pre <= #RD 1'b1;
  else
    pready_pre <= #RD 1'b0;
end

always @(posedge cpu_clk or negedge presetn) 
begin:blk_pready_pslverr
  if(~presetn) begin
    pready  <= #RD 1'b1;
    pslverr <= #RD 1'b1;
  end
  else if(pready) begin
    pready  <= #RD 1'b0;
    pslverr <= #RD 1'b0;
  end
  else if(psel & pready_ack) begin
    pready  <= #RD 1'b1;
    pslverr <= #RD pslverr_p;
  end
end
  
  
///////////////////////////
//generate write register//
///////////////////////////
// paddr = h0000
always @(posedge cpu_clk or negedge presetn)
begin:addr_h0_blk_SPI_CFG_0
  if(~presetn) begin
    reg_status0[7:0] <= #RD REG_STATUS0_INIT[7:0];
  end
  else if(en_addr_0000) begin
    reg_status0[7:0] <= #RD (~pwstrb_mask[7:0] & reg_status0[7:0]) |  pwstrb_mask_pwdata[7:0]; 
  end
end

// paddr = h0001
always @(posedge cpu_clk or negedge presetn)
begin:addr_h1_blk_SPI_CFG_1
  if(~presetn) begin
    reg_status1[7:0] <= #RD REG_STATUS1_INIT[7:0];
  end
  else if(en_addr_0001) begin
    reg_status1[7:0] <= #RD (~pwstrb_mask[7:0] & reg_status1[7:0]) |  pwstrb_mask_pwdata[7:0]; 
  end
end

// paddr = h0002
always @(posedge cpu_clk or negedge presetn)
begin:addr_h2_blk_SPI_CFG_2
  if(~presetn) begin
    reg_status2[7:0] <= #RD REG_STATUS2_INIT[7:0];
  end
  else if(en_addr_0002) begin
    reg_status2[7:0] <= #RD (~pwstrb_mask[7:0] & reg_status2[7:0]) |  pwstrb_mask_pwdata[7:0]; 
  end
end

// paddr = h0003
always @(posedge cpu_clk or negedge presetn)
begin:addr_h3_blk_SPI_CFG_3
  if(~presetn) begin
    reg_status3_clr[7:0] <= #RD 8'h0;
  end
  else if(en_addr_0003) begin
    reg_status3_clr[7:0] <= #RD reg_status3_clr[7:0] ^ pwstrb_mask_pwdata[7:0];
  end
end

// paddr = h0011
always @(posedge cpu_clk or negedge presetn)
begin:addr_h11_blk_SPI_CFG_17
  if(~presetn) begin
    reg_wdata_address_HS[7:0] <= #RD REG_WDATA_ADDRESS_HS_INIT[7:0];
  end
  else if(en_addr_0011) begin
    reg_wdata_address_HS[7:0] <= #RD (~pwstrb_mask[7:0] & reg_wdata_address_HS[7:0]) |  pwstrb_mask_pwdata[7:0]; 
  end
end

// paddr = h0012
always @(posedge cpu_clk or negedge presetn)
begin:addr_h12_blk_SPI_CFG_18
  if(~presetn) begin
    reg_wdata_address_H[7:0] <= #RD REG_WDATA_ADDRESS_H_INIT[7:0];
  end
  else if(en_addr_0012) begin
    reg_wdata_address_H[7:0] <= #RD (~pwstrb_mask[7:0] & reg_wdata_address_H[7:0]) |  pwstrb_mask_pwdata[7:0]; 
  end
end

// paddr = h0013
always @(posedge cpu_clk or negedge presetn)
begin:addr_h13_blk_SPI_CFG_19
  if(~presetn) begin
    reg_wdata_address_L[7:0] <= #RD REG_WDATA_ADDRESS_L_INIT[7:0];
  end
  else if(en_addr_0013) begin
    reg_wdata_address_L[7:0] <= #RD (~pwstrb_mask[7:0] & reg_wdata_address_L[7:0]) |  pwstrb_mask_pwdata[7:0]; 
  end
end

// paddr = h0014
always @(posedge cpu_clk or negedge presetn)
begin:addr_h14_blk_SPI_CFG_20
  if(~presetn) begin
    reg_rdata_address_HS[7:0] <= #RD REG_RDATA_ADDRESS_HS_INIT[7:0];
  end
  else if(en_addr_0014) begin
    reg_rdata_address_HS[7:0] <= #RD (~pwstrb_mask[7:0] & reg_rdata_address_HS[7:0]) |  pwstrb_mask_pwdata[7:0]; 
  end
end

// paddr = h0015
always @(posedge cpu_clk or negedge presetn)
begin:addr_h15_blk_SPI_CFG_21
  if(~presetn) begin
    reg_rdata_address_H[7:0] <= #RD REG_RDATA_ADDRESS_H_INIT[7:0];
  end
  else if(en_addr_0015) begin
    reg_rdata_address_H[7:0] <= #RD (~pwstrb_mask[7:0] & reg_rdata_address_H[7:0]) |  pwstrb_mask_pwdata[7:0]; 
  end
end

// paddr = h0016
always @(posedge cpu_clk or negedge presetn)
begin:addr_h16_blk_SPI_CFG_22
  if(~presetn) begin
    reg_rdata_address_L[7:0] <= #RD REG_RDATA_ADDRESS_L_INIT[7:0];
  end
  else if(en_addr_0016) begin
    reg_rdata_address_L[7:0] <= #RD (~pwstrb_mask[7:0] & reg_rdata_address_L[7:0]) |  pwstrb_mask_pwdata[7:0]; 
  end
end

////////////////////////////
//generate shadow register//
////////////////////////////
endmodule // reg_spi_slave_reg
