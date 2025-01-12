module CPUMock (
  // Xtal input
  input wire XTAL_IN, // 8 MHz

  input wire RESET_IN,

  // CPU I/O
  output reg E_IN, // 2 MHz
  output reg RW, AS,
  input wire IRQ,
  output wire [7:0] DATA_ADDR_LOW,
  output reg [7:0] AD_HIGH,

  // Commands input
  input wire shouldWrite,
  output reg writeDone,
  input wire [15:0] writeAddress,
  input wire [15:0] writeData
);

  // Internal registers
  reg [4:0] write_counter;
  reg data_addr_low_oe; // Output enable for DATA_ADDR_LOW
  reg [7:0] data_addr_low_out;

  // Tri-state buffer for DATA_ADDR_LOW
  assign DATA_ADDR_LOW = data_addr_low_oe ? data_addr_low_out : 8'bz;

  always @(posedge XTAL_IN or posedge RESET_IN) begin
    if (RESET_IN) begin
      // Reset all signals and counters
      E_IN <= 1;
      RW <= 1;
      AS <= 0;
      AD_HIGH <= 8'b0;
      data_addr_low_out <= 8'b0;
      data_addr_low_oe <= 0;
      writeDone <= 0;
      write_counter <= 0;
    end else begin
      if (!shouldWrite) begin
        AD_HIGH <= writeAddress[15:8];
        writeDone <= 0;
      end else if (shouldWrite && write_counter == 0) begin
        // Start write sequence
        write_counter <= 1;
        writeDone <= 0;
      end else if (write_counter != 0) begin
        // Proceed with write sequence
        write_counter <= write_counter + 1;
        case (write_counter)
          // First byte write sequence
          5'd1: begin
            // 1. E goes down
            E_IN <= 0;
          end
          5'd2: begin
            // 2. RW goes down
            RW <= 0;
          end
          5'd3: begin
            // 3. AS goes up
            AS <= 1;
            // Output the address
            AD_HIGH <= writeAddress[15:8];
            data_addr_low_out <= writeAddress[7:0];
            data_addr_low_oe <= 1;
          end
          5'd4: begin
            // 4. AS goes down
            AS <= 0;
          end
          5'd5: begin
            // 5. E goes up
            E_IN <= 1;
            // Output the lower byte of data
            data_addr_low_out <= writeData[7:0];
            data_addr_low_oe <= 1;
          end
          // Second byte write sequence
          5'd6: begin
            // 1. E goes down
            E_IN <= 0;
          end
          5'd7: begin
            // RW remains down (already asserted)
          end
          5'd8: begin
            // 3. AS goes up
            AS <= 1;
            // Output the incremented address
            AD_HIGH <= writeAddress[15:8];
            data_addr_low_out <= writeAddress[7:0] + 1; // Increment address
            data_addr_low_oe <= 1;
          end
          5'd9: begin
            // 4. AS goes down
            AS <= 0;
          end
          5'd10: begin
            // 5. E goes up
            E_IN <= 1;
            // Output the upper byte of data
            data_addr_low_out <= writeData[15:8];
            data_addr_low_oe <= 1;
          end
          5'd11: begin
            // RW goes up (end of write operation)
            RW <= 1;
          end
          5'd12: begin
            // Tri-state DATA_ADDR_LOW and signal write completion
            data_addr_low_oe <= 0;
            writeDone <= 1;
            write_counter <= 0; // Reset counter for next operation
          end
          default: begin
            // Do nothing in other counts
          end
        endcase
      end
    end
  end

endmodule
