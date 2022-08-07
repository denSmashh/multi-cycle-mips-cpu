module cpu_top (

     input logic CLK,
     input logic RSTn
     
);

//alu wires
logic alu_zero;

// control unit wires
logic pc_write;
logic branch;
logic alu_src_a;
logic reg_write;
logic instr_or_data;
logic mem_write;
logic ir_write;
logic mem2reg;
logic reg_dst;
logic [1:0] pc_src;
logic [2:0] alu_control;
logic [1:0] alu_src_b; 

// another wires
logic [31:0] address;
logic [31:0] sign_imm;
logic [4:0] rt_or_rd;
logic [31:0] w_data_regfile;
logic [31:0] alu_src_a_wire;
logic [31:0] alu_src_b_wire;

logic pc_en;
assign pc_en = (alu_zero & branch) | pc_write;

logic [31:0] pc;
logic [31:0] pc_next;
register_en #(.DW(32)) i_pc_reg (.clk(CLK), .rstn(RSTn), .en(pc_en), .d(pc_next), .q(pc));

logic [31:0] r_data_idmem;
logic [31:0] mips_instruction; 
register_en #(.DW(32)) i_instruction_reg (.clk(CLK), .rstn(RSTn), .en(ir_write), .d(r_data_idmem), .q(mips_instruction));

logic [31:0] data_mem;
register #(.DW(32)) i_data_mem_reg (.clk(CLK), .rstn(RSTn), .d(r_data_idmem), .q(data_mem));

logic [31:0] r_data1_regfile;
logic [31:0] r_data2_regfile;
logic [31:0] reg_rd1;
logic [31:0] reg_rd2;
register #(.DW(32)) i_regfile_rd1_reg (.clk(CLK), .rstn(RSTn), .d(r_data1_regfile), .q(reg_rd1));
register #(.DW(32)) i_regfile_rd2_reg (.clk(CLK), .rstn(RSTn), .d(r_data2_regfile), .q(reg_rd2));

logic [31:0] alu_result;
logic [31:0] alu_out;
register #(.DW(32)) i_alu_result_reg (.clk(CLK), .rstn(RSTn), .d(alu_result), .q(alu_out));

mux_2 #(.DW(32)) i_instr_or_data_mux (.a1(pc), .a2(alu_out), .sel(instr_or_data), .y(address));
mux_2 #(.DW(5) ) i_rt_or_rd_mux (.a1(mips_instruction[20:16]), .a2(mips_instruction[15:11]), .sel(reg_dst), .y(rt_or_rd));
mux_2 #(.DW(32)) i_write_reg_file_mux (.a1(alu_out), .a2(data_mem), .sel(mem2reg), .y(w_data_regfile));
mux_2 #(.DW(32)) i_alu_src_a_mux (.a1(pc), .a2(reg_rd1), .sel(alu_src_a), .y(alu_src_a_wire));

mux_4 #(.DW(32)) i_alu_src_b_mux (.a1(reg_rd2), .a2('b1), .a3(sign_imm), .a4(sign_imm), .sel(alu_src_b), .y(alu_src_b_wire));
mux_4 #(.DW(32)) i_alu_result_mux (.a1(alu_result), .a2(alu_out), .a3({pc[31:26],mips_instruction[25:0]}), .a4('b0), .sel(pc_src), .y(pc_next));


InstrData_memory #(.INSTR_MEM_SIZE(16), .DATA_MEM_SIZE(16)) i_ID_memory
(
	.clk(CLK),
	.rstn(RSTn),
	.addr(address),
	.we(mem_write),
	.wd(reg_rd2),
	.rd(r_data_idmem)
);


register_file i_reg_file 
(
	.clk(CLK),
	.rstn(RSTn),
	
	.a1(mips_instruction[25:21]),		
	.a2(mips_instruction[20:16]),		
	.a3(rt_or_rd),
	.we3(reg_write),
	.wd3(w_data_regfile),
	.rd1(r_data1_regfile),
	.rd2(r_data2_regfile)
);

control_unit i_control_unit 
(
    .clk(CLK),
    .rstn(RSTn),
    
    .opcode(mips_instruction[31:26]),
    .funct(mips_instruction[5:0]),
    
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
    .srcA(alu_src_a_wire),
    .srcB(alu_src_b_wire),
    .alu_control(alu_control),
    .zero_flag(alu_zero),
    .alu_result(alu_result)
);

sign_extend i_sign_extend
(
	.imm(mips_instruction[15:0]),
	.signImm(sign_imm)	
);
    
     
endmodule
