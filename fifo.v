module fifo (
    input [7:0] data_in,
    input [4:0]ptr_in,
    input [4:0]ptr_out,
    input en_read,en_write,reset,clk,
    output reg [7:0] data_out
);
reg [7:0] register [15:0];
integer i;
always @(posedge clk) 
begin
    if (reset)
    begin
        for(i =0;i<16;i=i+1)
        begin
            register [i]= 8'd0; 
        end 
        data_out <=8'b0;
    end 
    else
    begin
        // case ({en_write,en_read})
        // 2'b01: register[ptr_in]<=data_in;
        // 2'b10: data_out <= register[ptr_out];
        // endcase 
        if  (en_write)
        begin
           register[ptr_in]<=data_in;
        end
        if  (en_read)
        begin
            data_out <= register[ptr_out];
        end 
        else 
        begin
            data_out<=0;
        end
    end 
end
endmodule