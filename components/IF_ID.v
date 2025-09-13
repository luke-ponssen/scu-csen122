`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/10/2025 04:19:56 PM
// Design Name: 
// Module Name: IF_ID
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


module IFID(
    input wire clk,
    input wire [31:0] instruction_in,
    input wire [31:0] pc_in,
    output reg [31:0] instruction_out,
    output reg [31:0] pc_out
);

//    initial begin
//        instruction_out = 32'b0;
//        pc_out = 32'b0;
//    end

    always @(posedge clk) begin
        instruction_out = instruction_in;
        pc_out = pc_in;
    end

endmodule
