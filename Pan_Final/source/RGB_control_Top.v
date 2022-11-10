`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/06 00:05:32
// Design Name: 
// Module Name: RGB_TOP
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


module RGB_control_Top

(
input   wire                     clk_200,           //system clock positive 200MHz
input   wire                     restn,
input   wire        [23:0]       RGB_data,
input   wire                     RGB_valid,
output  reg                      ws,
output  wire                     dv_Send_24Bit
// output  wire                     lock
);
localparam IDLE     =   4'b0001;
// localparam INIT     =   4'b0010;
localparam SEND     =   4'b0100;
localparam WAIT     =   4'b1000;
reg [3:0]    current_state;
reg [3:0]    next_state;
reg [7:0] count;

reg en_Send_24Bit           ;
reg restn_Send_24Bit        ;
// reg en_WS2812B_initialize   ;
// reg restn_WS2812B_initialize;

// wire dv_WS2812B_initialize;
// assign dv_WS2812B_initialize = 1;

// assign lock = 1;
//FSM
always @(posedge clk_200 or negedge restn) 
begin
    if(~restn)
    begin
        current_state <= IDLE;
    end
    else
    begin
        current_state <= next_state;
    end
end
always @(*) begin
    if(~restn)
    begin
        next_state = IDLE;
    end
    else
    begin
        case (current_state)
        IDLE:
        begin
            next_state = WAIT;
        end
        SEND:
        begin
            if(RGB_valid)
            begin
                next_state = SEND;
            end
            else
            begin
                if(dv_Send_24Bit)
                begin
                    next_state = WAIT;
                end
                else
                begin
                    next_state = SEND;
                end
            end
        end
        // INIT:
        // begin
        //     if(dv_WS2812B_initialize)
        //     begin
        //         next_state = WAIT;
        //     end
        //     else
        //     begin
        //     next_state = INIT;
        //     end
        // end
        WAIT:
        begin
            if(RGB_valid)
            begin
                next_state = SEND;
            end
            else
            begin
                //此处不对
                next_state = WAIT;
                
            end
        end
        default :
        begin
            next_state = IDLE;
        end            
        endcase
    end    
end

always @(*) begin
 case (current_state)
        IDLE:
        begin
            en_Send_24Bit           = 'd0;
            restn_Send_24Bit        = 'd0;
            // en_WS2812B_initialize   = 'd0;
            // restn_WS2812B_initialize= 'd0;
            ws                      = 'd0;           

        end
        SEND:
        begin
            en_Send_24Bit           = 1'b1;

            // en_WS2812B_initialize   = 1'b0;
            // restn_WS2812B_initialize= 1'b1;
            ws                      = ws_Send_24Bit;
            restn_Send_24Bit        = 1'b1;
        end
        // INIT:
        // begin
        //     en_Send_24Bit           = 1'b0;
        //     restn_Send_24Bit        = 1'b0;
        //     // en_WS2812B_initialize   = 1'b1;
        //     // restn_WS2812B_initialize= 1'b1;
        //     ws                      = 0;

        // end
        WAIT:
        begin
            en_Send_24Bit           = 'd0;
            restn_Send_24Bit        = 'd0;
            // en_WS2812B_initialize   = 'd0;
            // restn_WS2812B_initialize= 1'b1;
            ws                      = 'd0;
        end
        default:
        begin
            en_Send_24Bit           = 'd0;
            restn_Send_24Bit        = 'd0;
            // en_WS2812B_initialize   = 'd0;
            // restn_WS2812B_initialize= 'd0;
            ws                      = 'd0;
        end
        endcase 
end

// always @(*) begin
//  case (current_state)
//         IDLE:
//         begin
//             en_Send_24Bit           = 'd0;
//             restn_Send_24Bit        = 'd0;
//             // en_WS2812B_initialize   = 'd0;
//             // restn_WS2812B_initialize= 'd0;
//             ws                      = 'd0;           

//         end
//         SEND:
//         begin
//             en_Send_24Bit           = 1'b1;
//             restn_Send_24Bit        = 1'b1;
//             // en_WS2812B_initialize   = 1'b0;
//             // restn_WS2812B_initialize= 1'b1;
//             ws                      = ws_Send_24Bit;
//         end
//         // INIT:
//         // begin
//         //     en_Send_24Bit           = 1'b0;
//         //     restn_Send_24Bit        = 1'b0;
//         //     // en_WS2812B_initialize   = 1'b1;
//         //     // restn_WS2812B_initialize= 1'b1;
//         //     ws                      = 0;

//         // end
//         WAIT:
//         begin
//             en_Send_24Bit           = 'd0;
//             restn_Send_24Bit        = 'd0;
//             // en_WS2812B_initialize   = 'd0;
//             // restn_WS2812B_initialize= 1'b1;
//             ws                      = 'd0;
//         end
//         default:
//         begin
//             en_Send_24Bit           = 'd0;
//             restn_Send_24Bit        = 'd0;
//             // en_WS2812B_initialize   = 'd0;
//             // restn_WS2812B_initialize= 'd0;
//             ws                      = 'd0;
//         end
//         endcase 
// end



always @(posedge clk_200 or negedge restn) 
begin
    if(~restn)
    begin
        count <= 'd0;
    end
    else
    begin
        if(count < 122)
        begin
            if(dv_Send_24Bit)
                count <= count + 1;
        end
        else
        begin
            if(dv_Send_24Bit)
                count <= 'd0;
        end
    end
end
Send_24Bit  u_Send_24Bit (
    .clk                     ( clk_200              ),
    .restn                   ( restn_Send_24Bit            ),
    .en                      ( en_Send_24Bit               ),
    .RGB_data                ( RGB_data),
    .dv                      ( dv_Send_24Bit            ),
    .ws                      ( ws_Send_24Bit               )
);
// WS2812B_initialize  u_WS2812B_initialize (
//     .clk                     ( clk_200     ),
//     .restn                   ( restn_WS2812B_initialize   ),
//     .en                      ( en_WS2812B_initialize      ),
//     .ws                      ( ws_WS2812B_initialize      ),
//     .dv                      ( dv_WS2812B_initialize      )
// );


endmodule
