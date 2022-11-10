`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/26 18:45:05
// Design Name: 
// Module Name: Left_Down_FIFO_control
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


module Left_Down_FIFO_control
(
    input wire clk_200MHz,
    input wire clk_HDMI_n,
    input wire resetn,
    input wire  hs,
    output wire vs,
    input  wire  empty_left,
    input  wire  empty_down,
    input  wire  de,

    input wire [23:0]   RGB_data_down_out,
    input wire [23:0]   RGB_data_left_out,
    input  wire         dv,
    output reg         rd_en_Left_FIFO,
    output reg         rd_en_Down_FIFO,
    output reg [23:0]  RGB_data,
    output reg         valid_RGB_data,
    output wire         flag_RGB_data
);

reg [12:0] count_hs;
reg start_flag;//标志有数据来
// reg flag_hs;
reg [15:0] count_30us;
reg [7:0] count_RGB;
reg     start_out_RGB;

assign flag_RGB_data = start_out_RGB;

always @(negedge clk_HDMI_n or negedge resetn) 
begin
    if(~resetn)
    begin
        start_flag <= 'd0;
    end    
    else
    begin
        if(vs)
        begin
            start_flag <= 'd0;
        end
        else
        begin
            if(de   & ~hs)
            begin
                start_flag <= 1 'b1;
            end
        end
    end
end

// always @(negedge clk_HDMI_n or negedge resetn) 
// begin
//     if(~resetn)
//     begin
//         flag_hs <= 'd0;
//     end
//     else
//     begin
//         if( hs &  ~flag_hs)
//         begin
//             flag_hs <=   1'b1;
//         end
//         else
//         begin
//              flag_hs <= 'd0;
//         end
//     end
// end

always @(posedge hs or negedge resetn or posedge vs) 
begin
    if(~resetn)
    begin
        count_hs <= 'd0;
    end
    else
    begin
        if(vs)
        begin
            count_hs <= 'd0;
        end
        else
        begin
            if(hs)
                count_hs <= count_hs + 1'b1;
        end

    end
end

always @(posedge clk_200MHz or negedge resetn) 
begin
    if(~resetn)
    begin
        count_30us <= 'd0;
    end
    else
    begin
        if(count_30us < 6000)
        begin
            count_30us <= count_30us + 1'b1;
        end
        else
        begin
            count_30us <= 'd0;
        end
    end
end

// always @(negedge clk_HDMI_n or negedge resetn) 
// begin
//     if(~resetn)
//     begin
//         start_out_RGB <= 'd0;
//     end
//     else
//     begin
//         if(~start_out_RGB )//未进行输出
//         begin
//             if(count_hs == 1055)
//             begin
//                 start_out_RGB <= 1'b1;
//             end
//         end
//         else 
//         begin
//             if(count_RGB >= 122)
//             begin
//                 start_out_RGB <= 'd0;
//             end
//         end

//     end
// end
always @(negedge clk_HDMI_n or negedge resetn) 
begin
    if(~resetn)
    begin
        start_out_RGB <= 'd0;
    end
    else
    begin
        if(~start_out_RGB & count_hs == 1055)//未进行输出
        begin
            start_out_RGB <= 1'b1;
        end
        else 
        begin
            if(count_RGB >= 122)
            begin
                start_out_RGB <= 'd0;
            end
        end

    end
end





always @(posedge clk_200MHz or negedge resetn) 
begin
    if(~resetn)
    begin
        count_RGB <= 'd0;
    end
    else
    begin
        if(dv)
        begin
            if(count_RGB <= 122)
            begin
                count_RGB <= count_RGB + 1'b1;
            end
            else
            begin
                count_RGB <= 'd0;
            end
        end
        else
        begin
            if(count_RGB >= 122 & (~start_out_RGB))
            begin
                count_RGB <= 'd0;
            end
        end
    end
end


always @(posedge clk_200MHz or negedge resetn) begin
    if(~resetn)
    begin
        rd_en_Left_FIFO <= 'd0;

    end
    else
    begin
        if(count_30us == 6000 & start_out_RGB & count_RGB < 45)
        begin
            rd_en_Left_FIFO <= 1'b1;
        end
        else
        begin
            rd_en_Left_FIFO <= 'd0;
        end  
    end
  
end

always @(posedge clk_200MHz or negedge resetn) begin
    if(~resetn)
    begin
        rd_en_Down_FIFO <= 'd0;

    end
    else
    begin
        if(count_30us == 6000 & start_out_RGB & count_RGB > 44)
        begin
            rd_en_Down_FIFO <= 1'b1;
        end
        else
        begin
            rd_en_Down_FIFO <= 'd0;
        end
    end
end
//输出使能

always @(posedge clk_200MHz or negedge resetn) begin
    if(~resetn)
    begin
        valid_RGB_data <= 'd0;

    end
    else
    begin
        if(rd_en_Down_FIFO | rd_en_Left_FIFO)
        begin
            valid_RGB_data <= 1'b1;
        end
        else
        begin
            valid_RGB_data <= 'd0;
        end
    end    
end

// always @(posedge clk_200MHz or negedge resetn) 
// begin
//     if(~resetn)
//     begin
//         flag_RGB_data <= 'd0;

//     end
//     else
//     begin
//         if(rd_en_Left_FIFO)
//         begin

//             if(count_RGB == 'd0 & count_hs >= 1055)
//                 flag_RGB_data <= 1'b1;  //此处存在风险
//             else
//             begin
//                 if( count_hs < 1055 & empty_down )
//                 begin
//                     flag_RGB_data <= 'd0;
//                 end
//             end
//         end
//         else
//         begin
//             if(count_RGB >= 122 & count_30us == 6000)
//             begin
//                  flag_RGB_data <= 'd0;
//             end
//         end

//     end    
// end
always @(posedge clk_200MHz or negedge resetn) begin
    if(~resetn)
    begin
        RGB_data <= 'd0;
    end
    else
    begin
        if(count_RGB < 45)
        begin
            RGB_data <= RGB_data_left_out;
        end
        else
        begin
            RGB_data <=  RGB_data_down_out;
        end
    end
    
    
end


endmodule
