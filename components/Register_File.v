`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/11/2025 06:08:13 PM
// Design Name: 
// Module Name: Register_File
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


module Register_File (
    input clk,
    input regWrite,                // Enable signal for writing
    input [5:0] rs,                // Source register 1 address
    input [5:0] rt,                // Source register 2 address
    input [5:0] rd,                // Destination register address
    input [31:0] writeData,       // Data to be written to rd
    output reg [31:0] rsOut,      // Output data from rs
    output reg [31:0] rtOut       // Output data from rt
);

    // 64 registers, 32-bit each
    reg [31:0] registers [0:63];

    // Initialize all registers to 0 at start
    integer i;
    initial begin
        for (i = 0; i < 64; i = i + 1)begin
            registers[i] = 32'b0;
        end
        
        registers[1] = 32'd2;     // x1 = base address of array a
        registers[2] = 32'd5;     // x2 = problem size n
        
        // Registers for branching
        registers[20] = 32'd44;   // ADD x10, x6, x10
        registers[21] = 32'd35;   // ADD x6,x5,x0
        registers[22] = 32'd39;   // INC x3,x3,1
        registers[23] = 32'd10;    // SUB x7,x3,x2

    end

    // Read logic (combinational)
    always @(*) begin
        rsOut = registers[rs];
        rtOut = registers[rt];
    end

    // Write logic (sequential)
    always @(posedge clk) begin
        if (regWrite)
            registers[rd] <= writeData;
    end

endmodule