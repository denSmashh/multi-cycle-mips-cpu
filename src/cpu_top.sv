module cpu_top (
     input logic CLK,
     input logic RSTn
     
);


//alu wires
wire alu_zero;

// control unit wires
wire pc_write;
wire branch;
wire pc_src;
wire alu_src_a;
wire reg_write;
wire instr_or_data;
wire mem_write;
wire ir_write;
wire mem2reg;
wire reg_dst;
wire [2:0] alu_control;
wire [1:0] alu_src_b; 

// another wires
wire [31:0] address;
logic [4:0] rt_or_rd;
logic [31:0] w_data_regfile;

wire pc_en;
assign pc_en = (alu_zero & branch) | pc_write;

logic [31:0] pc;
logic [31:0] pc_next;
register_en #(.DW(32)) i_pc_reg (.clk(CLK), .rstn(RSTn), .en(pc_en), .d(pc_next), .q(pc));

logic [31:0] r_data_idmem;
logic [31:0] mips_instruction; 
register_en #(.DW(32)) i_instruction_reg (.clk(CLK), .rstn(RSTn), .en(ir_write), .d(r_data_idmem), .q(mips_instruction));

logic [31:0] data_mem;
register #(.DW(32)) i_data_mem_reg (.clk(CLK), .rstn(RSTn), .d(r_data_idmem), .q(data_mem));


mux_2 #(.DW(32)) i_instr_or_data_mux (.a1(pc), .a2(), .sel(instr_or_data), .y(address));
mux_2 #(.DW(5) ) i_rt_or_rd_mux (.a1(mips_instruction[20:16]), .a2(mips_instruction[15:11]), .sel(reg_dst), .y(rt_or_rd));
mux_2 #(.DW(32)) i_write_reg_file_mux (.a1(), .a2(mips_instruction[15:11]), .sel(mem2reg), .y(w_data_regfile));




InstrData_memory #(.INSTR_MEM_SIZE(16), .DATA_MEM_SIZE(16)) i_ID_memory
(
	.clk	(CLK	     ),
	.rstn	(RSTn        ),
	.addr   (address     ),
	.we     (mem_write   ),
	.wd     (),
	.rd     (r_data_idmem)
);


register_file i_reg_file 
(
	.clk	(CLK							),
	.rstn	(RSTn							),
	
	.a1		(mips_instruction[25:21]        ),		
	.a2		(mips_instruction[20:16]        ),		
	.a3		(rt_or_rd                       ),
	.we3    (reg_write                      ),
	.wd3    (w_data_regfile                 ),
	.rd1    (),
	.rd2    ()
);

control_unit i_control_unit 
(
    .clk(CLK),
    .rstn(RSTn),
    
    .opcode(),
    .funct(),
    
    .pc_write(pc_write),
    .pc_src(pc_src),
    .branch(branch),
    .mem_write(mem_write),
    .mem_to_reg(mem2reg),
    .reg_dst(reg_dst),
    .reg_write(reg_write),
    .IorD(instr_or_data),
    .ir_write(ir_write),
    .alu_src_A(alu_src_a),
    .alu_src_B(alu_src_b),
    .alu_control(alu_control) 

);


alu i_alu
(
    .srcA(),
    .srcB(),
    .alu_control(),
    .zero_flag(alu_zero),
    .alu_result()
);

sign_extend i_sign_extend
(
	.imm			(	),
	.signImm		()	
);
    
    
    
endmodule
