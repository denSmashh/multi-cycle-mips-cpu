`timescale 1ns / 1ns

`include "cmd.vh"

module fsm_testbench();

logic clk, rstn, pc_write, branch, mem_write, mem_to_reg, reg_dst, reg_write, IorD, ir_write;
logic alu_src_A;
logic [1:0]  pc_src;
logic [1:0]  alu_src_B;
logic [2:0]  alu_control;
logic [5:0]  opcode;
logic [5:0]  funct;

control_unit i_control_unit (
    .clk(clk),
    .rstn(rstn),
    
    .opcode(opcode),
    .funct(funct),
    
    .pc_write(pc_write),
    .pc_src(pc_src),
    .branch(branch),
    .mem_write(mem_write),
    .mem_to_reg(mem_to_reg),
    .reg_dst(reg_dst),
    .reg_write(reg_write),
    .IorD(IorD),
    .ir_write(ir_write),
    .alu_src_A(alu_src_A),
    .alu_src_B(alu_src_B),
    .alu_control(alu_control) 
);

initial rstn = 1;
initial clk = 0;
always #5 clk = ~clk;



initial begin
rstn = 0; #5; rstn = 1;

// INSTRUCTION - LW
opcode = `LW_OP; #50;

// INSTRUCTION - SW
opcode = `SW_OP; #40;          

// INSTRUCTION - R-type
opcode = `R_TYPE_OP; #40;           

// INSTRUCTION - BEQ
opcode = `BEQ_OP; #30;

// INSTRUCTION - ADDI
opcode = `ADDI_OP; #40;

// INSTRUCTION - JUMP
opcode = `JUMP_OP; #30;
   
end


endmodule
