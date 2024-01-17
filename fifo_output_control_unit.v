// TODO: add  data_out  in the top module  
module fifo_output_control (
    input  read_en, reset, clk,
    input [7:0]data_out,
    output reg read_en_o, 
    output reg underflow,
    output reg [4:0] ptr
);

    reg [4:0] count = 0;

    always @(posedge clk ) begin
        if (reset) begin
            count <= 5'b0;
            ptr <= 5'b0;
            underflow <= 1'b0;
        end
        else 
        begin
            if (read_en ) 
            begin
                if  (data_out != 8'd0) 
                begin
                    underflow <= 1'b0;
                    count <= count + 1;
                    ptr <= count;
                    read_en_o <= 1'b1;
                end
                else 
                begin
                    underflow <= 1'b1;
                    read_en_o <= 1'b0;
                end
            end
            else begin
                read_en_o <= 1'b0;
            end
        end
    end
endmodule
