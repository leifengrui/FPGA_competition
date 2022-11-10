`timescale 1ns / 1ps
//function(english ):Gets the maximum RGB value from the LENGTH (24) RGB values
//chinese:从24个RGB中获取最大值

module GetMax#
(
    parameter LENGTH = 23//A cell of pixels
)
(
    //sys port
    input wire clkn, //148.5MHz negedge
    input wire resetn,
    //input
    input wire valid_RGB_Data,
    input wire [23:0]  RGB_Data,
    // output data
    output reg valid_max_RGB,
    output reg [23:0] max_RGB
);
reg [7:0] count;
reg [23:0] max_RGB_Temp;
always @(negedge clkn or negedge resetn) 
begin
    if(~resetn)
    begin
        count<= 'd0;
    end
    else
    begin
        if(valid_RGB_Data & count < LENGTH)
        begin
            count <= count + 1'b1;
        end
        else
        begin
            count <= 'd0;
        end
    end
end
//Solve for minimum
always @(*) 
begin
    if(~resetn)
    begin
        max_RGB_Temp <= 'd0;
    end
    else
    begin
        if(valid_RGB_Data)
        begin
           if(count == 'd0)
           begin
                max_RGB_Temp <= RGB_Data;
           end
           else
           begin
            if(count <= LENGTH)
            begin
                max_RGB_Temp[23:16] <= (max_RGB_Temp[23:16] < RGB_Data[23:16] )?RGB_Data[23:16]:max_RGB_Temp[23:16] ;
                max_RGB_Temp[15:8]  <= (max_RGB_Temp[15:8]  < RGB_Data[15:8]  )?RGB_Data[15:8] :max_RGB_Temp[15:8]  ;
                max_RGB_Temp[7:0]   <= (max_RGB_Temp[7:0]  < RGB_Data[7:0] )     ?RGB_Data[7:0]:max_RGB_Temp[7:0];
            end
            else
            begin
                 max_RGB_Temp <= 'd0;
            end

           end
        end
        else
        begin
            max_RGB_Temp <= 'd0;
        end
    end
end

// output max
always @(negedge clkn or negedge resetn) begin
    if(~resetn)
    begin
        max_RGB <= 'd0;
        valid_max_RGB <= 'd0;
    end
    else
    begin
        if(valid_RGB_Data & count == LENGTH)
        begin
             max_RGB <= max_RGB_Temp;
             valid_max_RGB <= 1'b1;
        end
        else
        begin
            max_RGB <= 'd0;
            valid_max_RGB <= 'd0;
        end
    end
end
endmodule
