module RGB_Wave 
(
    input   wire clk,//247.5MHz
    input   wire restn,
    input   wire data,
    output  reg  ws,
    output  reg  dv
);
reg [7:0] count;
always @(posedge clk or negedge restn) 
begin
    if(~restn)
    begin
        count <= 'd0;
    end
    else
    begin
        if(count < 249)
        begin
            count <= count + 1'b1;
        end
        else
        begin
            count <= 'd0;
        end
    end
end
always @(posedge clk or negedge restn) begin
    if(~restn)
    begin
        dv <= 'd0;
    end
    else
    begin
        if(count >= 249)
        begin
            dv <= 1'b1;
        end
        else
        begin
            dv <= 1'b0;
        end
    end
    
end
always @(posedge clk or negedge restn)
begin
    if(~restn)
    begin
        ws <= 'd0;
    end
    else
    begin
        if(data)
        begin
            if(count < 200)
            begin
                ws <= 1'b1;
            end
            else
            begin
                ws <= 1'b0;
            end

        end
        else
        begin
            if(count < 50)
            begin
                ws <= 1'b1;
            end
            else
            begin
                ws <= 1'b0;
            end
        end
        
    end
end
endmodule