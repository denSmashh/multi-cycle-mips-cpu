`timescale 1ns / 1ns

module testbench_multicycle_mips();

logic clk,rstn;
cpu_top i_cpu_top (.CLK(clk), .RSTn(rstn));
    
// instruction and data memory reset (all memory 0x0)
integer i;
initial begin
    for(i = 0; i < ( i_cpu_top.i_ID_memory.INSTR_MEM_SIZE + i_cpu_top.i_ID_memory.DATA_MEM_SIZE); i = i + 1) 
        i_cpu_top.i_ID_memory.instr_and_data_memory[i] = 0;
end
    
// register file reset (all registers 0x0)
initial begin
    for(i = 0; i < 32; i = i + 1) 
        i_cpu_top.i_reg_file.mem_reg[i] = 0;
end
       
  
    // load machine code
initial begin
    i_cpu_top.i_ID_memory.instr_and_data_memory[0] = 'h20030080;    // addi 0x0 0x3 0b0000000010000000    (write decimal 128 in register $3   )
    i_cpu_top.i_ID_memory.instr_and_data_memory[1] = 'h2004000F;    // addi 0x0 0x4 0b0000000000001111  (write decimal 16  in register $4   )
    i_cpu_top.i_ID_memory.instr_and_data_memory[2] = 'hAC040010;    // sw   0x0 0x4 0b0000000000010000    (store in mem[0x00+0x10] register $4  )   
    i_cpu_top.i_ID_memory.instr_and_data_memory[3] = 'h8C050010;    // lw   0x5 0x0 0b0000000000000000    (write in register $5 mem[0x0+0x10]  )
    i_cpu_top.i_ID_memory.instr_and_data_memory[4] = 'h10A40003;    // beq  0x4 0x5 0x0003 (if $4 == $5, branch in 3 steps; *true condition)
    i_cpu_top.i_ID_memory.instr_and_data_memory[5] = 'h00000000;    // nop (no operations)
    i_cpu_top.i_ID_memory.instr_and_data_memory[6] = 'h10A40003;    //  (instruction #4)
    i_cpu_top.i_ID_memory.instr_and_data_memory[7] = 'h10640010;    // beq (if $3 == $4, branch in 16 steps; *false condition)
    i_cpu_top.i_ID_memory.instr_and_data_memory[8] = 'h00000000;    // nop (no operations)
end
    
    
initial clk = 0;
initial rstn = 1;
    
always #5 clk = ~clk;    

initial i_cpu_top.pc = 'b0;
    
initial begin
rstn = 0; #5; rstn = 1;

          
end
    
    
endmodule
    
