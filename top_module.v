`timescale 1ns / 1ps
module top_module #(
  parameter R = 4,  // Number of rows
  parameter C = 4,  // Number of columns
  parameter N = 4   // Data width
)(
  input wire clk,    // Clock
  input wire rst,    // Reset
  input wire cs,     // Chip select
  input wire req,    // Request signal
  input wire rw,     // Read/Write control
  input wire [$clog2(R*C)-1:0] addr,  // Linear address
  input wire [N-1:0] Qi,              // Input data (for write)
  output wire [N-1:0] Qa,             // Output data (for read)
  output wire valid,                  // Data valid signal
  output wire ready                   // Transaction ready signal
);

  // Internal signals to connect controller and datapath
  wire [$clog2(R)-1:0] ar;  
  wire [$clog2(C)-1:0] ac;  
  wire valid_internal; // Internal valid between datapath and controller

  // Instantiate controller
  controller #(
    .R(R), .C(C), .N(N)
  ) c1 (
    .clk(clk),
    .rst(rst),
    .cs(cs),
    .req(req),
    .rw(rw),
    .addr(addr),
    .valid(valid_internal),
    .ready(ready),
    .ar(ar),
    .ac(ac)
  );

  // Instantiate datapath
  datapath #(
    .R(R), .C(C), .N(N)
  ) d1 (
    .clk(clk),
    .rst(rst),
    .req(req),
    .rw(rw),
    .cs(cs),
    .Qi(Qi),
    .ar(ar),
    .ac(ac),
    .Qa(Qa),
    .valid(valid_internal)
  );

  // Connect internal valid to external output
  assign valid = valid_internal;

endmodule
