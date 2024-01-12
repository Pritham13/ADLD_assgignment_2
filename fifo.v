module fifo (
    input [7:0] data_in,
    input [4:0]ptr_in,ptr_out,
    input en_read,en_write,reset,clk,
    output [7:0] data_out,
);
reg [7:0] register [15:0]
always @(clk) 
begin
    if (reset)
    begin
        for(i =0;i<16;i=i+1)
        begin
            register [i]= 8'd0; 
        end
    end
    case{en_write,en_read}
    2'b01: register[ptr_in]<=data_in;
    2'b10: data_out<= register[ptr_out];
    endcase    
end
endmodule