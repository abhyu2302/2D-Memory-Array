`timescale 1ns / 1ps
module datapath #(
  parameter R = 4,   // Number of rows in memory
  parameter C = 4,   // Number of columns in memory
  parameter N = 4    // Data width (bits per cell)
)(
  input wire clk,    // Clock input
  input wire rst,    // Reset input
  input wire req,    // Request signal (1 = active transaction)
  input wire rw,     // Read/Write control (1 = read, 0 = write)
  input wire cs,     // Chip select (1 = enable memory)
  input wire [N-1:0] Qi,   // Data to be written into memory
  input wire [$clog2(R)-1:0] ar, // Row address
  input wire [$clog2(C)-1:0] ac, // Column address
  output reg [N-1:0] Qa,   // Data read from memory
  output reg valid         // High when Qa contains valid data //there is something to be read
);

  reg [N-1:0] mem [0:R-1][0:C-1]; // Define a 2D memory array with R rows and C columns, each N bits wide

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      Qa <= {N{1'b0}};
      valid <= 1'b0; // On reset: clear output and valid flag
    end 
    else if (cs) begin //if chip is selected 
      if (req && !rw) begin
        // Write operation: store Qi into memory at location (ar, ac)
        mem[ar][ac] <= Qi;
        valid <= 1'b0; // No valid data yet, since it's a write
      end 
      else if (req && rw) begin
        // Read operation: fetch data from memory at (ar, ac)
        Qa <= mem[ar][ac];
        valid <= 1'b1; // Data is valid, since it's a read
      end 
      else begin
        // No request: no valid output
        valid <= 1'b0;
      end
    end 
    else begin
      // If chip not selected: no valid output
      valid <= 1'b0;
    end
  end

endmodule
