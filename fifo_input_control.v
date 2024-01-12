module fifo_input_control (
    input write_en,reset,clk,
    output reg write_en_o,overflow,
    output reg [4:0] ptr
);
reg [4:0]count=0;
always @(clk) 
begin
    if (reset)
    begin
        count <= 5'b0;
        ptr <= 5'b0;
        overflow <= 1'b0;
    end    
    else 
    begin
        if(write_en)
        begin
            write_en_o <=1;
            if (count!=5'b1111)
            begin
                overflow<=  0;
                count <= count+1;
                ptr<=count;
            end
            else
            begin
                overflow <=1; 
            end
        end
        else 
        begin
            write_en_o <= 1'b0;
        end
    end
end
endmodule