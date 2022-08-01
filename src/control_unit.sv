`include "cmd.vh"

module control_unit (
    
    input logic clk,
    input logic rstn,
    
    input logic	[5:0] 	opcode,
    input logic [5:0]   funct,
    
    output logic        pc_write,
    output logic [1:0]  pc_src,
    output logic        branch,
    output logic        mem_write,
    output logic        mem_to_reg,
    output logic        reg_dst,
    output logic        reg_write,
    output logic        IorD,
    output logic        ir_write,
    output logic        alu_src_A,
    output logic [1:0]  alu_src_B,
    output logic [2:0]  alu_control  
);

logic [1:0] alu_op;    
    
//--------------------- MAIN CONTROLLER (FSM) --------------------//
 typedef enum logic [3:0] 
 { 
    FETCH, 
    DECODE, 
    MEM_ADR, 
    MEM_READ, 
    MEM_WRITEBACK, 
    MEM_WRITE, 
    EXEC, 
    ALU_WRITEBACK,
    BRANCH,
    ADDI_EXEC,
    ADDI_WRITEBACK,
    JUMP
  } state_t;

state_t state;
state_t next_state;
 
 // transition logic
 always @ (posedge clk) begin
    if(~rstn) state <= FETCH;
    else state <= next_state;
 end
 
 //next state logic
 always_comb begin
    case (state)
        FETCH:          next_state <= DECODE;
        
        DECODE: case(opcode)
                    `LW_OP    : next_state <= MEM_ADR;
                    `SW_OP    : next_state <= MEM_ADR;
                    `R_TYPE_OP: next_state <= EXEC;
                    `BEQ_OP   : next_state <= BRANCH;
                    `ADDI_OP  : next_state <= ADDI_EXEC;
                    `JUMP_OP  : next_state <= JUMP;
                    default   : next_state <= FETCH;     
                endcase 
        
        MEM_ADR: case(opcode)
                    `LW_OP:  next_state <= MEM_READ;
                    `SW_OP:  next_state <= MEM_WRITE;
                    default: next_state <= FETCH;
                 endcase
        
        MEM_READ:       next_state <= MEM_WRITEBACK; 
       
        MEM_WRITEBACK:  next_state <= FETCH; 
        
        MEM_WRITE:      next_state <= FETCH;
        
        EXEC:           next_state <= ALU_WRITEBACK;
        
        ALU_WRITEBACK:  next_state <= FETCH;
        
        BRANCH:         next_state <= FETCH;
        
        ADDI_EXEC:      next_state <= ADDI_WRITEBACK;
        
        ADDI_WRITEBACK: next_state <= FETCH;
        
        JUMP:           next_state <= FETCH;
     
        default:        next_state <= FETCH;
        
    endcase 
 end


// output logic
logic [14:0] ctr_signals;
assign {pc_write,mem_write,ir_write,reg_write,
        alu_src_A,branch,IorD,mem_to_reg,reg_dst,
        alu_src_B,pc_src,alu_op} = ctr_signals;
 
 always_comb begin
    case(state) 
        FETCH:          ctr_signals <= 15'b101000000010000;
        DECODE:         ctr_signals <= 15'b000000000110000;
        MEM_ADR:        ctr_signals <= 15'b000010000100000;
        MEM_READ:       ctr_signals <= 15'b000000100000000;
        MEM_WRITEBACK:  ctr_signals <= 15'b000100010000000;
        MEM_WRITE:      ctr_signals <= 15'b010000100000000;
        EXEC:           ctr_signals <= 15'b000010000000010;
        ALU_WRITEBACK:  ctr_signals <= 15'b000100001000000;
        BRANCH:         ctr_signals <= 15'b000011000000101;
        ADDI_EXEC:      ctr_signals <= 15'b000010000100000;
        ADDI_WRITEBACK: ctr_signals <= 15'b000100000000000;
        JUMP:           ctr_signals <= 15'b100000000001000;
        default:        ctr_signals <= 15'b101000000010000;
    endcase
 end
 
  
//---------------------- ALU DECODER ---------------------------//
always_comb begin
 case (alu_op)
    2'b00: alu_control <= `ALU_ADD;
    2'b01: alu_control <= `ALU_SUB;
    default: begin 
        case (funct)
            `ADD_F: alu_control <= `ALU_ADD;
            `SUB_F: alu_control <= `ALU_SUB;
            `AND_F: alu_control <= `ALU_AND;
            `OR_F : alu_control <= `ALU_OR;
            `SLT_F: alu_control <= `ALU_SLT;
           default: alu_control <= `ALU_ADD;
       endcase
    end
 endcase
end
  
endmodule
