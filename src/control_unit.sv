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
        FETCH:          next_state = DECODE;
        
        DECODE: case(opcode)
                    `LW_OP    : next_state = MEM_ADR;
                    `SW_OP    : next_state = MEM_ADR;
                    `R_TYPE_OP: next_state = EXEC;
                    `BEQ_OP   : next_state = BRANCH;
                    `ADDI_OP  : next_state = ADDI_EXEC;
                    `JUMP_OP  : next_state = JUMP;
                    default   : next_state = FETCH;     
                endcase 
        
        MEM_ADR: case(opcode)
                    `LW_OP:  next_state = MEM_READ;
                    `SW_OP:  next_state = MEM_WRITE;
                    default: next_state = FETCH;
                 endcase
        
        MEM_READ:       next_state = MEM_WRITEBACK; 
       
        MEM_WRITEBACK:  next_state = FETCH; 
        
        MEM_WRITE:      next_state = FETCH;
        
        EXEC:           next_state = ALU_WRITEBACK;
        
        ALU_WRITEBACK:  next_state = FETCH;
        
        BRANCH:         next_state = FETCH;
        
        ADDI_EXEC:      next_state = ADDI_WRITEBACK;
        
        ADDI_WRITEBACK: next_state = FETCH;
        
        JUMP:           next_state = FETCH;
     
        default:        next_state = FETCH;
        
    endcase 
 end
 
 //output logic
 always_comb begin
    case(state) 
        FETCH:          begin IorD = 0; alu_src_A = 0; alu_src_B = 2'b01; alu_op = 2'b0; pc_src = 2'b00; end 
        DECODE:         begin alu_src_A = 0; alu_src_B = 2'b11;  alu_op = 2'b0; end
        MEM_ADR:        begin alu_src_A = 1; alu_src_B = 2'b10; alu_op = 2'b0; end
        MEM_READ:       begin IorD = 1; end
        MEM_WRITEBACK:  begin reg_dst = 0; mem_to_reg = 1; end
        MEM_WRITE:      begin IorD = 1; end
        EXEC:           begin alu_src_A = 1; alu_src_B = 2'b0; alu_op = 2'b10; end
        ALU_WRITEBACK:  begin reg_dst = 1; mem_to_reg = 0; end
        BRANCH:         begin alu_src_A = 1; alu_src_B = 2'b0; alu_op = 2'b01; pc_src = 2'b01; end
        ADDI_EXEC:      begin alu_src_A = 1; alu_src_B = 2'b10; alu_op = 2'b0; end
        ADDI_WRITEBACK: begin reg_dst = 0; mem_to_reg = 0; end
        JUMP:           begin pc_src = 2'b10; end
        default:        begin {pc_write, pc_src, branch, mem_write, mem_to_reg, reg_dst, reg_write, IorD, ir_write, alu_src_A, alu_src_B, alu_control} = 'b0; end
    endcase
 end
 
  
//---------------------- ALU DECODER ---------------------------//
always_comb begin
 case (alu_op)
    2'b00: alu_control = `ALU_ADD;
    2'b01: alu_control = `ALU_SUB;
    default: begin 
        case (funct)
            `ADD_F: alu_control = `ALU_ADD;
            `SUB_F: alu_control = `ALU_SUB;
            `AND_F: alu_control = `ALU_AND;
            `OR_F : alu_control = `ALU_OR;
            `SLT_F: alu_control = `ALU_SLT;
       endcase
    end
 endcase
end
  
endmodule
