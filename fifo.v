module fifo (
    input [7:0] data_in,
    input en_read,en_write,reset,clk,
    output reg overflow,underflow,
    output reg [7:0] data_out
);
reg [7:0] register [15:0];
reg [3:0]ptr_rd,ptr_wr;
integer i;

always @ (posedge clk)
begin
    if (reset)
    begin
        ptr_wr<=4'b0;
    end 
    if(en_write)
        if(ptr_wr!=4'b1111)
            ptr_wr<= ptr_wr+1;
        else
            overflow <=1;
end

always @ (posedge clk)  
begin
    if (reset)
    begin
        ptr_rd<=4'b0;
    end 
    if(en_read)
        if(ptr_rd!=4'b1111)
            ptr_rd<= ptr_rd+1;
        else
            underflow <=1;
        
end

always @(posedge clk) 
begin
    if (reset)
    begin
        for(i =0;i<16;i=i+1)
        begin
            register [i]= 8'd0; 
        end 
        data_out <=8'b0;
        ptr_wr<=0;
        ptr_rd<=0;
        overflow<=0;
        underflow<=0;
    end 
    else
    begin
        if  (en_write)
        begin
           register[ptr_wr]<=data_in;
        end
        if  (en_read)
        begin
            data_out <= register[ptr_rd];
        end 
        else 
        begin
            data_out<=0;
        end
    end 
end
endmodule
