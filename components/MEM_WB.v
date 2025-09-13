`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/11/2025 08:27:11 PM
// Design Name: 
// Module Name: MEM_WB
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


module MEMWB(
    input wire clk,

    // Inputs
    input wire regWriteMEM,
    input wire memToRegMEM,
    input wire zeroMEM,
    input wire negMEM,
    input wire [31:0] memDataOut,
    input wire [31:0] AluResultsMEM,
    input wire [5:0] rdMEM,

    // Outputs
    output reg regWriteWB,
    output reg memToRegWB,
    output reg zeroWB,
    output reg negWB,
    output reg [31:0] memDataOutWB,
    output reg [31:0] AluResultsWB,
    output reg [5:0] rdWB
);

//    initial begin
//        regWriteWB = 0;
//        memToRegWB = 0;
//        zeroWB = 0;
//        negWB = 0;
//        memDataOutWB = 0;
//        AluResultsWB = 0;
//        rdWB = 0;
//    end

    always @(posedge clk) begin
        regWriteWB <= regWriteMEM;
        memToRegWB <= memToRegMEM;
        zeroWB <= zeroMEM;
        negWB <= negMEM;
        memDataOutWB <= memDataOut;
        AluResultsWB <= AluResultsMEM;
        rdWB <= rdMEM;
    end

endmodule

