module register_file
(
	input logic 		clk,
	input logic 		rstn,
	
	input logic	[4:0]   a1,		// [25:21] instr bits 
	input logic	[4:0]   a2,		// [20:16] instr bits
	input logic	[4:0]	a3,		// [20:16] or [15:11] instr bits
	
	input logic 		we3,
	input logic	[31:0]	wd3,
	
	output logic [31:0]	rd1,
	output logic [31:0]	rd2
	
);


logic [31:0] mem_reg [31:0]; // amount architectural registers in MIPS = 32 

// read from register_file
assign rd1 = (a1 != 0) ? mem_reg [a1] : 32'b0;
assign rd2 = (a2 != 0) ? mem_reg [a2] : 32'b0;

// write in register file
always @(posedge clk) begin	
	if(~rstn) begin
		for(int i = 0; i < 32; i = i + 1) mem_reg[i] <= 32'b0;	
	end
	
	else begin
		if (we3) mem_reg[a3] <= wd3;			
	end
end

endmodule 
