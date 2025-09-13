`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/11/2025 08:13:56 PM
// Design Name: 
// Module Name: Data_Memory
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


module Data_Memory(
    input wire clock,
    input wire MemReadMEM,           // 1-bit: Enable reading
    input wire MemWriteMEM,          // 1-bit: Enable writing
    input wire [31:0] ALUSrc1MEM,    // 32-bit: Address to read/write
    input wire [31:0] rtMEM,         // 32-bit: Data to write

    output reg [31:0] memDataOut     // 32-bit: Data read from memory
);

    // Define memory space: 1024 words of 32 bits each
    reg [31:0] memory [0:1023];

    integer i;
    initial begin
        // Optional: initialize memory to 0
        for (i = 0; i < 1024; i = i + 1) begin
            memory[i] = 32'b0;
        end
        
        memory[2] = 32'd31;
        memory[3] = 32'd1024;
        memory[4] = 32'd9;
        memory[5] = -32'd2048;
        memory[6] = 32'd10;
    end

    always @(posedge clock) begin
        if (MemWriteMEM) begin
            memory[ALUSrc1MEM] <= rtMEM;
        end
    end

    always @(*) begin
        if (MemReadMEM) begin
            memDataOut = memory[ALUSrc1MEM];
        end else begin
            memDataOut = 32'b0;
        end
    end

endmodule

