// Components used in MIPS processor

module regfile(input  logic        clk, we3, 
               input  logic [4:0]  ra1, ra2, wa3, 
               input  logic [31:0] wd3, 
               output logic [31:0] rd1, rd2);

  logic [31:0] rf[31:0];

  // three ported register file with register 0 hardwired to 0
  // read two ports combinationally; write third port on rising edge of clock

  always_ff @(posedge clk)
    if (we3) rf[wa3] <= wd3;	

  assign rd1 = (ra1 != 0) ? rf[ra1] : 0;
  assign rd2 = (ra2 != 0) ? rf[ra2] : 0;
endmodule

module adder(input  logic [31:0] a, b,
             output logic [31:0] y);

  assign y = a + b;
endmodule

module sl2(input  logic [31:0] a,
           output logic [31:0] y);

  assign y = {a[29:0], 2'b00}; 		// shift left by 2
endmodule

module signext(input  logic [15:0] a,
               output logic [31:0] y);
              
  assign y = {{16{a[15]}}, a};
endmodule

module flopr #(parameter WIDTH = 8)
              (input  logic             clk, reset,
               input  logic [WIDTH-1:0] d, 
               output logic [WIDTH-1:0] q);

  always_ff @(posedge clk, posedge reset)
    if (reset) q <= 0;
    else       q <= d;
endmodule

module flopenr #(parameter WIDTH = 8)
                (input  logic             clk, reset, en,
                 input  logic [WIDTH-1:0] d, 
                 output logic [WIDTH-1:0] q);
 
  always_ff @(posedge clk, posedge reset)
    if      (reset) q <= 0;
    else if (en)    q <= d;
endmodule

module flopen #(parameter WIDTH = 8)
	       (input logic			clk, en,
		input logic  [WIDTH-1:0]	d,
		output logic [WIDTH-1:0] 	q);

always_ff @(posedge clk)
    if      (en) q <= d;

endmodule

module mux2 #(parameter WIDTH = 8)
             (input  logic [WIDTH-1:0] d0, d1, 
              input  logic             s, 
              output logic [WIDTH-1:0] y);

  assign y = s ? d1 : d0; 
endmodule

module alu(	input logic [31:0] a, b,
		input logic [2:0] f,
		output logic [31:0] y,
		output logic zero);

logic [32:0] a_unsigned, b_unsigned;

logic [31:0] sub, add, less_than, an, orr, less_than_u;
// zero fill a and b for unsigned comparison
assign a_unsigned = {1'b0, a};
assign b_unsigned = {1'b0, b};

assign sub = a - b;
assign add = a + b;
assign less_than = ($signed(a) < $signed(b));
assign less_than_u = (a_unsigned < b_unsigned);
assign orr = a|b;
assign an = a&b;

always_comb begin
	case(f)
		3'b010: y = add;
		3'b110: y = sub;
		3'b000: y = an;
		3'b001: y = orr;
		3'b111: y = less_than;
		3'b011: y = less_than_u;
		default: y = add;
	endcase
end

assign zero = (sub == 0) ? 1 : 0;

endmodule
