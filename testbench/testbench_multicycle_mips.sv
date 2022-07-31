`timescale 1ns / 1ns

module testbench_multicycle_mips();

cpu_top i_cpu_top 
(

);
 
 
 
    
// instruction and data memory reset (all memory 0x0)
    integer i;
    initial begin
        //for(i = 0; i < 32; i = i + 1) 
                //.instr_and_data_memory[i] = 0;
    end
    
    // register file reset (all registers 0x0)
    initial begin
        //for(i = 0; i < 32; i = i + 1) 
                //.mem_reg[i] = 0;
    end
    
    
    /*
    // load machine code
    initial begin
            i_cpu.i_instr_mem.mem[0] = 'h20030080;        // addi 0x0 0x3 0b0000000010000000    (write decimal 128 in register $3   )
            i_cpu.i_instr_mem.mem[1] = 'h2004000F;        // addi 0x0 0x4 0b0000000000001111  (write decimal 16  in register $4   )
            i_cpu.i_instr_mem.mem[2] = 'hAC040000;        // sw   0x0 0x4 0b0000000000000000    (store in mem[0x0+0x0] register $4  )   
            i_cpu.i_instr_mem.mem[3] = 'h8C050000;        // lw   0x5 0x0 0b0000000000000000    (write in register $5 mem[0x0+0x0]  )
            i_cpu.i_instr_mem.mem[4] = 'h10830010;        // beq  0x4 0x5 0x000c (if $4 == $5, branch in 12 steps; *true condition)
            i_cpu.i_instr_mem.mem[5] = 'h00000000;        // nop (no operations)
            i_cpu.i_instr_mem.mem[6] = 'h00000000;        // nop (no operations)
            i_cpu.i_instr_mem.mem[7] = 'h10A4000C;        // beq (if $4 == $3, branch in 128 steps; *false condition)
    end
    */
    

    
    
initial begin

          
end
    
    
endmodule
    
