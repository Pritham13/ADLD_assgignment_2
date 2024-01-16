//TODO: add overflow and underflow to the output list
`include "fifo_output_control_unit.v"
`include "fifo_input_control.v"
`include "fifo.v"
module top (
    input clk,reset,read_en,write_en,
    input [7:0]data_in,
    output [7:0]data_out,
    output overflow,underflow
);
wire [4:0] ptr_of;
wire [4:0] ptr_uf;
// fifo input cotrol takes data from processor 1
fifo_input_control fifo_input_control1 (
    .write_en(write_en), .reset(reset), .clk(clk),
    .write_en_o(write_en_o), .overflow(overflow),
    .ptr(ptr_of)
);
// fifo output control gets data from the fifo to processor 2
fifo_output_control fifo_output_control2 (
    .read_en(read_en), .reset(reset), .clk(clk),
    .read_en_o(read_en_o), .underflow(underflow),
    .ptr(ptr_uf)
);
// main inititalizaton
fifo fifo_inst (
    .data_in(data_in),
    .ptr_in(ptr_of),
    .ptr_out(ptr_uf),
    .en_read(read_en_o),
    .en_write(write_en_o),
    .reset(reset),
    .clk(clk),
    .data_out(data_out)
);



endmodule