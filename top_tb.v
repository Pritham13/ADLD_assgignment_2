`timescale 1ns/1ns
`include "top.v"
module tb_top;

  reg clk, reset, read_en, write_en;
  reg [7:0] data_in;
  wire [7:0] data_out;
  wire overflow,underflow;
  // Clock generation
  always begin
    #5 clk = ~clk;
  end

  // Instantiate the DUT
  top uut (
    .clk(clk),
    .reset(reset),
    .read_en(read_en),
    .write_en(write_en),
    .data_in(data_in),
    .data_out(data_out),
    .overflow(overflow),
    .underflow(underflow)
  );
initial
begin
    // Dump VCD file
    $dumpfile("tb_top.vcd");
    $dumpvars(0, tb_top);
end
  // Initialize signals
  initial begin
    clk = 0;
    reset = 1;
    read_en = 0;
    write_en = 0;
    data_in = 8'h00;


    // Apply reset
    #10 reset = 0;

    // Scenario 1: Write data, then read it
    #20 write_en = 1; data_in = 8'h0A; // Write data
    #10 write_en = 0;                  // Stop writing
    #20 read_en = 1;                   // Start reading
    #10 read_en = 0;                   // Stop reading

    // Scenario 2: Write multiple data, then read them
    #20 write_en = 1; data_in = 8'h0A; // Write data
    #10 write_en = 1; data_in = 8'h1B; // Write more data
    #10 write_en = 0;                  // Stop writing
    #20 read_en = 1;                   // Start reading
    #10 read_en = 0;                   // Stop reading

    // Scenario 3: Underflow condition (read without writing)
    #20 read_en = 1;                   // Start reading
    #10 read_en = 0;                   // Stop reading

    // Scenario 4: Overflow condition (write without reading)
    #20 write_en = 1; data_in = 8'h0A; // Write data
    #10 write_en = 1; data_in = 8'h1B; // Write more data
    #10 write_en = 1; data_in = 8'h2C; // Write more data
    #10 write_en = 0;                  // Stop writing

    // Scenario 5: Full cycle with more data
    #20 write_en = 1; data_in = 8'h0A; // Write data
    #10 write_en = 1; data_in = 8'h1B; // Write more data
    #10 write_en = 1; data_in = 8'h2C; // Write more data
    #20 read_en = 1;                   // Start reading
    #10 read_en = 0;                   // Stop reading

    // Scenario 6: Alternating Write and Read
    #20 write_en = 1; data_in = 8'h0A; // Write data
    #10 write_en = 0;                  // Stop writing
    #20 read_en = 1;                   // Start reading
    #10 read_en = 0;                   // Stop reading
    #20 write_en = 1; data_in = 8'h1B; // Write more data
    #10 write_en = 0;                  // Stop writing
    #20 read_en = 1;                   // Start reading
    #10 read_en = 0;                   // Stop reading


    // End simulation
    #10 $finish;
  end

endmodule
