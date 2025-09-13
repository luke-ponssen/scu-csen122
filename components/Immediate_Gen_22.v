`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/11/2025 06:40:35 PM
// Design Name: 
// Module Name: Immediate_Gen_22
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


module Immediate_Gen_22 (
    input [21:0] imm_in,     // 22-bit immediate from instruction
    output [31:0] imm_out    // 32-bit sign-extended immediate
);
    assign imm_out = {{10{imm_in[21]}}, imm_in};  // Sign-extend to 32 bits
endmodule
