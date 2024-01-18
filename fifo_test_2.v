module fifo_2 (
    input [7:0] data_in,
    input en_read, en_write, reset, clk,
    output reg overflow, underflow,
    output reg [7:0] data_out
);

reg [7:0] register [0:15];
reg [3:0] ptr_wr;
integer i;

always @(posedge clk) 
begin
    if (reset)
    begin
        for (i = 0; i < 16; i = i + 1)
        begin
            register[i] = 8'd0; 
        end 
        data_out <= 8'b0;
        ptr_wr <= 4'd15;
        overflow <= 0;
        underflow <= 0;
    end 
    else
    begin
        if (en_write)
        begin
            register[ptr_wr] <= data_in;
            if (ptr_wr != 4'b0)
                ptr_wr <= ptr_wr - 1;
            else
                overflow <= 1;
        end
        if (en_read)
        begin
            if (register[15] != 8'b0)
            begin
                data_out <= register[15];
                for (i = 0; i < ptr_wr; i = i + 1)
                begin
                    register[i] <= register[i + 1];
                end
                ptr_wr <= ptr_wr - 1;
            end
            else
            begin
                underflow <= 1'b1;   
            end
        end
        else 
        begin
            data_out <= 8'b0;
        end
    end 
end

endmodule
