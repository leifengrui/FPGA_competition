`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/02 20:29:39
// Design Name: 
// Module Name: Top_Project
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Top_Project
(
    //sys port
    input   wire            sys_clk,   //200MHz
    input   wire            sys_rst_n,
    input   wire   [23:0]   RGB_data,
    input   wire            hs,
    input   wire            vs,
    input   wire            de, 
    input   wire            RGB_clkn,//148.5MHz
    output  wire            ws,
    output  wire            ws_B

);
//clk and resetn
wire RGB_clk;
wire resetn;

//algorithm_down
wire        dv_algorithm_down;
wire [23:0] RGB_algorithm_down;
//algorithm_left
wire        dv_algorithm_left;
wire [23:0] RGB_algorithm_left;

// Left_Down_FIFO_control 
wire [23:0] RGB_data_down_out;
wire [23:0] RGB_data_left_out;
wire rd_en_Left_FIFO;
wire rd_en_Down_FIFO;

// RGB_control_Top;
wire [23:0] RGB_data_RGB_control_Top;
wire flag_RGB_data;
wire dv_Send_24Bit;



assign RGB_clk = ~RGB_clkn;
assign resetn = sys_rst_n ;
algorithm_down  u_algorithm_down 
(
    .clkn                    ( RGB_clkn                         ),
    .resetn                  ( resetn                           ),
    .hs                      ( hs                               ),
    .vs                      ( vs                               ),
    .de                      ( de                               ),
    .RGB_data                ( RGB_data                 ),
    .cl_RGB_hor_down_out     ( dv_algorithm_down                ),
    .RGB_hor_up_out          ( RGB_algorithm_down       [23:0]  )
);
// Down_FIFO Down_FIFO_u (
//   .srst(~sys_rst_n),                // input wire srst
//   .wr_clk(RGB_clk),            // input wire wr_clk

//   .rd_clk(sys_clk),            // input wire rd_clk

//   .din(RGB_algorithm_down),                  // input wire [23 : 0] din
//   .wr_en(dv_algorithm_down),              // input wire wr_en

//   .rd_en(rd_en_Down_FIFO),              // input wire rd_en
//   .dout(RGB_data_down_out),                // output wire [23 : 0] dout

//   .full(full_Down_FIFO),                // output wire full
//   .empty(empty_Down_FIFO)              // output wire empty

// //   .wr_rst_busy(wr_rst_busy_Down_FIFO),  // output wire wr_rst_busy
// //   .rd_rst_busy(rd_rst_busy_Down_FIFO)  // output wire rd_rst_busy
// );
Down_FIFO Down_FIFO_u (
  .wr_data(RGB_algorithm_down),              // input [23:0]
  .wr_en(dv_algorithm_down),                  // input
  .wr_clk(RGB_clk),                // input
  .full(full_Down_FIFO),                    // output
  .wr_rst(~sys_rst_n),                // input
//   .almost_full(almost_full),      // output
  .rd_data(RGB_data_down_out),              // output [23:0]
  .rd_en(rd_en_Down_FIFO),                  // input
  .rd_clk(sys_clk),                // input
  .empty(empty_Down_FIFO),                  // output
  .rd_rst(~sys_rst_n)               // input
//   .almost_empty(almost_empty)     // output
);

//左边框

algorithm_left u_algorithm_left
(
    .clkn                    ( RGB_clkn                      ),
    .resetn                  ( resetn                    ),
    .hs                      ( hs                        ),
    .vs                      ( vs                        ),
    .de                      ( de                        ),
    .RGB_data                ( RGB_data          ),

    .dv_RGB_hor_up_out       ( dv_algorithm_left            ),
    .RGB_hor_up_out          ( RGB_algorithm_left     [23:0] )
);

// Left_FIFO Left_FIFO_u 
// (
//   .srst(~sys_rst_n),                // input wire srst
//   .wr_clk(RGB_clk),                 // input wire wr_clk
//   .rd_clk(sys_clk),                 // input wire rd_clk

//   .din(RGB_algorithm_left),         // input wire [23 : 0] din
//   .wr_en(dv_algorithm_left),        // input wire wr_en

//   .rd_en(rd_en_Left_FIFO),          // input wire rd_en
//   .dout(RGB_data_left_out),         // output wire [23 : 0] dout

//   .full(full_Left_FIFO),                // output wire full
//   .empty(empty_Left_FIFO)              // output wire empty
// //   .wr_rst_busy(wr_rst_busy_Left_FIFO),  // output wire wr_rst_busy
// //   .rd_rst_busy(rd_rst_busy_Left_FIFO)  // output wire rd_rst_busy
// );

Left_FIFO Left_FIFO_u (
  .wr_data(RGB_algorithm_left),              // input [23:0]
  .wr_en(dv_algorithm_left),                  // input
  .wr_clk(RGB_clk),                // input
  .full(full_Left_FIFO),                    // output
  .wr_rst(~sys_rst_n),                // input
//   .almost_full(almost_full),      // output
  .rd_data(RGB_data_left_out),              // output [23:0]
  .rd_en(rd_en_Left_FIFO),                  // input
  .rd_clk(sys_clk),                // input
  .empty(empty_Left_FIFO),                  // output
  .rd_rst(~sys_rst_n)               // input
//   .almost_empty(almost_empty)     // output
);



Left_Down_FIFO_control  u_Left_Down_FIFO_control 
(
    .clk_200MHz              ( sys_clk                ),
    .clk_HDMI_n              ( RGB_clkn                ),
    .resetn                  ( resetn                    ),
    .hs                      ( hs                        ),
    .empty_left              ( empty_Left_FIFO           ),
    .empty_down              ( empty_Down_FIFO           ),
    .de                      ( de                        ),
    .RGB_data_down_out       ( RGB_data_down_out  [23:0] ),
    .RGB_data_left_out       ( RGB_data_left_out  [23:0] ),
    .dv                      ( dv_Send_24Bit             ),
    .vs                      ( vs                        ),
    .rd_en_Left_FIFO         ( rd_en_Left_FIFO           ),
    .rd_en_Down_FIFO         ( rd_en_Down_FIFO           ),
    .RGB_data                ( RGB_data_RGB_control_Top [23:0] ),
    .valid_RGB_data          ( valid_RGB_data            ),
    .flag_RGB_data           ( flag_RGB_data             )
);


RGB_control_Top  u_RGB_control_Top_A 
(
    .clk_200                 ( sys_clk               ),
    .restn                   ( sys_rst_n                 ),
    .RGB_data                ( RGB_data_RGB_control_Top       [23:0] ),
    .RGB_valid               ( flag_RGB_data             ),
    .ws                      ( ws                    ),
    .dv_Send_24Bit           ( dv_Send_24Bit         )
    // .lock                    ( lock_RGB_control_Top                  )
);

//Two  RGB dengdai

wire dv_algorithm_up;
wire [23:0] RGB_algorithm_up;

wire dv_algorithm_right;
wire [23:0] RGB_algorithm_right;
wire rd_en_Up_FIFO;
wire rd_en_Right_FIFO;
wire [23:0] RGB_data_right_out;
wire [23:0] RGB_data_up_out;

wire dv_Send_24Bit_B;
wire [23:0] RGB_data_RGB_control_Top_B;
wire flag_RGB_data_B;
wire empty_Right_FIFO;
wire empty_Up_FIFO;


algorithm_up  u_algorithm_up (
    .clkn                    ( RGB_clkn                  ),
    .resetn                  ( resetn                    ),
    .hs                      ( hs                        ),
    .vs                      ( vs                        ),
    .de                      ( de                        ),
    .RGB_data                ( RGB_data           [23:0] ),

    .cl_RGB_hor_up_out       ( dv_algorithm_up           ),
    .RGB_hor_up_out          ( RGB_algorithm_up     [23:0] )
);

// Up_FIFO Up_FIFO_u (
//   .srst(~sys_rst_n),                // input wire srst
//   .wr_clk(RGB_clk),            // input wire wr_clk

//   .rd_clk(sys_clk),            // input wire rd_clk

//   .din(RGB_algorithm_up),                  // input wire [23 : 0] din
//   .wr_en(dv_algorithm_up),              // input wire wr_en

//   .rd_en(rd_en_Up_FIFO),              // input wire rd_en
//   .dout(RGB_data_up_out),                // output wire [23 : 0] dout

//   .full(full_Up_FIFO),                // output wire full
//   .empty(empty_Up_FIFO)              // output wire empty

// //   .wr_rst_busy(wr_rst_busy_Down_FIFO),  // output wire wr_rst_busy
// //   .rd_rst_busy(rd_rst_busy_Down_FIFO)  // output wire rd_rst_busy
// );

Up_FIFO Up_FIFO_u (
  .wr_data(RGB_algorithm_up),              // input [23:0]
  .wr_en(dv_algorithm_up),                  // input
  .wr_clk(RGB_clk),                // input
  .full(full_Up_FIFO),                    // output
  .wr_rst(~sys_rst_n),                // input
//   .almost_full(almost_full),      // output
  .rd_data(RGB_data_up_out),              // output [23:0]
  .rd_en(rd_en_Up_FIFO),                  // input
  .rd_clk(sys_clk),                // input
  .empty(empty_Up_FIFO),                  // output
  .rd_rst(~sys_rst_n)                // input
//   .almost_empty(almost_empty)     // output
);










algorithm_right  u_algorithm_right (
    .clkn                    ( RGB_clkn                      ),
    .resetn                  ( resetn                    ),
    .hs                      ( hs                        ),
    .vs                      ( vs                        ),
    .de                      ( de                        ),
    .RGB_data                ( RGB_data           [23:0] ),

    .dv_RGB_hor_up_out       ( dv_algorithm_right         ),
    .RGB_hor_up_out          ( RGB_algorithm_right    [23:0] )
);

// Right_FIFO Right_FIFO_u 
// (
//   .srst(~sys_rst_n),                // input wire srst
//   .wr_clk(RGB_clk),                 // input wire wr_clk
//   .rd_clk(sys_clk),                 // input wire rd_clk

//   .din(RGB_algorithm_right),         // input wire [23 : 0] din
//   .wr_en(dv_algorithm_right),        // input wire wr_en

//   .rd_en(rd_en_Right_FIFO),          // input wire rd_en
//   .dout(RGB_data_right_out),         // output wire [23 : 0] dout

//   .full(full_Right_FIFO),                // output wire full
//   .empty(empty_Right_FIFO)              // output wire empty
// //   .wr_rst_busy(wr_rst_busy_Left_FIFO),  // output wire wr_rst_busy
// //   .rd_rst_busy(rd_rst_busy_Left_FIFO)  // output wire rd_rst_busy
// );
Right_FIFO Right_FIFO_u (
  .wr_data(RGB_algorithm_right),              // input [23:0]
  .wr_en(dv_algorithm_right),                  // input
  .wr_clk(RGB_clk),                // input
  .full(full_Right_FIFO),                    // output
  .wr_rst(~sys_rst_n),                // input
//   .almost_full(almost_full),      // output
  .rd_data(RGB_data_right_out),              // output [23:0]
  .rd_en(rd_en_Right_FIFO),                  // input
  .rd_clk(sys_clk),                // input
  .empty(empty_Right_FIFO),                  // output
  .rd_rst(~sys_rst_n)                // input
//   .almost_empty(almost_empty)     // output
);





Right_Up_FIFO_control  u_Right_Up_FIFO_control_B
(
    .clk_200MHz              ( sys_clk                ),
    .clk_HDMI_n              ( RGB_clkn                ),
    .resetn                  ( resetn                    ),
    .hs                      ( hs                        ),
    .empty_left              ( empty_Right_FIFO           ),
    .empty_down              ( empty_Up_FIFO           ),
    .de                      ( de                        ),
    .RGB_data_up_out       ( RGB_data_up_out  [23:0] ),
    .RGB_data_right_out       ( RGB_data_right_out  [23:0] ),
    .dv                      ( dv_Send_24Bit_B             ),
    .vs                      ( vs                        ),
    .rd_en_Right_FIFO         ( rd_en_Right_FIFO           ),
    .rd_en_Up_FIFO         ( rd_en_Up_FIFO           ),
    .RGB_data                ( RGB_data_RGB_control_Top_B [23:0] ),
    .valid_RGB_data          ( valid_RGB_data_B            ),
    .flag_RGB_data           ( flag_RGB_data_B             )
);



RGB_control_Top  u_RGB_control_Top_B 
(
    .clk_200                 ( sys_clk               ),
    .restn                   ( sys_rst_n                 ),
    .RGB_data                ( RGB_data_RGB_control_Top_B       [23:0] ),
    .RGB_valid               ( flag_RGB_data_B             ),
    .ws                      ( ws_B                    ),
    .dv_Send_24Bit           ( dv_Send_24Bit_B         )
    // .lock                    ( lock_RGB_control_Top                  )
);



endmodule
