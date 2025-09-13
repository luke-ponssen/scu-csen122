`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/11/2025 06:56:57 PM
// Design Name: 
// Module Name: ID_EX
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

module IDEX(
    input wire clk,

    // Inputs
    input wire regWrite,
    input wire memToReg,
    input wire [31:0] IFIDPC,
    input wire Jump,
    input wire JumpMem,
    input wire MemWrite,
    input wire MemRead,
    input wire BranchNeg,
    input wire BranchZero,
    input wire SavePC,
    input wire [2:0] ALUOp,      // ALUOp is 3 bits
    input wire ALUSrc,
    input wire [31:0] readDataRs,
    input wire [31:0] readDataRt,
    input wire [31:0] immediate,
    input wire [5:0] rd,

    // Outputs
    output reg regWriteEX,
    output reg memToRegEX,
    output reg [31:0] PCEX,
    output reg JumpEX,
    output reg JumpMemEX,
    output reg MemWriteEX,
    output reg MemReadEX,
    output reg BranchNegEX,
    output reg BranchZeroEX,
    output reg SavePCEX,
    output reg [2:0] ALUOpEX,
    output reg ALUSrcEX,
    output reg [31:0] rsEX,
    output reg [31:0] rtEX,
    output reg [31:0] immediateEX,
    output reg [5:0] rdEX
);

//    initial begin
//        regWriteEX = 0;
//        memToRegEX = 0;
//        PCEX = 0;
//        JumpEX = 0;
//        JumpMemEX = 0;
//        MemWriteEX = 0;
//        MemReadEX = 0;
//        BranchNegEX = 0;
//        BranchZeroEX = 0;
//        SavePCEX = 0;
//        ALUOpEX = 3'b000;
//        ALUSrcEX = 0;
//        rsEX = 0;
//        rtEX = 0;
//        immediateEX = 0;
//        rdEX = 0;
//    end

    always @(posedge clk) begin
        regWriteEX <= regWrite;
        memToRegEX <= memToReg;
        PCEX <= IFIDPC;
        JumpEX <= Jump;
        JumpMemEX <= JumpMem;
        MemWriteEX <= MemWrite;
        MemReadEX <= MemRead;
        BranchNegEX <= BranchNeg;
        BranchZeroEX <= BranchZero;
        SavePCEX <= SavePC;
        ALUOpEX <= ALUOp;
        ALUSrcEX <= ALUSrc;
        rsEX <= readDataRs;
        rtEX <= readDataRt;
        immediateEX <= immediate;
        rdEX <= rd;
    end

endmodule

