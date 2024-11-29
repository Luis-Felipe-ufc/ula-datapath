`timescale 1ns/10ps
module ula (
    input  logic [7:0] SrcA,        // Operando A
    input  logic [7:0] SrcB,        // Operando B
    input  logic [2:0] ULAControl,  // Código da operação
    output logic [7:0] ULAResult,   // Resultado da operação
    output logic Flag_z,            // Flag zero
    output logic CarryOut           // Flag de estouro
);

    logic [8:0] PartialResult;

    assign CarryOut = PartialResult[8];
    assign ULAResult = PartialResult[7:0];
    
    always_comb begin
        case (ULAControl)
            3'b000: PartialResult = SrcA + SrcB;            // Soma
            3'b001: PartialResult = SrcA - SrcB;            // Subtração
            3'b010: PartialResult = SrcA & SrcB;            // AND
            3'b011: PartialResult = SrcA | SrcB;            // OR
            3'b101: PartialResult = (SrcA < SrcB) ? 1 : 0;  // Comparação
            default: PartialResult = 9'h00;                 // Operação inválida
        endcase
        Flag_z = (PartialResult == 0); // Define a flag zero
    end

endmodule

