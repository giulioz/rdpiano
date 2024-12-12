`timescale 1ns/100ps

// https://github.com/furrtek/Arcade-TMNT_MiSTer/blob/master/sim/cells/fjd.v
module cell_FJD ( // Positive Edge Clocked Power JKFF with CLEAR
	input CK,
	input J, K,
	input nCL,
  // TODO: inverted?
	output reg Q = 1'b0,
	output nQ
);
	always @(posedge CK or negedge nCL) begin
		if (~nCL)
			// Q <= #1 1'b0;					// tmax = 5.1ns
			Q <= 1'b0;					// tmax = 5.1ns
		else begin
			case({J, K})
				// 2'b00 : Q <= #2 Q;		// tmax = 7.9ns
				// 2'b01 : Q <= #2 1'b0;
				// 2'b10 : Q <= #2 1'b1;
				// 2'b11 : Q <= #2 ~Q;
				2'b00 : Q <= Q;		// tmax = 7.9ns
				2'b01 : Q <= 1'b0;
				2'b10 : Q <= 1'b1;
				2'b11 : Q <= ~Q;
			endcase
		end
	end
	assign nQ = ~Q;
endmodule

module cell_DE3 ( // 3:8 Decoder
  input wire B,
  input wire A,
  input wire C,
  output wire X0,
  output wire X1,
  output wire X2,
  output wire X3,
  output wire X4,
  output wire X5,
  output wire X6,
  output wire X7
);
  assign {X7, X6, X5, X4, X3, X2, X1, X0} = ~(1 << {C, B, A});
endmodule

module cell_FDQ ( // 4-bit DFF
  input wire CK,
  input wire DA,
  input wire DB,
  input wire DC,
  input wire DD,
  output reg QA = 1'b0,
  output reg QB = 1'b0,
  output reg QC = 1'b0,
  output reg QD = 1'b0
);
  always @(negedge CK) begin
    {QA, QB, QC, QD} <= {DA, DB, DC, DD};
  end
endmodule

module cell_A4H ( // 4-bit Full Adder
  input wire A4,
  input wire B4,
  input wire A3,
  input wire B3,
  input wire A2,
  input wire B2,
  input wire A1,
  input wire B1,
  input wire CI,
  output wire CO,
  output wire S4,
  output wire S3,
  output wire S2,
  output wire S1
);
  wire C1, C2, C3;
  assign {C1, S1} = A1 + B1 + CI;
  assign {C2, S2} = A2 + B2 + C1;
  assign {C3, S3} = A3 + B3 + C2;
  assign {CO, S4} = A4 + B4 + C3;
endmodule

module cell_DE2 ( // 2:4 Decoder
  input wire A,
  input wire B,
  output wire X0,
  output wire X1,
  output wire X2,
  output wire X3
);
  assign {X3, X2, X1, X0} = ~(1 << {B, A});
endmodule

// https://github.com/furrtek/Arcade-TMNT_MiSTer/blob/master/sim/cells/fdm.v
module cell_FDM ( // DFF
  input wire CK,
  input wire D,
  // checked
	output nQ,
	output reg Q = 1'b0
);
  // checked
  always @(posedge CK) begin
    Q <= D;		// tmax = 6.0ns
  end
  assign nQ = ~Q;
endmodule

// https://github.com/furrtek/Arcade-TMNT_MiSTer/blob/master/sim/cells/fdn.v
module cell_FDN (
    input wire CLK,
    input wire D,
    input wire nS,
    output reg Q = 1'b0,
    output wire nQ
);
  always @(posedge CLK or negedge nS) begin
    if (!nS)
      Q <= 1'b1;
    else
      Q <= D;
  end
  assign nQ = ~Q;
endmodule

// https://github.com/furrtek/Arcade-TMNT_MiSTer/blob/master/sim/cells/fdo.v
module cell_FDO ( // DFF with Reset
  input wire CK,
  input wire D,
  input wire nR,
  output reg Q = 1'b0,
  output wire nQ
);
  always @(posedge CK or negedge nR) begin
    if (!nR)
      Q <= 1'b0;  // tmax = 2.8ns
    else
      Q <= D;     // tmax = 6.0ns
  end
  assign nQ = ~Q;
endmodule

// Schmidtt trigger?
module cell_unkf ( // Unknown F
  input wire I,
  output wire XA,
  output wire XB
);
  // TODO: inverted?
  assign XA = I;
  assign XB = ~I;
endmodule

// https://github.com/furrtek/Arcade-TMNT_MiSTer/blob/master/sim/cells/fdp.v
module cell_FDP ( // DFF with SET and RESET
  input wire CK,
  input wire D,
  input wire R,
  input wire S,
  output reg Q = 1'b0,
  output wire nQ
);
  always @(posedge CK, negedge S, negedge R) begin
		if (!S)
			Q <= 1'b1;	// tmax = 3.0ns
		else if (!R)
			Q <= 1'b0;	// tmax = 2.9ns
		else
			// Q <= #1 D;	// tmax = 6.1ns
			Q <= D;	// tmax = 6.1ns
	end
	assign nQ = ~Q;
endmodule

// Derived from https://github.com/furrtek/Arcade-TMNT_MiSTer/blob/master/sim/cells/C43.v
module cell_C45 ( // 4-bit Binary Synchronous Up Counter
  input wire DA,
  input wire EN,
  input wire CI,
  input wire nCL,
  input wire DB,
  input wire nL,
  input wire CK,
  input wire DC,
  input wire DD,
  output wire QA,
  output wire QB,
  output wire CO,
  output wire QC,
  output wire QD
);
  wire [3:0] D;
  assign D = {DD, DC, DB, DA};
  reg [3:0] Q = 4'b0000;
  always @(posedge CK) begin
		if (!nL)
			Q <= D;			// Load
		else if (!nCL)
			Q <= 4'd0;		// Clear tmax = 9.7ns
		else if (EN & CI)
			Q <= Q + 1'b1;	// Count tmax = 13.4ns
		else
			Q <= Q;
	end
	assign CO = &{Q[3:0], CI};
  assign {QD, QC, QB, QA} = Q;
endmodule

// https://github.com/furrtek/Arcade-TMNT_MiSTer/blob/master/sim/cells/lt4.v
module cell_LT4 ( // 4-bit Data Latch
  input wire nG, // Transparent when low
  input wire DA,
  input wire DB,
  input wire DC,
  input wire DD,
  output wire NA,
  output reg PA = 1'b0,
  output wire NB,
  output reg PB = 1'b0,
  output wire NC,
  output reg PC = 1'b0,
  output wire ND,
  output reg PD = 1'b0
);
  always @(*) begin
    if (!nG)
      {PA, PB, PC, PD} <= {DA, DB, DC, DD}; // tmax = 7.5ns
  end
  assign {NA, NB, NC, ND} = ~{PA, PB, PC, PD};
endmodule

// https://github.com/furrtek/Arcade-TMNT_MiSTer/blob/master/sim/cells/a2n.v
module cell_A2N ( // 2-bit Full Adder
  input wire B2,
  input wire A2,
  input wire B1,
  input wire A1,
  input wire CI,
  output wire CO,
  output wire S2,
  output wire S1
);
  wire C1;
  assign {C1, S1} = A1 + B1 + CI; // tmax = 5.3ns
  assign {CO, S2} = A2 + B2 + C1;
endmodule

// https://github.com/furrtek/Arcade-TMNT_MiSTer/blob/master/sim/cells/fdr.v
module cell_FDR ( // 4-bit DFF with CLEAR
  input wire nCL,
  input wire CK,
  input wire DA,
  input wire DB,
  input wire DC,
  input wire DD,
  output reg QA = 1'b0,
  output reg QB = 1'b0,
  output reg QC = 1'b0,
  output reg QD = 1'b0
);
  always @(posedge CK or negedge nCL) begin
    if (!nCL)
      {QA, QB, QC, QD} <= 4'b0;             // tmax = 6.7ns
    else
      {QA, QB, QC, QD} <= {DA, DB, DC, DD}; // tmax = 8.4ns
  end
endmodule

module cell_LT2 ( // 1-bit Data Latch
  input wire nG,
  input wire D,
  // Could be inverted
  output reg Q = 1'b0,
  output wire nQ
);
  always @(*) begin
    if (!nG)
      Q <= D;
  end
  assign nQ = ~Q;
endmodule

module cell_A1N ( // 1-bit Full Adder
  input wire A,
  input wire B,
  input wire CI,
  output wire CO,
  output wire S
);
  wire [1:0] adder;
  assign adder = A + B + CI;
  assign S = adder[0];
  assign CO = adder[1];
endmodule
