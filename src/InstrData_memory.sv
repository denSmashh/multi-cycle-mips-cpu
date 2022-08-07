module InstrData_memory 
#(parameter INSTR_MEM_SIZE = 32, DATA_MEM_SIZE  = 32)
(
    input logic clk,
    input logic rstn,
    
    input logic [31:0]  addr,
    input logic         we,   
    input logic [31:0]  wd,
    
    output logic [31:0] rd

);
    
logic [31:0] instr_and_data_memory [INSTR_MEM_SIZE + DATA_MEM_SIZE];
 
always @ (posedge clk) begin  // write in memory
    if(~rstn) begin     // reset only data memory
        for(int i = INSTR_MEM_SIZE; i < INSTR_MEM_SIZE + DATA_MEM_SIZE; i = i + 1) instr_and_data_memory [i] <= 32'b0;
    end
    
    else begin
        if(we) instr_and_data_memory[addr] <= wd; 
    end   
 end   
  
assign rd = instr_and_data_memory[addr];  // read from memory
    
endmodule
