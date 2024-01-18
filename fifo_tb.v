`timescale 1ns / 1ps
`include "fifo.v"

module fifo_tb;

  // Inputs
  reg [7:0] data_in;
  reg en_read, reset, clk, en_write;
  integer i = 0;

  // Outputs
  wire [7:0] data_out;

  // Instantiate the FIFO module
  fifo fifo1 (
    .data_in(data_in),
    .en_read(en_read),
    .reset(reset),
    .clk(clk),
    .en_write(en_write),
    .data_out(data_out)
  );

  // Clock generation
  always #5 clk = ~clk;

  // Initial block for test scenarios
  initial begin
    $dumpfile("fifo_tb.vcd");
    $dumpvars(0, fifo_tb);
  end

  // Rest of the initial block
  initial begin
    // Dump VCD file
    // Initialize inputs
    clk = 1;
    reset = 1;
    en_read = 0;
    en_write = 0;
    data_in = 8'h00;
    #5
    reset = 0;
    en_read = 0;
    en_write = 1;
    for (i = 0; i < 16; i = i + 1) begin
      data_in = $random % 256; // 256 is 2^8
      $display("Random 8-bit Number[%0d]: %h", i, data_in);
      #10;
    end
    en_read = 1;
    en_write = 0;
    #160 $finish;
  end

endmodule
