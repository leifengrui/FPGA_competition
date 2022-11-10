//////////////////////////////////////////////////////////////////////////////////
//   hdmi color bar test                                                         //
//                                                                              //
//  Author: lhj                                                                 //
//                                                                              //
//          ALINX(shanghai) Technology Co.,Ltd                                  //
//          heijin                                                              //
//     WEB: http://www.alinx.cn/                                                //
//     BBS: http://www.heijin.org/                                              //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
// Copyright (c) 2017,ALINX(shanghai) Technology Co.,Ltd                        //
//                    All rights reserved                                       //
//                                                                              //
// This source file may be used and distributed without restriction provided    //
// that this copyright statement is not removed from the file and that any      //
// derivative work contains the original copyright notice and the associated    //
// disclaimer.                                                                  //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////

//================================================================================
//  Revision History:
//  Date          By            Revision    Change Description
//--------------------------------------------------------------------------------
//2019/08/30                    1.0          Original
//*******************************************************************************/
`timescale 1ns/1ps
module hdmi_loop
(
input                       sys_clk_p,          //system clock positive
input                       sys_clk_n,          //system clock negative 
input                       rst_n,              //reset ,low active
output [1:0]                led,
output                      hdmi_in_nreset,     //9011/9013 reset
input                       vin_clk,            //clock for 9111/9013
input                       vin_hs,             //horizontal synchronization for 9011/9013
input                       vin_vs,             //vertical synchronization for 9011/9013
input                       vin_de,             //data valid for 9011/9013
input [23:0]                 vin_data,           //data for 9011/9013   
inout                       hdmi_scl,           //HDMI I2C clock
inout                       hdmi_sda,           //HDMI I2C data
output                      hdmi_nreset,        //9134 reset
output                      vout_hs,            //horizontal synchronization for 9134
output                      vout_vs,            //vertical synchronization for 9134
output                      vout_de,            //data valid for 9134
output                      vout_clk,           //clock for 9134
output [23:0]                vout_data,           //data for 9134
output ws,
output ws_B
);
wire                       sys_clk;             //single end clock 
wire [9:0]                  lut_index;           //look table index
wire [31:0]                 lut_data;            //look table data 


wire clk_50m;
wire [1:0]led;
wire done;
wire error;
assign led[0] = done;
assign led[1] = error;

reg vin_hs_d0;
reg vin_vs_d0;
reg vin_de_d0;
reg[23:0] vin_data_d0;
reg vin_hs_d1;
reg vin_vs_d1;
reg vin_de_d1;
reg[23:0] vin_data_d1;
reg vin_hs_d2;
reg vin_vs_d2;
reg vin_de_d2;
reg[23:0] vin_data_d2; 

wire sys_rst_n;
// assign sys_rst_n = rst_n

always@(posedge vin_clk or negedge sys_rst_n)
begin
if(~sys_rst_n)begin
    vin_hs_d0 <= 1'd0;
    vin_vs_d0 <= 1'd0;
    vin_de_d0 <= 1'd0;
    vin_data_d0 <= 24'd0;
    vin_hs_d1 <= 1'd0;
    vin_vs_d1 <= 1'd0;
    vin_de_d1 <= 1'd0;
    vin_data_d1 <= 24'd0; 
    
    vin_hs_d2 <= 1'd0;
    vin_vs_d2 <= 1'd0;
    vin_de_d2 <= 1'd0;
    vin_data_d2 <= 24'd0; 
end
else 
begin
    vin_hs_d0 <= vin_hs;
    vin_vs_d0 <= vin_vs;
    vin_de_d0 <= vin_de;
    vin_data_d0 <= vin_data;
    vin_hs_d1 <= vin_hs_d0;
    vin_vs_d1 <= vin_vs_d0;
    vin_de_d1 <= vin_de_d0;
    vin_data_d1 <= vin_data_d0; 
    
    vin_hs_d2 <= vin_hs_d1;
    vin_vs_d2 <= vin_vs_d1;
    vin_de_d2 <= vin_de_d1;
    vin_data_d2 <= vin_data_d1;   
end
end

assign vout_clk = vin_clk;
assign vout_hs = vin_hs_d2;
assign vout_vs = vin_vs_d2;
assign vout_de = vin_de_d2;
assign vout_data = vin_data_d2;
assign hdmi_nreset          = 1'b1;
assign hdmi_in_nreset       = 1'b1;
/*************************************************************************
generate single end clock
**************************************************************************/
GTP_INBUFGDS sys_clk_ibufgds 
(
.I                         (sys_clk_p                ),
.IB                        (sys_clk_n                ),
.O                         (sys_clk                  )
);

sys_reset_n #(
    .FREQ                   (50                       )
    )
sys_reset_n_u0
    (
    .sys_clk                (clk_50m               ),    // input
    .reset_n                (rst_n                    ),   // input
    .sys_reset_n            (sys_rst_n                )   // output
);
/*************************************************************************
Configure the register of 9011 and 9134
****************************************************************************/

sys_pll sys_pll_m0 (
  .clkout0(clk_50m),    // output
  .lock(),          // output
  .clkin1(sys_clk),      // input
  .rst(1'b0)             // input
);

i2c_config i2c_config_m0(
.rst                        (~sys_rst_n                   ),
.clk                        (clk_50m                  ),
.clk_div_cnt                (16'd500                  ),
.i2c_addr_2byte             (1'b0                     ),
.lut_index                  (lut_index                ),
.lut_dev_addr               (lut_data[31:24]          ),
.lut_reg_addr               (lut_data[23:8]           ),
.lut_reg_data               (lut_data[7:0]            ),
.error                      (error                    ),
.done                       (done                     ),
.i2c_scl                    (hdmi_scl                 ),
.i2c_sda                    (hdmi_sda                 )
);
//configure look-up table
lut_hdmi lut_hdmi_m0(
.lut_index                  (lut_index                ),
.lut_data                   (lut_data                 )
);










//RGB
Top_Project  u_Top_Project (
    .sys_clk                 ( sys_clk          ),
    .sys_rst_n               ( sys_rst_n           ),
    .RGB_data                ( vout_data         ),
    .hs                      ( vout_hs                ),
    .vs                      ( vout_vs                ),
    .de                      ( vout_de                ),
    .RGB_clkn                 ( vout_clk         ),
    .ws                      ( ws                ),
    .ws_B                   (ws_B)
);





endmodule 