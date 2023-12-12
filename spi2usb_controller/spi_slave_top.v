`timescale 1 ps/1 ps
//////////////////////////////////////////
//                                      //
//     this is top slave ip             //
// contain usb-side(48,60,80MHz) and FPGA side(10~266 MHz                                     //      
//      create by: Jay Gao              //
//      date: 2022/09/xx                // 
//////////////////////////////////////////
      

module spi_slave_top(
////////////////////TSB side
// slave_usb 
input reset_spi,// usb master button
input spiclk,
input CS, // active low
input SI,
output SO,
//CPU sram
//output CEN_o, //output
output [7:0] WEN_o, //output //write -> low //read -> high
output [16:0]A_o, //output
output [63:0]D_o, //output wadata
input  [63:0]Q, //input rdata
input ready,
//add for venus structure
output CEN_N, //active hign
output wr,
output rd,

////////////////MEM_DECODER side
//slave_CPU 
input cpu_clk,
input reset_cpu,// cpu master button
//cpu2apb
output [7:0] xdatai_cpu2apb,
output ready_cpu2apb,
input [7:0] xdatao,
input [23:0] xaddress,
input xdatawr,
input xdatard
);
wire CEN;
wire [7:0] WEN;

assign CEN_N = ~CEN;
assign WEN_o = WEN;

assign wr = ( (&WEN[7:0])==0 && CEN ==0)? 1'b1 : 1'b0; 
assign rd = (WEN==8'hff && CEN ==0)? 1'b1 : 1'b0; 
//status_reg3
wire [7:0] status3_pullup;
wire [7:0] CPUout_status_reg3;
//wdata
wire [63:0] wdata_fsm;
wire [63:0] wdata_usb_o;
//rdata
wire [63:0] rdata_cpu_o;
//wire rd_byte_done;

wire sram_wr_start;
wire wr_8byte_done_fsm;
wire sram_rd_start_fsm;
wire rd_8byte_done_o;
//cpu2apb
wire [31:0] paddr;
wire [2:0] pprot;
wire [7:0] pwdata;
wire [7:0] prdata1;
//regif
wire [7:0] vendor_cmd_buf0;                   
wire [7:0] vendor_cmd_buf1;                   
wire [7:0] vendor_cmd_buf2;                  
wire [7:0] vendor_cmd_buf3;                   
wire [7:0] vendor_cmd_buf4;                   
wire [7:0] vendor_cmd_buf5;                   
wire [7:0] vendor_cmd_buf6;                   
wire [7:0] vendor_cmd_buf7;                   
wire [7:0] vendor_cmd_buf8;                   
wire [7:0] vendor_cmd_buf9;                   
wire [7:0] vendor_cmd_buf10;                   
wire [7:0] vendor_cmd_buf11;                   
wire [7:0] vendor_cmd_buf12; 
wire [7:0] reg_status0;
wire [7:0] reg_status1;
wire [7:0] reg_status2;
wire [7:0] reg_status3_clear;
wire [7:0] status3_clr_tog;
wire [7:0] reg_wdata_address_HS;
wire [7:0] reg_wdata_address_H;
wire [7:0] reg_wdata_address_L;
wire [7:0] reg_rdata_address_HS;
wire [7:0] reg_rdata_address_H;
wire [7:0] reg_rdata_address_L;


spi_slave_usb u_spi_slave_usb(
                          .spiclk               (spiclk),// input
                          .CS                   (CS),
                          .SI                   (SI),// input
                          .SO                   (SO),      // output
                          .rst                  (reset_spi),
                          .status3_pullup       (status3_pullup),//ouput
                          .status_reg3          (CPUout_status_reg3), //input
                          .status3_clr_tog     (status3_clr_tog),//input
                          .vendor_cmd_buf0      (vendor_cmd_buf0),
                          .vendor_cmd_buf1      (vendor_cmd_buf1),
                          .vendor_cmd_buf2      (vendor_cmd_buf2),
                          .vendor_cmd_buf3      (vendor_cmd_buf3),
                          .vendor_cmd_buf4      (vendor_cmd_buf4),
                          .vendor_cmd_buf5      (vendor_cmd_buf5),
                          .vendor_cmd_buf6      (vendor_cmd_buf6),
                          .vendor_cmd_buf7      (vendor_cmd_buf7),
                          .vendor_cmd_buf8      (vendor_cmd_buf8),
                          .vendor_cmd_buf9      (vendor_cmd_buf9),
                          .vendor_cmd_buf10     (vendor_cmd_buf10),
                          .vendor_cmd_buf11     (vendor_cmd_buf11),
                          .vendor_cmd_buf12     (vendor_cmd_buf12),
                          .wdata                (wdata_fsm), //fsm output
                          .sram_wr_start        (sram_wr_start),//fsm output
                          .wr_8byte_done        (wr_8byte_done_fsm),//fsm output
                          .rdata                (rdata_cpu_o), //fsm input
                          .sram_rd_start        (sram_rd_start_fsm),
                          .rd_8byte_done        (rd_8byte_done_o),
                          //regif
                          .reg_status0          (reg_status0),
                          .reg_status1          (reg_status1),
                          .reg_status2          (reg_status2)
                         );

spi_slave_CPU u_spi_slave_CPU(
                           //input
                           .cpu_clk              (cpu_clk),
                           .rstb                 (reset_cpu),
                           .status3_setup_tog    (status3_pullup),//usb_output
                           .status3_clr_tog     (status3_clr_tog),//input
                           //output
                           .CPU_status_reg3      (CPUout_status_reg3)//output
                          );

sram_ctrl_CPU u_sram_ctrl_CPU(      
                            .CS                  (CS),//input
                            //usb_side
                            .sram_wr_start       (sram_wr_start),
                            .wdata               (wdata_fsm), //input
                            .wr_8byte_done        (wr_8byte_done_fsm), //input
                            .sram_rd_start       (sram_rd_start_fsm), //input
                            .rd_8byte_done        (rd_8byte_done_o),//input
                            //CPU side 
                            .cpu_clk            (cpu_clk), //input
                            .rstb               (reset_cpu), //input
                            .CEN                (CEN), //output
                            .WEN                (WEN), //output
                            .A                  (A_o), //output
                            .D                  (D_o), //output wadata
                            .Q                  (Q), //input rdata
                            .ready              (ready), //input
                            //regif
                            .wr_start_addr_HS   (reg_wdata_address_HS),//input
                            .wr_start_addr_H    (reg_wdata_address_H),//input
                            .wr_start_addr_L    (reg_wdata_address_L),//input
                            .rd_start_addr_HS   (reg_rdata_address_HS ),//input
                            .rd_start_addr_H    (reg_rdata_address_H ),//input
                            .rd_start_addr_L    (reg_rdata_address_L ), //input
                            .rdata_cpu_sram     (rdata_cpu_o)
                    );

cpu2apb u_cpu2apb (/*AUTOINST*/
                   // Outputs
                   .xdatai              (xdatai_cpu2apb),        // Templated
                   .ready               (ready_cpu2apb),         // Templated
                   .paddr               (paddr[31:0]),
                   .penable             (penable),
                   .pwrite              (pwrite),
                   .pprot               (pprot[2:0]),
                   .pstrb               (pstrb),
                   .pwdata              (pwdata[7:0]),
                   .psel1               (psel1),
                   /*.psel2             (psel2),
                   .psel3               (psel3),
                   .psel4               (psel4),
                   .psel6               (psel6),*/
                   .slverr              (),                      // Templated
                   // Inputs
                   .clk                 (cpu_clk),                       // Templated
                   .resetn              (reset_cpu),             // Templated
                   .xaddress    (xaddress),
                   .xdatao              (xdatao),
                   //.xdataz            (xdataz),
                   .xdatawr             (xdatawr),
                   .xdatard             (xdatard),
                   .pclk                (cpu_clk),
                   .presetn             (reset_cpu),
                   .pready1             (pready1),
                   .prdata1             (prdata1[7:0]),
                   .pslverr1    (pslverr1),
                   /*.pready2           (pready2),
                   .prdata2             (prdata2[7:0]),
                   .pslverr2            (pslverr2),
                   .pready3             (pready3),
                   .prdata3             (prdata3[7:0]),
                   .pslverr3            (pslverr3),
                   .pready4             (pready4),
                   .prdata4             (prdata4[7:0]),
                   .pslverr4            (pslverr4),
                   .pready6             (pready6),
                   .prdata6             (prdata6[7:0]),
                   .pslverr6            (pslverr6),*/
                   .reg_slverr_clr      (1'b0)
);                       // Templated
wire [11:0] paddr_sel;
assign paddr_sel =  { {7'b0000000} , {paddr[4:0]} };
reg_spi_slave_reg u_reg_spi_slave_reg(
// APB programming interface
            //input 
           .cpu_clk                     (cpu_clk),
               .presetn                 (reset_cpu),
           .paddr                       (paddr_sel[11:0]),
               .pwrite                  (pwrite),
               .psel                    (psel1),
               .penable                 (penable),
               .pprot                   (pprot[2:0]),
               .pstrb                   (pstrb),
               .pwdata                  (pwdata[7:0]),
           .pready_ack      (1'b1),
            //output
           .prdata          (prdata1),
           .pready          (pready1),
           .pslverr         (pslverr1),
                        
            //output
            .reg_rdata_address_HS    (reg_rdata_address_HS),
            .reg_rdata_address_H     (reg_rdata_address_H),
            .reg_rdata_address_L     (reg_rdata_address_L),
            .reg_status0             (reg_status0),
            .reg_status1             (reg_status1),
            .reg_status2             (reg_status2),
            .reg_wdata_address_HS    (reg_wdata_address_HS),
            .reg_wdata_address_H     (reg_wdata_address_H),
            .reg_wdata_address_L     (reg_wdata_address_L),
            .reg_status3_clr         (status3_clr_tog),
            //input
            .reg_status3            (CPUout_status_reg3),
            .reg_vnedor_cmd0        (vendor_cmd_buf0),
            .reg_vnedor_cmd1        (vendor_cmd_buf1),       
            .reg_vnedor_cmd2        (vendor_cmd_buf2),
            .reg_vnedor_cmd3        (vendor_cmd_buf3),
            .reg_vnedor_cmd4        (vendor_cmd_buf4),
            .reg_vnedor_cmd5        (vendor_cmd_buf5),
            .reg_vnedor_cmd6        (vendor_cmd_buf6),
            .reg_vnedor_cmd7        (vendor_cmd_buf7),
            .reg_vnedor_cmd8        (vendor_cmd_buf8),
            .reg_vnedor_cmd9        (vendor_cmd_buf9),
            .reg_vnedor_cmd10       (vendor_cmd_buf10),
            .reg_vnedor_cmd11       (vendor_cmd_buf11),
            .reg_vnedor_cmd12       (vendor_cmd_buf12)
);

endmodule
