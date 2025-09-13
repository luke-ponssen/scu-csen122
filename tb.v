`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/10/2025 03:05:16 PM
// Design Name: 
// Module Name: tb
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


module SCU_ISA_tb();

    //*******************IF STAGE**************************
   
    //PC MUX
    wire [31:0] pcAdder_out;
    wire [31:0] jump_out;
    wire PCSrc;
    wire [31:0] pc_IN;
    twoToOneMux testMux(pcAdder_out, jump_out, PCSrc, pc_IN);

    reg clock;
    initial
    begin
        clock = 0;
        forever #5 clock = ~clock;
    end
   
   //PC
    wire [31:0] instruction_address;
    PC testPC(clock, pc_IN, instruction_address);
   
    //PC + 1
    PC_Adder testPCAdder(instruction_address, pcAdder_out);
   
    //Instruction Memory
    wire [31:0] instruction;
    Instruction_Memory testInstruction(instruction_address, instruction);
   
    //IFID Buffer
    wire [31:0] IFIDInstruction;
    wire [31:0] IFIDPC;
    IFID testIFID(clock, instruction, instruction_address, IFIDInstruction, IFIDPC);
   
    //*******************ID STAGE**************************
   
    //Control Unit
    wire regWrite, memToReg, Jump, JumpMem, MemWrite, MemRead,BranchNeg, BranchZero, SavePC, ALUSrc;
    wire [2:0] ALUOp;
    Control testControl(IFIDInstruction, regWrite, memToReg, Jump, JumpMem, MemWrite, MemRead,BranchNeg, BranchZero, SavePC, ALUOp, ALUSrc);
   
    //Register File
    wire [5:0] rs, rt, rd;
    wire [31:0] writeData, readDataRs, readDataRt;
    assign rs = IFIDInstruction[21:16];
    assign rt = IFIDInstruction[15:10];
    assign rd = IFIDInstruction[27:22];
   
    Register_File testRegFile(clock, regWriteWB, rs, rt, rdWB, writeData, readDataRs, readDataRt);
   
    //immediate generators
    wire [15:0] imme16;
    wire [21:0] imme22;
    wire [31:0] extended16, extended22, immediate;
    assign imme16 = IFIDInstruction[15:0];
    assign imme22 = IFIDInstruction[21:0];
   
    Immediate_Gen_16 testImme16(imme16, extended16);
    Immediate_Gen_22 testImme22(imme22, extended22);
   
    twoToOneMux testImmeMux(extended16, extended22, SavePC, immediate);
   
    wire regWriteEX, memToRegEX, JumpEX, JumpMemEX, MemWriteEX, MemReadEX, BranchNegEX, BranchZeroEX, SavePCEX, ALUSrcEX;
    wire [2:0] ALUOpEX;
    wire [31:0] PCEX, immediateEX, rsEX, rtEX;
    wire [5:0] rdEX;
   
    IDEX testIDEX(clock, regWrite, memToReg, IFIDPC, Jump, JumpMem, MemWrite, MemRead,BranchNeg, BranchZero, SavePC, ALUOp, ALUSrc, readDataRs, readDataRt, immediate, rd,
                    regWriteEX, memToRegEX, PCEX, JumpEX, JumpMemEX, MemWriteEX, MemReadEX, BranchNegEX, BranchZeroEX, SavePCEX, ALUOpEX, ALUSrcEX, rsEX, rtEX, immediateEX, rdEX);

    //*******************EX STAGE**************************
   
    //ALU Mux
    wire [31:0] ALUSrc1, ALUSrc2;
    twoToOneMux testALUSrc1(rsEX, PCEX, SavePCEX, ALUSrc1);
    twoToOneMux testALUSrc2(rtEX, immediateEX, ALUSrcEX, ALUSrc2);
   
    //ALU
    wire Z,N;
    wire add, sub, neg;
    wire [31:0]  ALUResult;
    assign add = ALUOpEX[2];
    assign neg = ALUOpEX[1];
    assign sub = ALUOpEX[0];
    ALU testALU(ALUSrc1, ALUSrc2, add, neg, sub, ALUResult, Z, N);
   
    wire regWriteMEM, memToRegMEM, JumpMEM, JumpMemMEM, MemWriteMEM, MemReadMEM, BranchNegMEM, BranchZeroMEM, zeroMEM, negMEM;
    wire [31:0] ALUSrc1MEM, AluResultsMEM, rtMEM;
    wire [5:0] rdMEM;
   
    EXMEM testEXMEM(clock, regWriteEX, memToRegEX, JumpEX, JumpMemEX, MemWriteEX, MemReadEX, BranchNegEX, BranchZeroEX, Z, N, ALUSrc1, ALUResult, rtEX, rdEX,
                    regWriteMEM, memToRegMEM, JumpMEM, JumpMemMEM, MemWriteMEM, MemReadMEM, BranchNegMEM, BranchZeroMEM, zeroMEM, negMEM, ALUSrc1MEM, AluResultsMEM, rtMEM, rdMEM);  

    //*******************MEM STAGE**************************
   
    //Data memory
    wire [31:0] memDataOut;
    Data_Memory testDM(clock, MemReadMEM, MemWriteMEM, ALUSrc1MEM, rtMEM, memDataOut);
    
    // PCSrc to select whether to branch or not
    assign PCSrc = JumpMEM | ((BranchNegMEM & negWB) | (BranchZeroMEM & zeroWB));
   
    //MUX for JumpMem or ALUSrc
    twoToOneMux testPCOverWrite(ALUSrc1MEM, memDataOut, JumpMemMEM, jump_out);
   
    wire regWriteWB, memToRegWB, zeroWB, negWB;
    wire [31:0] memDataOutWB, AluResultsWB;
    wire [5:0] rdWB;
   
    MEMWB testMEMWB(clock, regWriteMEM, memToRegMEM, zeroMEM, negMEM, memDataOut, AluResultsMEM, rdMEM,
                    regWriteWB, memToRegWB, zeroWB, negWB, memDataOutWB, AluResultsWB, rdWB);
                   
    //*******************WB STAGE**************************
    twoToOneMux testWB(AluResultsWB, memDataOutWB, memToRegWB, writeData);
   
    initial begin
        #3000 $finish; // Run simulation for 3000 ns then stop
    end
   
endmodule