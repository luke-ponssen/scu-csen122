`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/11/2025 06:36:28 PM
// Design Name: 
// Module Name: TwoToOneMux
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


module twoToOneMux (
    input [31:0] in0,       // Input 0
    input [31:0] in1,       // Input 1
    input sel,              // Selection bit
    output reg [31:0] out       // Output
);

//    assign out = sel ? in1 : in0;
    always @(*) begin
        if (sel === 1'bx) begin
            // If the selection bit is unknown ('x'), default to in0
            out = in0;
        end else if (sel == 1'b1) begin
            // If sel is 1, select in1
            out = in1;
        end else begin // sel == 1'b0
            // If sel is 0, select in0
            out = in0;
        end
    end

endmodule
