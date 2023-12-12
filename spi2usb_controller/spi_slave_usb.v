`timescale 1 ps/1 ps

module spi_slave_usb
  ( input             spiclk,   // spi_clk(from pc) 
    input             CS,
    input             SI,   // SPI slave in
    output            SO,   // SPI slave out
    input             rst,  // assign rst_spi = reset_spi & ~CS;
    //for status_read -> consider CDC
    output reg [7:0]  status3_pullup, //vendor_cmd_wr flag set by HW
    input [7:0]       status_reg3,
    input [7:0]       status3_clr_tog,
    //vendor cmd
    output reg [7:0] vendor_cmd_buf0, // no need CDC 
    output reg [7:0] vendor_cmd_buf1, // no need CDC 
    output reg [7:0] vendor_cmd_buf2, // no need CDC 
    output reg [7:0] vendor_cmd_buf3, // no need CDC 
    output reg [7:0] vendor_cmd_buf4, // no need CDC 
    output reg [7:0] vendor_cmd_buf5, // no need CDC 
    output reg [7:0] vendor_cmd_buf6, // no need CDC 
    output reg [7:0] vendor_cmd_buf7, // no need CDC 
    output reg [7:0] vendor_cmd_buf8, // no need CDC 
    output reg [7:0] vendor_cmd_buf9, // no need CDC 
    output reg [7:0] vendor_cmd_buf10, // no need CDC 
    output reg [7:0] vendor_cmd_buf11, // no need CDC 
    output reg [7:0] vendor_cmd_buf12, // no need CDC 
    
    //for SRAM read or write -> consider CDC
    output [63:0] wdata,// 8 bytes wdata 
    output sram_wr_start, // flag for CDC to CPU domain
    output reg wr_8byte_done,
    input [63:0] rdata, //rdata from sram_out(Q)
    output sram_rd_start,
    output reg rd_8byte_done, // sram read_data(Q) will update into rdata_temp, give max 8 t time for cdc
    //regif
    input [7:0] reg_status0,
    input [7:0] reg_status1,
    input [7:0] reg_status2


    );

parameter cnt_bit = 16; // MAX: 16K -> 14bit
parameter cnt_byte = 13; // 2K byte -> 11bit
/////////////////////////SI   
reg [7:0] SI_shift; // 8bits mosi_shift
reg [7:0] SI_buf;
/////////////////////////SO
reg SO_o1; //(SO_o1,SO_buf) = (SO_buf, SO_buf[7])
reg [7:0] SO_buf;

////////////////////////count
reg [cnt_bit :0] Bit;// count form spiclk starting end by spiclk neding
reg [cnt_bit :0] SI_bit_cnt;//for byte count
reg [cnt_byte:0] SI_byte_cnt;// 13 + 1 bytes

/////////////////////state
reg [2:0]state;// 6 state
reg [2:0]state_next; 
localparam IDLE                 =3'b000;    
localparam READ_CMD             =3'b001; 
localparam STATUS_READ          =3'b010; 
localparam VENDOR_CMD_WRITE     =3'b011;
localparam DATA_WRITE           =3'b100;
localparam DATA_READ            =3'b101;

reg byte_done; // 1byte_done flag
//reg [4:0] fsm_byte_cnt;
reg [7:0] cmd_bus;// =1st SI_buf -> distinguish cmd
reg tran_end;
reg err_cmd;
/////////////////STATUS_READ reg
wire status_rd_mode;
reg [63:0] data; // reg for rd/wr 
////////////////VENDOR_CMD_WRITE reg
wire vendor_wr_mode;

/////////////////////////DATA_WRITE
reg [15:0] data_len; // wr/rd how many byte 
reg [cnt_byte:0]total_data_bytelen;//total byte: 1 + 2 + data_len
reg [2:0]sram_data_8bit_cnt;// count 8 bit for wr/rd data
reg [2:0]sram_data_8byte_cnt;// count 8 byte for wr/rd data
reg sram_8byte_done;
/////////////////////////DATA READ
reg rd_byte_done;
reg [63:0]data_temp;
reg rd_cmd_end;
// SO transition 
assign SO =( (CS==0) && (status_rd_mode==1 || sram_rd_start==1) )? SO_o1 : 1'b0;

/////////////////////////////////////////////////////
//                                                 //
//    mosi go into mosi_shift from LSB             //
//                                                 //
/////////////////////////////////////////////////////
always @(posedge spiclk or negedge rst)begin
    if (~rst)begin
        SI_shift <= 8'b0;
    end else begin
            if(CS)
                    SI_shift <= 8'b0;
            else 
                    SI_shift <= {SI_shift[6:0],SI};
        end
end

/////////////////////Bit & SI bit count & byte count
always @(posedge spiclk or negedge rst)begin
    if (~rst)begin
         SI_bit_cnt  <= 0;
         SI_byte_cnt <= 0;
         SI_buf <=0;
    end else if (CS ==0 )begin
        if (SI_bit_cnt==7)begin
            SI_bit_cnt <= 0;
            if (tran_end==1 || err_cmd==1)begin
                SI_byte_cnt <= 0;
            end else begin
                SI_byte_cnt <= SI_byte_cnt+1;
                SI_buf <=  {SI_shift[6:0],SI}; //SI_buf change every 8T
            end
        end else begin
            SI_bit_cnt <= SI_bit_cnt+1;
        end
    end
end
//Bit start from spi_clk till spi_clk end
always @(posedge spiclk or negedge rst)begin
    if (~rst)
        Bit <= 0;
    else if (tran_end==1 || err_cmd==1)//1+2+len bit
        Bit <= 0;
    else if (CS==0)
        Bit <= Bit +1;
end

//////////////////// 1st byte SI_buf is cmd_bus
always @(posedge spiclk or negedge rst)begin
    if (~rst)begin
        cmd_bus <= 8'hff; 
    end else if (Bit == 0)begin //7th input
            cmd_bus <= 8'hff; // except 8'h00, 8'h10, 8'h20, 8'h30
    end else if (Bit == 7 )begin //7th input
            cmd_bus <= {SI_shift[6:0],SI};
    end
end


///////////////////fsm_count & state logic
always @(posedge spiclk or negedge rst)begin
    if (~rst)begin
        state <= IDLE;
    end else begin
        state <= state_next;
    end
end

///////////////////////////////////////FSM
always @(*)begin //combinatoinal -> watch out LATCHHHHHHHHH
tran_end =0;
err_cmd =0;
    case(state)
        IDLE:begin
                        if (CS==0)begin
                state_next = READ_CMD;
            end
            else begin
                state_next = IDLE;
            end
        end
                READ_CMD:begin
                        if(Bit==7 && ~SI_shift[3:1]==3'b0)begin
                            err_cmd = 1;
                        end
                        if(Bit==8)begin
                            case(cmd_bus) // 1st SI_buf
                                8'h00:begin 
                                            state_next = STATUS_READ; 
                                            end
                                8'h10:begin 
                                            state_next = VENDOR_CMD_WRITE; 
                                            end
                                8'h20:begin 
                                            state_next = DATA_WRITE; 
                                            end
                                8'h30:begin 
                                            state_next = DATA_READ; 
                                            end
                                default:begin
                                        state_next = IDLE;
                                        end
                            endcase
                        end
                        else begin
                            state_next = READ_CMD;
                        end
        end      
                STATUS_READ:begin
                        if(Bit==15'h27)begin// 1 cmd+ 4 statue_rd
                state_next = IDLE;
                tran_end = 1;
            end else begin               
                state_next = STATUS_READ;
            end
        end
                VENDOR_CMD_WRITE:begin
                        if(Bit==15'h6f)begin //13 cmd_wr
                state_next = IDLE;
                tran_end = 1;
                        end else begin
                state_next = VENDOR_CMD_WRITE;
            end
        end
                DATA_WRITE:begin  
                        if(SI_byte_cnt == total_data_bytelen && SI_bit_cnt ==7)begin//total = 1 read cmd + 1 H_len + 1 L_len + ?? datalen
                state_next = IDLE;
                tran_end = 1;
            end else begin
                state_next = DATA_WRITE;
            end
        end
        DATA_READ:begin  
                        if(SI_byte_cnt == total_data_bytelen && SI_bit_cnt ==7)begin//total = 1 read cmd + 1 H_len + 1 L_len + ?? datalen
                state_next = IDLE;
                tran_end = 1;
            end else begin 
                state_next = DATA_READ;
            end
        end
        default:begin
                state_next = IDLE;
              end

    endcase
end

////////////////////////mode flag control////////////////////

assign status_rd_mode = (CS==0 && cmd_bus == 8'h00 )? 1'b1 : 1'b0;
assign vendor_wr_mode = (CS==0 && cmd_bus == 8'h10 )? 1'b1 : 1'b0;
assign sram_wr_start = (CS==0 && cmd_bus == 8'h20 )? 1'b1 : 1'b0;
assign sram_rd_start = (CS==0 && cmd_bus == 8'h30 )? 1'b1 : 1'b0; // if READ-READ: Bit ==0, sram_rd_start wiil be 1; -> fail

/////////////////////////////////////////////////////
//                                                 //
//   function trigger action                       //
//                                                 //
/////////////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////////STATUS_READ///////////////////////
/////////////////////////////////////////////////////

always @(negedge spiclk or negedge rst)begin ////to match spi protocol -> SO is @negedge
   if (~rst)begin
        SO_o1 <= 0;
   end else begin
        if (status_rd_mode==1 || (sram_rd_start==1 && SI_byte_cnt>2) ) // for STATUS_READ & DATA_READ
           SO_o1 <= SO_buf[7-SI_bit_cnt];//reverse
        else
           SO_o1 <= 0;
   end
end

// status3 pullup level trigger
always @(posedge spiclk or negedge rst)begin 
   if (~rst)begin
        status3_pullup <= 1'b0;
   end else if (vendor_wr_mode==1'b1 && SI_byte_cnt<2)begin
        status3_pullup[0] <= 1'b1;
   end else if (sram_wr_start==1'b1 && SI_byte_cnt<2)begin
        status3_pullup[2] <= 1'b1;
   end else if (sram_rd_start==1'b1 && SI_byte_cnt<2)begin
        status3_pullup[1] <= 1'b1;
   /*end else if (status3_clr_tog[0]==1'b1)begin
         status3_pullup[0] <= 1'b0;
   end else if (status3_clr_tog[1]==1'b1)begin
         status3_pullup[1] <= 1'b0;      
   end else if (status3_clr_tog[2]==1'b1)begin
         status3_pullup[2] <= 1'b0; */
   end else begin
        status3_pullup <= 1'b0;
   end
end
/////////////////////////////////////////////////////
////////////////VENDOR_CMD_WRITE///////////////
/////////////////////////////////////////////////////
//need CDC~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

always @(posedge spiclk or negedge rst)begin
    if (~rst)begin
         byte_done <=0;
    end else begin
            if (SI_bit_cnt ==6)begin
                byte_done <=1;
            end else begin
                byte_done <=0;
            end
    end
end

always @(posedge spiclk or negedge rst)begin
    if (~rst)begin
        vendor_cmd_buf0 <= 8'hf3;
        vendor_cmd_buf1 <= 8'hf4;
        vendor_cmd_buf2 <= 8'hf5;
        vendor_cmd_buf3 <= 8'hf6;
        vendor_cmd_buf4 <= 8'hf7;
        vendor_cmd_buf5 <= 8'hf8;
        vendor_cmd_buf6 <= 8'hf9;
        vendor_cmd_buf7 <= 8'hfa;
        vendor_cmd_buf8 <= 8'hfb;
        vendor_cmd_buf9 <= 8'hfc;
        vendor_cmd_buf10<= 8'hfd;
        vendor_cmd_buf11<= 8'hfe;
        vendor_cmd_buf12<= 8'hff;
    end else if (vendor_wr_mode==1)begin
        case(SI_byte_cnt[3:0])
            4'b0010: begin
                        vendor_cmd_buf0 <= SI_buf;//2
                     end
            4'b0011: vendor_cmd_buf1 <= SI_buf;
            4'b0100: vendor_cmd_buf2 <= SI_buf;
            4'b0101: vendor_cmd_buf3 <= SI_buf;
            4'b0110: vendor_cmd_buf4 <= SI_buf;
            4'b0111: vendor_cmd_buf5 <= SI_buf;
            4'b1000: vendor_cmd_buf6 <= SI_buf;
            4'b1001: vendor_cmd_buf7 <= SI_buf;
            4'b1010: vendor_cmd_buf8 <= SI_buf;
            4'b1011: vendor_cmd_buf9 <= SI_buf;
            4'b1100: vendor_cmd_buf10 <= SI_buf;
            4'b1101: begin vendor_cmd_buf11 <= SI_buf;//13
                        if (SI_bit_cnt==7)begin
                            vendor_cmd_buf12 <= {SI_shift[6:0],SI};//14
                        end
                     end
        endcase
    end 
end

/////////////////////////////////////////////////////
////////////////DATA_WRITE & DATA_READ///////////////
/////////////////////////////////////////////////////

//first 2 byte -> len, unit: byte
always @(posedge spiclk or negedge rst)begin
    if (~rst)begin
        data_len <= 16'h0003; //at least 3 //avoid SI_byte_cnt == tottal_data_len

    end else if (sram_wr_start==1 || sram_rd_start==1)begin    
        if (SI_byte_cnt==2)
            data_len[15:8] <= SI_buf;
        else if (SI_byte_cnt==3)
            data_len[7:0] <= SI_buf;
    end
end


//total_data_bytelen, unit:byte
always @(posedge spiclk or negedge rst)begin
    if (~rst)begin
        total_data_bytelen <= 0; // give an initial value 
    end else if (sram_wr_start==1 ||  sram_rd_start==1)begin
        if (SI_byte_cnt < 3)
            total_data_bytelen <= data_len  + 3;//avoid when SI_byte_cnt ==2, total_data_bytelen = SI_byte_cnt -> tran_end =1
        else
            total_data_bytelen <= data_len  + 2;//1 cmd+2 len
    end
end

//transmit data count
always @(posedge spiclk or negedge rst)begin //count from wdata begin
    if (~rst)begin
        sram_data_8bit_cnt <= 0;
        sram_data_8byte_cnt <= 0;
        sram_8byte_done <= 0;
    end 
    else if (sram_wr_start==1 || sram_rd_start==1)begin  
        if (SI_byte_cnt >=3 ) begin
            sram_data_8bit_cnt <= sram_data_8bit_cnt +1;
            sram_8byte_done <= 0;
            if (sram_data_8bit_cnt ==7)begin
                sram_data_8bit_cnt <=0;
                sram_data_8byte_cnt <= sram_data_8byte_cnt+1;
                if(sram_data_8byte_cnt==7)begin
                    sram_data_8byte_cnt <= 0;
                    sram_8byte_done <= 1;
                end
            end
        end    
    end
end
/////////control read/write cmd finish flag//////////////////
//like status3 reg -> level trigger, FW will clear
/*always @(posedge spiclk or negedge rst)begin
    if (~rst)
        rd_cmd_end <= 0;
    else if (status_reg3[1]==1'b0)
        rd_cmd_end <= 0;
    else if (SI_bit_cnt==7 && SI_byte_cnt==total_data_bytelen)
        rd_cmd_end <= 1;
end*/
////////////////DATA_WRITE///////////////
//nno need CDC cus data change every 64(8*8)t
//wrdata start from 3rd byte

//wdata SI_buf need to change to wr_buf[nu_wrbuf] to pass CDC

always @(posedge spiclk or negedge rst)begin
    if (~rst)begin
        wr_8byte_done <= 0;
    end 
    else if(sram_wr_start==1 && SI_byte_cnt > 4 && ((sram_data_8byte_cnt==7 && sram_data_8bit_cnt > 6) || (sram_data_8byte_cnt==0 && sram_data_8bit_cnt < 2)) )begin// 3rd condition  is for CDC (signal > 1.5) when cpu_clk = 25MHz, extened wr_8byte_done=1.
        wr_8byte_done <= 1;//finish 1 byte wdata
    end 
    else begin
        wr_8byte_done <= 0;
    end
end

////////////////DATA_READ///////////////
// for rdata CDC
// flag for byte done begin from SI_byte_cnt =2 -> give 8t for CDC, if want
// more t to CDC -> minus SI_byte_cnt for rd_byte_done & add 1 data_temp1
// data_temp <= rdata; data_temp1 <= data_temp;
always @(posedge spiclk or negedge rst)begin
    if (~rst)begin
        rd_byte_done <= 0;
        rd_8byte_done <= 0;
    end else if (sram_rd_start==1 && SI_byte_cnt >= 2)begin //can change for CDC
            if (SI_bit_cnt ==6)begin
                rd_byte_done <=1; // tell cpu to change rdata -> rdata will givvve to data_temp to store
            end 
            else if (sram_rd_start==1 && sram_data_8byte_cnt==6 && sram_data_8bit_cnt<2 && SI_byte_cnt < data_len)begin //ahead change rdata //sram_data_8bit_cnt<2 is for CDC (signal > 1.5)
                rd_8byte_done <= 1;
            end
            else begin
                rd_byte_done <=0;
                rd_8byte_done <= 0;
            end
    end
end

//////////////////data/////////////////////////
always @(posedge spiclk or negedge rst)begin
    if (~rst)begin
        data <= 0;
        data_temp <= 0;
        SO_buf <=0;
    end else if (sram_wr_start==1 && SI_byte_cnt >=3 && SI_bit_cnt==7)begin //data_write // start from 3rd byte 
            //data <= { {data[55:0]} , {SI_shift[6:0]}, SI};
            data <= { {SI_shift[6:0]}, SI, {data[63:8]} };
    //status_read
    //prepare reg_status0
    end else if (Bit==7)begin
            SO_buf <= reg_status0; //SO wiil depend on status
    end else if (status_rd_mode==1 && byte_done)begin
         case(SI_byte_cnt[2:0]) ////SO_buf depends on byte count
             3'b001: SO_buf <= reg_status1;
             3'b010: SO_buf <= reg_status2;
             3'b011: SO_buf <= status_reg3;
             default: SO_buf <= 0;
         endcase
    //data_read
    end else if (sram_rd_start==1)begin//data_read
        if ( (SI_byte_cnt == 2 && SI_bit_cnt ==6) || (sram_data_8byte_cnt==7 && sram_data_8bit_cnt==6 ) )begin////pre-prepare start data for SI_byte_cnt =1  && every 8 byte data        
            data_temp <= rdata;
        end
        else if (SI_byte_cnt >= 2 && rd_byte_done==1 )begin
            //SO_buf <= data_temp[63:56];
            //data_temp <= data_temp << 8;
            SO_buf <= data_temp[8:0];
            data_temp <= data_temp >> 8;
        end
    end

end


assign wdata = data;


endmodule

