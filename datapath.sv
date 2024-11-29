`timescale 1ns/10ps
module datapath #(
    parameter DataWidth = 8,
    parameter NumRegs = 8
) (
    input logic clk,        // Clock
    input logic reset,      // Reset assíncrono
    input logic [DataWidth-1:0] wd3,  // Entrada de dados
    input logic [2:0] wa3,  // Seleção do registrador
    input logic [2:0] ULAControl,  // Seleção da operação
    input logic we3,        // Habilita gravação de dados
    input logic select_src, // Seleciona saída do mux
    input logic [DataWidth-1:0] constante,  // Entrada constante
    input logic [2:0] ra1,  // Seleção de qual registrador será disponibilizado na saída rd1
    input logic [2:0] ra2,  // Seleção de qual registrador será disponibilizado na saída rd2
    output logic [DataWidth-1:0] ULAResult,  // Barramento 1 de saída de 8 bits
    output logic Flag_z, // Barramento 2 de saída de 8 bits
    output logic CarryOut // Barramento 2 de saída de 8 bits
);

    // Interconexões entre os módulos
    wire [DataWidth-1:0] w_rd1SrcA, w_rd2, w_SrcB;

    // Instancia o banco de registradores
    banco_reg dut (.clk(clk), .reset(reset), .wd3(wd3), .wa3(wa3), 
    .we3(we3), .ra1(ra1), .ra2(ra2), .rd1(w_rd1SrcA), .rd2(w_rd2)
    );

    // Instancia o mux de 2 entradas
    mux2 mux2(.w_rd2(w_rd2), .constante(constante), .select_src(select_src),
    .w_SrcB(w_SrcB) 
    );

    // Instancia a ULA
    ula ula(.SrcA(w_rd1SrcA), .SrcB(w_SrcB), .ULAResult(ULAResult),
    .ULAControl(ULAControl), .Flag_z(Flag_z), .CarryOut(CarryOut));

endmodule
