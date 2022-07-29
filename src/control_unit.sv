module control_unit (
    
    input logic clk,
    input logic rstn,
    
    input logic	[5:0] 	opcode,
    input logic [5:0]   funct,
    
    output logic        pc_write,
    output logic        pc_src,
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
    MEM_WRITE, EXEC, 
    ALU_WRITEBACK,
    BRANCH,
    ADDI_EXEC,
    ADDI_WRITEBACK
  } state_t;

state_t state;
state_t next_state;
 
 always @ (posedge clk) begin
    if(~rstn)
    else begin
    
    end
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
