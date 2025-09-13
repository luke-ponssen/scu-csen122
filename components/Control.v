`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/10/2025 04:29:48 PM
// Design Name: 
// Module Name: Control
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Control (
    input wire [31:0] IFIDInstruction,
    output reg       regWrite,
    output reg       memToReg,
    output reg       Jump,
    output reg       JumpMem,
    output reg       MemWrite,
    output reg       MemRead,
    output reg       BranchNeg,
    output reg       BranchZero,
    output reg       SavePC,
    output reg [2:0] ALUOp,
    output reg       ALUSrc
);

    wire [3:0] opcode;

    assign opcode = IFIDInstruction[31:28]; // Extract opcode 

    always @(*) begin
        // Default assignments to avoid latches and for unused signals
        regWrite = 1'b0;
        memToReg = 1'b0;
        Jump = 1'b0;
        JumpMem = 1'b0;
        MemWrite = 1'b0;
        MemRead = 1'b0;
        BranchNeg = 1'b0;
        BranchZero = 1'b0;
        SavePC = 1'b0;
        ALUOp = 3'bxxx; // Don't care initially
        ALUSrc = 1'b0;

        case (opcode)
            4'b0000: begin // NOP 
                // All outputs remain at their default (0 or don't care)
            end
            4'b1111: begin // SVPC 
                regWrite = 1'b1;
                SavePC = 1'b1;
                ALUOp = 3'b000; // Add (PC + immediate) 
                ALUSrc = 1'b1; // Immediate is the second operand 
            end
            4'b1110: begin // LD 
                regWrite = 1'b1;
                memToReg = 1'b1;
                MemRead = 1'b1;
                ALUOp = 3'b000; // ALU for address calculation (base + offset if any, though not explicit in LD in table 9) 
                ALUSrc = 1'b0; // Second operand is register 
            end
            4'b0011: begin // ST 
                MemWrite = 1'b1;
                ALUOp = 3'b000; // ALU for address calculation 
                ALUSrc = 1'b0; // Second operand is register 
            end
            4'b0100: begin // ADD 
                regWrite = 1'b1;
                ALUOp = 3'b000; // Add 
                ALUSrc = 1'b0; // Second operand is register 
            end
            4'b0101: begin // INC 
                regWrite = 1'b1;
                ALUOp = 3'b000; // Add (register + immediate) 
                ALUSrc = 1'b1; // Immediate is the second operand 
            end
            4'b0110: begin // NEG 
                regWrite = 1'b1;
                ALUOp = 3'b110; // Negate (-B) 
                ALUSrc = 1'b0; // Not applicable for a single operand ALU op, or pass A/B as needed. Assuming it passes the input to ALU. 
            end
            4'b0111: begin // SUB 
                regWrite = 1'b1;
                ALUOp = 3'b101; // Subtract 
                ALUSrc = 1'b0; // Second operand is register 
            end
            4'b1000: begin // J 
                Jump = 1'b1;
            end
            4'b1010: begin // JM 
                JumpMem = 1'b1;
            end
            4'b1001: begin // BRZ 
                BranchZero = 1'b1;
            end
            4'b1011: begin // BRN 
                BranchNeg = 1'b1;
            end
            // 4'b0001: begin // MIN (if implemented, refer to its specific logic) 
            //    regWrite = 1'b1;
            //    ...
            // end
            default: begin
                // Handle unsupported opcodes or treat as NOP
            end
        endcase
    end

endmodule
