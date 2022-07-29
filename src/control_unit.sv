module control_unit (
    
    input logic clk,
    input logic rstn,
    
    input logic	[5:0] 	opcode,
    input logic [5:0]   funct,
    
    output logic        pc_write,
    output logic        pc_src,
    output logic        branch,
    output logic        mem_write,
    output logic        reg_write,
    output logic        IorD,
    output logic        ir_write,
    output logic        alu_src_A,
    output logic [1:0]  alu_src_B,
    output logic [2:0]  alu_control
    
);
    
    
    
endmodule
