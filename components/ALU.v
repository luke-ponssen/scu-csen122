`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/11/2025 07:04:51 PM
// Design Name: 
// Module Name: ALU
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


module ALU (
    input wire [31:0] A,
    input wire [31:0] B,
    input wire ADD,
    input wire NEG,
    input wire SUB,

    output reg [31:0] Result,
    output wire Zero,
    output wire Neg
);

    always @(*) begin
        case ({ADD, NEG, SUB})
            3'b000: Result = B + A;       // ADD
            3'b110: Result = -B;          // NEG
            3'b101: Result = B - A;       // SUB
            3'b010: Result = 32'b0;       // NO OP (don't care)
            3'b111: Result = A;           // PASS A
            default: Result = 32'b0;      // Undefined cases
        endcase
    end

    assign Zero = (Result == 32'b0) ? 1'b1 : 1'b0;
    assign Neg  = Result[31];  // MSB is 1 if result is negative in 2's complement

endmodule
