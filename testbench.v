`timescale 1ns / 1ps
module tb_sp;

  // Parameters
  parameter R = 4;  // Rows
  parameter C = 4;  // Columns
  parameter N = 4;  // Word size

  // Testbench signals
  reg clk = 0;          // Clock
  reg rst = 1;          // Reset
  reg cs = 0;           // Chip select
  reg req = 0;          // Request
  reg rw = 0;           // Read/Write control
  reg [$clog2(R*C)-1:0] addr = 0; // Address
  reg [N-1:0] Qi = 0;   // Input data

  // Outputs from DUT
  wire [N-1:0] Qa;  // Output data
  wire valid;       // Valid signal
  wire ready;       // Ready signal

  // Instantiate top module (DUT)
  top_module #(.R(R), .C(C), .N(N)) dut (
    .clk(clk),
    .rst(rst),
    .cs(cs),
    .req(req),
    .rw(rw),
    .addr(addr),
    .Qi(Qi),
    .Qa(Qa),
    .valid(valid),
    .ready(ready)
  );

  // Clock generation: toggle every 5 ns
  always #5 clk = ~clk;

  // Release reset after 25 ns
  initial #25 rst = 0;

  // Stimulus sequence
  initial begin
    @(negedge rst); // Wait for reset de-assertion

    // Write 0x01 to address 3
    cs = 1; addr = 4'd3; Qi = 4'h1; rw = 0; req = 1;
    @(posedge clk);

    // Read from address 3
    cs = 1; addr = 4'd3; rw = 1; req = 1;
    @(posedge clk);

    // Write 0x06 to address 5
    cs = 1; addr = 4'd5; Qi = 4'd6; rw = 0; req = 1;
    @(posedge clk);

    // Read from address 5
    cs = 1; addr = 4'd5; rw = 1; req = 1;
    @(posedge clk);

    // Finish simulation
    $finish;
  end

endmodule
