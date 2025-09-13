`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/10/2025 03:30:19 PM
// Design Name: 
// Module Name: Instruction_Memory
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

module Instruction_Memory(
    input wire [31:0] address,         // Byte address from PC
    output wire [31:0] instruction     // Fetched instruction
);

    reg [31:0] memory [0:255];           // 256-word instruction memory (1 KB)
    integer i;
    
    initial begin
        for(i=0; i<256; i=i+1)begin
            memory[i] = 32'h00000000;
        end

        // Initialize with example instructions (replace with real ones)
//        memory[0] = 32'h51C00003; // INC x7, x0, 3
//        memory[1] = 32'h00000000; // NOP
//        memory[2] = 32'h00000000; // NOP
//        memory[3] = 32'h00000000; // NOP
//        memory[4] = 32'h41872000; // ADD x6, x7, x8
//        memory[5] = 32'h41545400; // ADD x5, x20, x21
//        memory[6] = 32'h90050000; // BRZ x5
        // Add more instructions if needed
        
        // MIN PROGRAM
        memory[0] = 32'b0101_000011_000000_000000_0000000000; // INC x3,x0,0
        memory[1] = 32'b0100_000100_000001_000011_0000000000; // ADD x4,x1,x3
        memory[2] = 32'b0000_000000_000000_000000_0000000000; // NOP
        memory[3] = 32'b0000_000000_000000_000000_0000000000; // NOP
        memory[4] = 32'b0000_000000_000000_000000_0000000000; // NOP
        memory[5] = 32'b1110_000110_000100_000000_0000000000; // LD x6,x4
        memory[6] = 32'b0000_000000_000000_000000_0000000000; // NOP
        memory[7] = 32'b0000_000000_000000_000000_0000000000; // NOP
        memory[8] = 32'b0000_000000_000000_000000_0000000000; // NOP
        memory[9] = 32'b0101_000011_000011_000000_0000000001; // INC x3,x3,1
        memory[10] = 32'b0000_000000_000000_000000_0000000000; // NOP
        memory[11] = 32'b0000_000000_000000_000000_0000000000; // NOP
        memory[12] = 32'b0000_000000_000000_000000_0000000000; // NOP
        memory[13] = 32'b0111_000111_000010_000011_0000000000; // SUB x7,x2,x3
        memory[14] = 32'b1001_000000_010100_000000_0000000000; // BRZ x20 (assuming x20 is the target address for branch)
        memory[15] = 32'b0000_000000_000000_000000_0000000000; // NOP
        memory[16] = 32'b0000_000000_000000_000000_0000000000; // NOP
        memory[17] = 32'b0000_000000_000000_000000_0000000000; // NOP
        memory[18] = 32'b0100_000100_000001_000011_0000000000; // ADD x4,x1,x3
        memory[19] = 32'b0000_000000_000000_000000_0000000000; // NOP
        memory[20] = 32'b0000_000000_000000_000000_0000000000; // NOP
        memory[21] = 32'b0000_000000_000000_000000_0000000000; // NOP
        memory[22] = 32'b1110_000101_000100_000000_0000000000; // LD x5,x4
        memory[23] = 32'b0000_000000_000000_000000_0000000000; // NOP
        memory[24] = 32'b0000_000000_000000_000000_0000000000; // NOP
        memory[25] = 32'b0000_000000_000000_000000_0000000000; // NOP
        memory[26] = 32'b0111_001000_000110_000101_0000000000; // SUB x8,x6,x5
        memory[27] = 32'b1011_000000_010101_000000_0000000000; // BRN x21 (assuming x21 is the target address for branch)
        memory[28] = 32'b0000_000000_000000_000000_0000000000; // NOP
        memory[29] = 32'b0000_000000_000000_000000_0000000000; // NOP
        memory[30] = 32'b0000_000000_000000_000000_0000000000; // NOP
        memory[31] = 32'b1000_000000_010110_000000_0000000000; // J x22 (assuming x22 is the target address for jump)
        memory[32] = 32'b0000_000000_000000_000000_0000000000; // NOP
        memory[33] = 32'b0000_000000_000000_000000_0000000000; // NOP
        memory[34] = 32'b0000_000000_000000_000000_0000000000; // NOP
        memory[35] = 32'b0100_000110_000101_000000_0000000000; // ADD x6,x5,x0
        memory[36] = 32'b0000_000000_000000_000000_0000000000; // NOP
        memory[37] = 32'b0000_000000_000000_000000_0000000000; // NOP
        memory[38] = 32'b0000_000000_000000_000000_0000000000; // NOP
        memory[39] = 32'b0101_000011_000011_000000_0000000001; // INC x3,x3,1
        memory[40] = 32'b1000_000000_010111_000000_0000000000; // J x23 (assuming x23 is the target address for jump)
        memory[41] = 32'b0000_000000_000000_000000_0000000000; // NOP
        memory[42] = 32'b0000_000000_000000_000000_0000000000; // NOP
        memory[43] = 32'b0000_000000_000000_000000_0000000000; // NOP
        memory[44] = 32'b0100_001010_000110_001010_0000000000; // ADD x10, x6, x10
        memory[45] = 32'b0000_000000_000000_000000_0000000000; // NOP
        memory[46] = 32'b0000_000000_000000_000000_0000000000; // NOP
        memory[47] = 32'b0000_000000_000000_000000_0000000000; // NOP


    end

    assign instruction = memory[address];

endmodule