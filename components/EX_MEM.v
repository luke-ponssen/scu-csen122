`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/11/2025 07:41:39 PM
// Design Name: 
// Module Name: EX_MEM
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


module EXMEM(
    input wire clk,

    // Inputs
    input wire regWriteEX,
    input wire memToRegEX,
    input wire JumpEX,
    input wire JumpMemEX,
    input wire MemWriteEX,
    input wire MemReadEX,
    input wire BranchNegEX,
    input wire BranchZeroEX,
    input wire Z,                  // Zero flag from ALU
    input wire N,                  // Neg flag from ALU
    input wire [31:0] ALUSrc1,
    input wire [31:0] ALUResult,
    input wire [31:0] rtEX,
    input wire [5:0] rdEX,

    // Outputs
    output reg regWriteMEM,
    output reg memToRegMEM,
    output reg JumpMEM,
    output reg JumpMemMEM,
    output reg MemWriteMEM,
    output reg MemReadMEM,
    output reg BranchNegMEM,
    output reg BranchZeroMEM,
    output reg zeroMEM,
    output reg negMEM,
    output reg [31:0] ALUSrc1MEM,
    output reg [31:0] AluResultsMEM,
    output reg [31:0] rtMEM,
    output reg [5:0] rdMEM
);

//    initial begin
//        regWriteMEM = 0;
//        memToRegMEM = 0;
//        JumpMEM = 0;
//        JumpMemMEM = 0;
//        MemWriteMEM = 0;
//        MemReadMEM = 0;
//        BranchNegMEM = 0;
//        BranchZeroMEM = 0;
//        zeroMEM = 0;
//        negMEM = 0;
//        ALUSrc1MEM = 0;
//        AluResultsMEM = 0;
//        rtMEM = 0;
//        rdMEM = 0;
//    end

    always @(posedge clk) begin
        regWriteMEM <= regWriteEX;
        memToRegMEM <= memToRegEX;
        JumpMEM <= JumpEX;
        JumpMemMEM <= JumpMemEX;
        MemWriteMEM <= MemWriteEX;
        MemReadMEM <= MemReadEX;
        BranchNegMEM <= BranchNegEX;
        BranchZeroMEM <= BranchZeroEX;
        zeroMEM <= Z;
        negMEM <= N;
        ALUSrc1MEM <= ALUSrc1;
        AluResultsMEM <= ALUResult;
        rtMEM <= rtEX;
        rdMEM <= rdEX;
    end

endmodule

