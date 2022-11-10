module  sys_reset_n#
(
parameter N = 32,            // debounce timer bitwidth
parameter MAX_TIME = 100,     //us
parameter FREQ = 50         //model clock :Mhz
)
(
    input    sys_clk,
    input    reset_n,
    output   sys_reset_n
);





localparam TIMER_MAX_VAL = 5000;
//------------------------------------------
// Delay 
reg  [N-1:0] timer_cnt;
always@(posedge sys_clk or negedge reset_n)
begin
    if(!reset_n)
        timer_cnt <= 0;
    else
        begin
        if(timer_cnt < TIMER_MAX_VAL) //100us
            timer_cnt <= timer_cnt+1'b1;
        end
end

//------------------------------------------
//rst_n synchronism
reg    syn_rst_n_d0;
reg    syn_rst_n_d1;
always@(posedge sys_clk or negedge reset_n)
begin
    if(!reset_n)
        begin
        syn_rst_n_d0 <= 0;
        syn_rst_n_d1 <= 0;
        end
    else if(timer_cnt == TIMER_MAX_VAL)
        begin
        syn_rst_n_d0 <= 1;
        syn_rst_n_d1 <= syn_rst_n_d0;
        end
    else
        begin
        syn_rst_n_d0 <= 0;
        syn_rst_n_d1 <= 0;
        end
end

assign    sys_reset_n = syn_rst_n_d1;

endmodule