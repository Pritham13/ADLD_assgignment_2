`include "fifo.v"

module fifo_tb;

  // Inputs
  reg [7:0] data_in;
  reg [4:0] ptr_in, ptr_out;
  reg en_read, reset, clk, en_write;

  // Outputs
  wire [7:0] data_out;

  // Instantiate the FIFO module
  fifo fifo1 (
    .data_in(data_in),
    .ptr_in(ptr_in),
    .ptr_out(ptr_out),
    .en_read(en_read),
    .en_write(en_write),
    .reset(reset),
    .clk(clk),
    .data_out(data_out)
  );

  // Clock generation
  // reg clk_gen;
  always #5 clk = ~clk;

  // Initial block for test scenarios
  initial begin
    // Dump VCD file
    $dumpfile("fifo_tb.vcd");
    $dumpvars(0, fifo_tb);

    // Initialize inputs
    clk = 0;
    reset = 1;
    en_read = 0;
    en_write = 0;
    data_in = 8'h00;
    ptr_in = 5'b00000; // Initial value for ptr_in
    ptr_out = 5'b00000; // Initial value for ptr_out

    // Apply reset
    #10 reset = 0;

    // Test scenario 1: Write data, then read it
    #20 en_write = 1; data_in = 8'h0A; ptr_in = ptr_in + 1; // Write data
    #10 en_write = 0;                  // Stop writing
    #20 en_read = 1; ptr_out = ptr_out + 1; // Start reading
    #10 en_read = 0;                   // Stop reading

    // Test scenario 2: Write multiple data, then read them
    #20 en_write = 1; data_in = 8'h0A; ptr_in = ptr_in + 1; // Write data
    #10 en_write = 1; data_in = 8'h1B; ptr_in = ptr_in + 1; // Write more data
    #10 en_write = 0;                  // Stop writing
    #20 en_read = 1; ptr_out = ptr_out + 1; // Start reading
    #10 en_read = 0;                   // Stop reading

    // Test scenario 3: Underflow condition (read without writing)
    #20 en_read = 1; ptr_out = ptr_out + 1; // Start reading
    #10 en_read = 0;                   // Stop reading

    // Test scenario 4: Overflow condition (write without reading)
    #20 en_write = 1; data_in = 8'h0A; ptr_in = ptr_in + 1; // Write data
    #10 en_write = 1; data_in = 8'h1B; ptr_in = ptr_in + 1; // Write more data
    #10 en_write = 1; data_in = 8'h2C; ptr_in = ptr_in + 1; // Write more data
    #10 en_write = 0;                  // Stop writing

    // Test scenario 5: Full cycle with more data
    #20 en_write = 1; data_in = 8'h0A; ptr_in = ptr_in + 1; // Write data
    #10 en_write = 1; data_in = 8'h1B; ptr_in = ptr_in + 1; // Write more data
    #10 en_write = 1; data_in = 8'h2C; ptr_in = ptr_in + 1; // Write more data
    #20 en_read = 1; ptr_out = ptr_out + 1; // Start reading
    #10 en_read = 0;                   // Stop reading

    // Test scenario 6: Alternating Write and Read
    #20 en_write = 1; data_in = 8'h0A; ptr_in = ptr_in + 1; // Write data
    #10 en_write = 0;                  // Stop writing
    #20 en_read = 1; ptr_out = ptr_out + 1; // Start reading
    #10 en_read = 0;                   // Stop reading
    #20 en_write = 1; data_in = 8'h1B; ptr_in = ptr_in + 1; // Write more data
    #10 en_write = 0;                  // Stop writing
    #20 en_read = 1; ptr_out = ptr_out + 1; // Start reading
    #10 en_read = 0;                   // Stop reading

    // End simulation
    #10 $finish;
  end

  // Always block for clock generation

endmodule
