`timescale 1 ps/1 ps
//////////////////////////////////////////
//                                      //
//     this is slave SRAM Controller    //
//    for SRAM interface                //
//      create by: Jay Gao              //
//      date:                 // 
//////////////////////////////////////////

module sram_ctrl_CPU(
    input CS,
    //usb side
    input sram_wr_start,
    input [63:0]wdata,
    input wr_8byte_done,
    input sram_rd_start,
    input rd_8byte_done,
    //CPU side 
    input cpu_clk,
    input rstb,
    output CEN,
    output [7:0] WEN,
    output [16:0]A,//from regif which decide by FW
    output [63:0]D,//wdata
    input  [63:0]Q, //rdata
    input ready, // from SRAM control by CPU
    input [7:0]wr_start_addr_HS,
    input [7:0]wr_start_addr_H, 
    input [7:0]wr_start_addr_L, 
    input [7:0]rd_start_addr_HS, 
    input [7:0]rd_start_addr_H, 
    input [7:0]rd_start_addr_L,
    output reg[63:0]rdata_cpu_sram 

);

//wr start sync reg
reg sync_sram_wr_start_ff1;
reg sync_sram_wr_start_ff2;
reg sync_sram_wr_start_ff3;//for pulse
//wr 8byte done sync reg
reg sync_wr_8byte_done_ff1;
reg sync_wr_8byte_done_ff2;
reg sync_wr_8byte_done_ff3;//for pulse
//rd start sync reg
reg sync_sram_rd_start_ff1;
reg sync_sram_rd_start_ff2;
reg sync_sram_rd_start_ff3;//for pulse
//rd 8byte done sync reg
reg sync_rd_8byte_done_ff1;
reg sync_rd_8byte_done_ff2;
reg sync_rd_8byte_done_ff3;//for pulse

//create pulse
reg wr_pulse_A;
reg wr_pulse_B;
wire wr_pulse;
reg rd_pulse_A;
reg rd_pulse_B;
reg rd_pulse_C;//rd_pulse_B delay 1t. for matching protocol
wire rd_pulse;
//
reg [13:0] wen_cnt;//write data byte count

//Address
reg [16:0] A_temp_wr;
reg [16:0] A_temp_rd;
wire [16:0] A_wr_start;
wire [16:0] A_rd_start;
reg A_wr_keep;// flag for keep address
reg A_rd_keep;

//count for delete erase sram_rd_start
reg [4:0]era_sram_rd_start_cnt;
always @(posedge cpu_clk or negedge rstb)begin
    if(rstb==0)
         era_sram_rd_start_cnt <=0;
    else if (CS==1)
         era_sram_rd_start_cnt <=0;
    else if (CS==0)
         era_sram_rd_start_cnt <= era_sram_rd_start_cnt+1;
end

///////////////////////////syc filp flop for write////////////////////////////////
//wr start sync ff action
always @(posedge cpu_clk or negedge rstb)begin
    if(rstb==0)
         sync_sram_wr_start_ff1 <=0;
    else
         sync_sram_wr_start_ff1 <= sram_wr_start;
end
always @(posedge cpu_clk or negedge rstb)begin
    if(rstb==0)
         sync_sram_wr_start_ff2 <=0;
    else
         sync_sram_wr_start_ff2 <= sync_sram_wr_start_ff1;
end
always @(posedge cpu_clk or negedge rstb)begin
    if(rstb==0)
         sync_sram_wr_start_ff3 <=0;
    else
         sync_sram_wr_start_ff3 <= sync_sram_wr_start_ff2;
end

//wr 8 byte sync ff action
always @(posedge cpu_clk or negedge rstb)begin
    if(rstb==0)
         sync_wr_8byte_done_ff1 <=0;
    else 
         sync_wr_8byte_done_ff1 <= wr_8byte_done;
end

always @(posedge cpu_clk or negedge rstb)begin
    if(rstb==0)
         sync_wr_8byte_done_ff2 <=0;
    else
         sync_wr_8byte_done_ff2 <= sync_wr_8byte_done_ff1;
end

always @(posedge cpu_clk or negedge rstb)begin
    if(rstb==0)
         sync_wr_8byte_done_ff3 <=0;
    else
         sync_wr_8byte_done_ff3 <= sync_wr_8byte_done_ff2;
end

///////////////////////////syc filp flop for READ////////////////////////////////
//rd start sync ff action
always @(posedge cpu_clk or negedge rstb)begin
    if(rstb==0)
         sync_sram_rd_start_ff1 <=0;
    else if (era_sram_rd_start_cnt>3)//erase sram_rd_start when Bit =0
         sync_sram_rd_start_ff1 <= sram_rd_start;
end
always @(posedge cpu_clk or negedge rstb)begin
    if(rstb==0)
         sync_sram_rd_start_ff2 <=0;
    else
         sync_sram_rd_start_ff2 <= sync_sram_rd_start_ff1;
end
always @(posedge cpu_clk or negedge rstb)begin
    if(rstb==0)
         sync_sram_rd_start_ff3 <=0;
    else
         sync_sram_rd_start_ff3 <= sync_sram_rd_start_ff2;
end

//rd 8byte doen sync ff action
always @(posedge cpu_clk or negedge rstb)begin
    if(rstb==0)
         sync_rd_8byte_done_ff1 <=0;
    else
         sync_rd_8byte_done_ff1 <= rd_8byte_done;
end

always @(posedge cpu_clk or negedge rstb)begin
    if(rstb==0)
         sync_rd_8byte_done_ff2 <=0;
    else
         sync_rd_8byte_done_ff2 <= sync_rd_8byte_done_ff1;
end

always @(posedge cpu_clk or negedge rstb)begin
    if(rstb==0)
         sync_rd_8byte_done_ff3 <=0;
    else
         sync_rd_8byte_done_ff3 <= sync_rd_8byte_done_ff2;
end
/////////////////////////////////READ & WRITE pulse////////////////////////////
//wr__pulse 
always @(*)begin
    if (sync_wr_8byte_done_ff2 ==1 && sync_wr_8byte_done_ff3==0)
        wr_pulse_A =1;
    else
        wr_pulse_A =0;
end

always @(posedge cpu_clk or negedge rstb)begin
    if(rstb==0)
        wr_pulse_B <= 0;
    else if (ready == 0 && wr_pulse ==1)//used for ready signal //req and ack
        wr_pulse_B <= 1; 
    else if (ready == 1)
        wr_pulse_B <= 0; 
end

assign wr_pulse = wr_pulse_A | wr_pulse_B;

//rd__pulse
always @(*)begin
    if ((sync_sram_rd_start_ff2 ==1 && sync_sram_rd_start_ff3 ==0) || (sync_rd_8byte_done_ff2 ==0 &&sync_rd_8byte_done_ff3 ==1))
        rd_pulse_A =1;
    else
        rd_pulse_A =0;
end

always @(posedge cpu_clk or negedge rstb)begin
    if(rstb==0)
        rd_pulse_B <= 0;
    else if (ready == 0 && rd_pulse ==1)//used for ready signal //req and ack
        rd_pulse_B <= 1; 
    else if (ready == 1)
        rd_pulse_B <= 0;
end

assign rd_pulse = rd_pulse_A | rd_pulse_B;

////////////////////////////////////////////////CEN///////////////////////////////////////////
assign CEN = (wr_pulse | rd_pulse) ? 1'b0 : 1'b1; //delay test in real dealy


////////////////////////////////////////////////WEN///////////////////////////////////////////
// wr -> wen = 0         rd -> wen = 1
assign WEN = wr_pulse==1'b1 ?  8'h00: 
             rd_pulse==1'b1 ?  8'hff: 8'hff;


////////////////////////////////////////////////A///////////////////////////////////////////
//address
assign A_wr_start = {{wr_start_addr_HS[0]},{wr_start_addr_H},{wr_start_addr_L}};
assign A_rd_start = {{rd_start_addr_HS[0]},{rd_start_addr_H},{rd_start_addr_L}};
always @(posedge cpu_clk or negedge rstb)begin
    if(rstb==0)begin
            wen_cnt <= 0;
    end else begin
            if(CS==1)begin
                wen_cnt <= 0;
            end else if(CEN==0 && rd_pulse_B==1)begin
                wen_cnt <= wen_cnt +1;
            end
    end
end
//keep address (start from last wr address)
always @(posedge cpu_clk or negedge rstb)begin
    if(rstb==0)begin
        A_wr_keep <= 0;
    end else if (sync_sram_wr_start_ff3 ==1) begin
        A_wr_keep <= 1;
    end
end

always @(posedge cpu_clk or negedge rstb)begin
    if(rstb==0)begin
            A_temp_wr <= 0;
    end else begin
        if (A_wr_start!=1'b0 && wen_cnt==14'b0 && wr_pulse==1'b0 && A_wr_keep==1'b0 )begin//wr
            A_temp_wr <= A_wr_start;
        end else if (wr_pulse && ready==1)begin//wr 
            A_temp_wr <= A_temp_wr + 8;
        end
    end
end

//keep address (start from last rd address)
always @(posedge cpu_clk or negedge rstb)begin
    if(rstb==0)begin
        A_rd_keep <= 0;
    end else if (sync_sram_rd_start_ff3 ==1) begin
        A_rd_keep <= 1;
    end
end

always @(posedge cpu_clk or negedge rstb)begin
    if(rstb==0)begin
            A_temp_rd <= 0;
    end else begin
        if (A_rd_start!=1'b0 && wen_cnt==14'b0 && rd_pulse==1'b0 && A_rd_keep==1'b0 )begin//rd
            A_temp_rd <= A_rd_start;
        end else if (rd_pulse_B==1'b1 && ready==1)begin//rd
            A_temp_rd <= A_temp_rd + 8;
        end
    end
end

assign A = (wr_pulse) ? A_temp_wr : 
           (rd_pulse) ? A_temp_rd   : 20'h0; 
////////////////////////////////////////////////D///////////////////////////////////////////
//assign D = (sync_wr_8byte_done_ff2 & CEN==0) ? wdata : 0;
assign D = wr_pulse ? wdata : 0;
//assign rdata_cpu_sram = sync_sram_rd_start_ff2  ? Q : 0;

////////////////////////////////////////////////Q///////////////////////////////////////////
//this is for sram spec.
//  Q is delay 1t from cs_n
always @(posedge cpu_clk or negedge rstb)begin
    if(rstb==0)
         rd_pulse_C <=0;
    else
         rd_pulse_C <= rd_pulse_B ;
end


always @(posedge cpu_clk or negedge rstb)begin
    if(rstb==0)begin
            rdata_cpu_sram  <= 0;
    end else begin
        if (rd_pulse_C == 1)
            rdata_cpu_sram  <= Q;
    end
end


endmodule
