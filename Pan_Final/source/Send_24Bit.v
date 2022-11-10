`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/05 23:18:16
// Design Name: 
// Module Name: Send_24Bit
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
module Send_24Bit
(
    input wire clk, // 200MHz
    input wire restn,
    input wire en,
    input wire [23:0] RGB_data,
    output reg dv,
    output wire ws
);
reg     [5:0]   count;
wire    [23:0]  GRB_data;
reg data_RGB_Wave;
assign  GRB_data = {RGB_data[15:8],RGB_data[23:16],RGB_data[7:0]};
wire dv_RGB_Wave;
always @(posedge clk or negedge restn) 
begin
    if(~restn)
    begin
        count <= 'd0;
    end
    else
    begin
        if(count < 23 & en)
        begin
            if(dv_RGB_Wave)
                    count <= count + 1'b1;
        end
        else
        begin
            if(dv_RGB_Wave)
                    count <= 'd0;
        end
    end
end
always @(posedge clk or negedge restn) 
begin
    if(~restn)
    begin
        dv = 'd0;
    end
    else
    begin
        if(en )
        begin
            if(count >= 23 & dv_RGB_Wave) 
            begin
                dv = 1'b1;
            end
            else
            begin
                 dv = 'd0;
            end
        end
        else
        begin
            dv = 'd0;
        end
    end
end

always @(*) begin
    if(~restn)
    begin
        data_RGB_Wave = 0;
    end
    else
    begin
        if(en)
        begin
            case (count)
            0:data_RGB_Wave  = GRB_data[23];
            1:data_RGB_Wave  = GRB_data[22];
            2:data_RGB_Wave  = GRB_data[21];
            3:data_RGB_Wave  = GRB_data[20];
            4:data_RGB_Wave  = GRB_data[19];
            5:data_RGB_Wave  = GRB_data[18];
            6:data_RGB_Wave  = GRB_data[17];
            7:data_RGB_Wave  = GRB_data[16];

            8:data_RGB_Wave  = GRB_data[15];
            9:data_RGB_Wave  = GRB_data[14];
            10:data_RGB_Wave  = GRB_data[13];
            11:data_RGB_Wave  = GRB_data[12];
            12:data_RGB_Wave  = GRB_data[11];
            13:data_RGB_Wave  = GRB_data[10];
            14:data_RGB_Wave  = GRB_data[9];            
            15:data_RGB_Wave  = GRB_data[8];

            
            16:data_RGB_Wave  = GRB_data[7];
            17:data_RGB_Wave  = GRB_data[6];
            18:data_RGB_Wave  = GRB_data[5];
            19:data_RGB_Wave  = GRB_data[4];
            20:data_RGB_Wave  = GRB_data[3];
            21:data_RGB_Wave  = GRB_data[2];
            22:data_RGB_Wave  = GRB_data[1];
            23:data_RGB_Wave  = GRB_data[0]; 
            default:data_RGB_Wave = 0;             
            endcase
        end
        else
        begin
            data_RGB_Wave = 0; 
        end
    end
    
end
RGB_Wave  u_RGB_Wave (
    .clk                     ( clk     ),
    .restn                   ( restn   ),
    .data                    ( data_RGB_Wave    ),
    .ws                      ( ws      ),
    .dv                      ( dv_RGB_Wave      )
); 
endmodule
