module controllertest();
logic clk, reset;
logic [5:0] op, funct;
logic zero;
logic pcen, memwrite, irwrite, regwrite;
logic alusrca, iord, memtoreg, regdst;
logic [1:0] alusrcb, pcsrc;
logic [2:0] alucontrol;
controller dut(clk, reset, op, funct, zero, pcen, memwrite, irwrite, regwrite, alusrca, iord,
memtoreg, regdst, alusrcb, pcsrc, alucontrol);
// generate clock to sequence tests
always
begin
clk <= 1; # 5; clk <= 0; # 5;
end
parameter LW = 6'b100011; // Opcode for lw
parameter SW = 6'b101011; // Opcode for sw
parameter RTYPE = 6'b000000; // Opcode for R-type
parameter BEQ = 6'b000100; // Opcode for beq
parameter ADDI = 6'b001000; // Opcode for addi
parameter J = 6'b000010; // Opcode for j
// initialize test
initial
begin
reset <= 1; # 20; reset <= 0;
// ADD instruction
op = RTYPE; funct = 6'b100000; zero = 1'b0; #40;
// SUB instruction
op = RTYPE; funct = 6'b100010; zero = 1'b0; #40;
// AND instruction
op = RTYPE; funct = 6'b100100; zero = 1'b0; #40;
// OR instruction
op = RTYPE; funct = 6'b100101; zero = 1'b0; #40;
// SLT instruction
op = RTYPE; funct = 6'b101010; zero = 1'b0; #40;
// SW instruction
op = SW; funct = 6'bxxxxxx; zero = 1'b0; #40;
// LW instruction
op = LW; funct = 6'bxxxxxx; zero = 1'b0; #50;
// J instruction
op = J; funct = 6'bxxxxxx; zero = 1'b0; #30;
// ADDI instruction
op = ADDI; funct = 6'bxxxxxx; zero = 1'b0; #40;
// BEQ - not taken instruction
op = BEQ; funct = 6'bxxxxxx; zero = 1'b0; #30;
// BEQ - taken instruction
op = BEQ; funct = 6'bxxxxxx; zero = 1'b1; #30;
end
endmodule
