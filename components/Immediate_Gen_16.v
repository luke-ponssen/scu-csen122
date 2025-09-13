`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/11/2025 06:40:46 PM
// Design Name: 
// Module Name: Immediate_Gen_16
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


module Immediate_Gen_16 (
    input [15:0] imm_in,     // 16-bit immediate from instruction
    output [31:0] imm_out    // 32-bit sign-extended immediate
);
    assign imm_out = {{16{imm_in[15]}}, imm_in};  // Sign-extend to 32 bits
endmodule
