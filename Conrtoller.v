`timescale 1ns / 1ps
module controller #(
  parameter R = 4,   // Rows
  parameter C = 4,   // Columns
  parameter N = 4    // Data width
)(
  input wire clk,    // Clock
  input wire rst,    // Reset
  input wire cs,     // Chip select
  input wire req,    // Request signal
  input wire rw,     // Read/Write control
  input wire [$clog2(R*C)-1:0] addr, // Linear address input
  input wire valid,  // Valid signal from datapath (indicates read data ready)
  output reg ready,  // Ready signal (transaction complete)
  output wire [$clog2(R)-1:0] ar, // Decoded row address
  output wire [$clog2(C)-1:0] ac  // Decoded column address
);

  // Decode the linear address into row and column
  assign ar = addr[$clog2(R*C)-1 -: $clog2(R)]; // Extract row bits
  assign ac = addr[$clog2(C)-1:0];              // Extract column bits

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      // On reset: not ready
      ready <= 1'b0;
    end 
    else begin
      if (cs) begin
        if (req && !rw) begin
          // Write request: ready immediately
          ready <= 1'b1;
        end 
        else if (valid) begin
          // Read request: ready when datapath sets valid
          ready <= 1'b1;
        end 
        else begin
          // Otherwise: not ready
          ready <= 1'b0;
        end
      end 
      else begin
        // Chip not selected: not ready
        ready <= 1'b0;
      end
    end
  end

endmodule
