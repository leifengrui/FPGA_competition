`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/25 09:09:20
// Design Name: 
// Module Name: algorithm
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


module algorithm_up#
(
    parameter  HOR      = 1919,
    parameter  VER      = 1079,
    parameter  NUM_ROW_LED_79  = 79,
    parameter  NUM_LINE_LED_44 = 44,
    parameter  AREA     = 23

)
(
    input      wire                clkn,//148.5MHz negedge
    input      wire                resetn,
    input      wire                hs,            //horizontal synchronization for 9134
    input      wire                vs,            //vertical synchronization for 9134
    input      wire                de,            //data valid for 9134
    input      wire  [23:0]        RGB_data,          //data for 9134

    // output    reg dv_RGB_hor_up_out;
    output  wire dv_RGB_hor_up_out,
    output  wire cl_RGB_hor_up_out,

    output      wire   [23:0]       RGB_hor_up_out
);
reg                valid_RGB_hor_up;
wire flag_hs;
wire flag_vs;
assign flag_hs = ~hs;
assign flag_vs = ~vs;
reg [10:0] count_hor;
reg [11:0] count_ver;
reg [6:0] count_up;
wire [23:0] RGB_hor_up       [0:77];//78���ƴ�
reg [23:0] RGB_hor_up_max       [0:77];//78���ƴ�
reg [23:0] RGB_hor_up_min       [0:77];//78���ƴ�
genvar i ;
for (i=0; i < 78; i=i+1) 
begin
// assign  RGB_hor_up[i] = (RGB_hor_up_max[i] + RGB_hor_up_min[i])/2;
assign  RGB_hor_up[i] = (RGB_hor_up_min[i] );
end
//define for GetMax
reg            valid_RGB_Data_GetMax;
wire           valid_max_RGB_GetMax;
wire    [23:0] max_RGB_GetMax;
reg resetn_GetMax;
integer j = 0 ;
reg [6:0] i_RGB_hor_up;//�б�

reg [7:0] count_valid_RGB_data;
reg  resetn_GetMin;
reg valid_RGB_Data_GetMin         ;

wire valid_min_RGB_GetMin      ;
wire  [23:0] min_RGB_GetMin    ;






//count for row(hor)

//��������ݵı�־λ����
always @(negedge clkn or negedge resetn) begin
    if(~resetn)
    begin
        count_valid_RGB_data <= 'd0;
    end
    else
    begin
        if(dv_RGB_hor_up_out)
        begin
            if(count_valid_RGB_data < 23)
            begin
                count_valid_RGB_data <= count_valid_RGB_data + 1'b1;
            end
            else
            begin
                count_valid_RGB_data <= 'd0;
            end
        end
        else
        begin
            count_valid_RGB_data <= 'd0;
        end
    end
end

assign cl_RGB_hor_up_out = (count_valid_RGB_data == 23) ? 1'b1:1'b0;

always @(negedge clkn or negedge resetn) begin
    if(~resetn)
    begin
        count_hor <= 'd0;
    end
    else
    begin
        if(flag_hs & de & count_ver < 1080 & flag_vs)
        begin
            count_hor <= count_hor + 1'b1;
        end
        else
        begin
            count_hor <= 'd0;
        end
    end
end
//count for line(ver)
always @(negedge clkn or negedge resetn) begin
    if(~resetn)
    begin
        count_ver <= 'd0;
    end
    else
    begin
        if(flag_vs)
        begin
            if(count_hor == 1919 & count_ver < 1079)//�˴����ڷ���
            begin
                count_ver <= count_ver + 1'b1;
            end
        end
        else
        begin
            count_ver <= 'd0;
        end
    end
end

//��ȡ���ֵ
always @(negedge clkn or negedge resetn) 
begin
    if(~resetn)
    begin
       resetn_GetMax            <= 'd0;
       valid_RGB_Data_GetMax    <= 'd0;

       resetn_GetMin            <= 'd0;
       valid_RGB_Data_GetMin    <= 'd0;

    end
    else
    begin
        if(count_ver <= 47 & flag_vs  & (count_hor > 23) & (count_hor <= 1897))
        begin
            if(flag_hs)
            begin
                if(de)
                begin
                resetn_GetMax            <= 1'b1;
                valid_RGB_Data_GetMax    <= 1'b1;

                resetn_GetMin            <= 1'b1;
                valid_RGB_Data_GetMin    <= 1'b1;

                end
            end
            else
            begin
                resetn_GetMax            <= 1'b0;
                valid_RGB_Data_GetMax    <= 'd0;//��������ɾ��

                resetn_GetMin           <= 1'b0;
                valid_RGB_Data_GetMin    <= 'd0;//��������ɾ��
            end
        end
        else
        begin
                resetn_GetMax            <= 1'b0;
                valid_RGB_Data_GetMax    <= 'd0;//��������ɾ��

                resetn_GetMin            <= 1'b0;
                valid_RGB_Data_GetMin    <= 'd0;//��������ɾ��


        end
    end
end
//RGB_hor_up����
always @(negedge clkn or negedge resetn) begin
    if(~resetn)
    begin
        //  RGB_hor_up[0] = 'd0;
        //  RGB_hor_up[1] = 'd0;

        for (j=0; j < 78; j=j+1) 
        begin
            RGB_hor_up_max[j] <= 'd0;
            RGB_hor_up_min[j] <= 'd0;
        end
        i_RGB_hor_up        <= 'd0;
        valid_RGB_hor_up    <= 'd0;
       count_up              <= 'd0;
        
    end
    else
    begin
        if(flag_vs)
        begin
            if(flag_hs&de)
            begin
                if(count_ver == 'd0 & valid_min_RGB_GetMin& valid_max_RGB_GetMax & (count_hor > 23 & count_hor <= 1897))
                begin
                    RGB_hor_up_max[i_RGB_hor_up] <= max_RGB_GetMax;
                    RGB_hor_up_min[i_RGB_hor_up] <= min_RGB_GetMin;
                    if(i_RGB_hor_up < 77)
                    begin
                        i_RGB_hor_up <= i_RGB_hor_up + 1'b1;
                    end
                    else
                    begin
                        i_RGB_hor_up <= 'd0;
                    end
                end
                else if(count_ver >'d0 & valid_min_RGB_GetMin& valid_max_RGB_GetMax & count_ver < 48 &  (count_hor > 23 & count_hor <= 1897))
                begin
                    if(RGB_hor_up_max[i_RGB_hor_up] < max_RGB_GetMax)
                    begin
                        RGB_hor_up_max[i_RGB_hor_up] <= max_RGB_GetMax;
                    end

                    if(RGB_hor_up_min[i_RGB_hor_up] > min_RGB_GetMin)
                    begin
                        RGB_hor_up_min[i_RGB_hor_up] <= min_RGB_GetMin;
                    end

                    if(i_RGB_hor_up < 77)
                    begin
                        i_RGB_hor_up <= i_RGB_hor_up + 1'b1;
                    end
                    else
                    begin
                        i_RGB_hor_up <= 'd0;
                    end

                //�������ûִ��
                    if(count_ver == 'h2f & valid_max_RGB_GetMax)
                    begin

                        valid_RGB_hor_up <= 1'b1;
                        count_up         <= count_up + 1'b1;
                    end
                    else
                    begin
                        valid_RGB_hor_up  <= 'd0;
                    end
                end
            end
            else
            begin
                i_RGB_hor_up <= 'd0;
            end

        end
        else
        begin
            for (j=0; j< 78;j=j+1) 
            begin
                RGB_hor_up_max[j] <= 'd0;
                RGB_hor_up_min[j] <= 'd0;
            end
            i_RGB_hor_up        <= 'd0; 
            valid_RGB_hor_up  <= 'd0;
            count_up <= 'd0;
        end

    end
end
assign RGB_hor_up_out = valid_RGB_hor_up & (count_up < 78) ? RGB_hor_up[count_up]:'d0;
assign dv_RGB_hor_up_out = valid_RGB_hor_up & (count_up < 78) ? 1'b1:'d0;


GetMax#(
    .LENGTH(23)
)  
GetMax_u (
    .clkn                     ( clkn                    ),
    .resetn                  ( resetn_GetMax            ),
    .valid_RGB_Data          ( valid_RGB_Data_GetMax    ),
    .RGB_Data                ( RGB_data          ),
    .valid_max_RGB           ( valid_max_RGB_GetMax     ),
    .max_RGB                 ( max_RGB_GetMax           )
);


GetMin #(
    .LENGTH ( 23 )
    )
 u_GetMin (
    .clkn                    ( clkn                   ),
    .resetn                  ( resetn_GetMin                 ),
    .valid_RGB_Data          ( valid_RGB_Data_GetMin         ),
    .RGB_Data                ( RGB_data        [23:0] ),

    .valid_min_RGB           ( valid_min_RGB_GetMin          ),
    .min_RGB                 ( min_RGB_GetMin         [23:0] )
);


endmodule
