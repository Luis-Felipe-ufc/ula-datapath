`timescale 1ns/10ps
module mux2 (
    input  logic [7:0] w_rd2,        // Entrada 1
    input  logic [7:0] constante,        // Entrada 2
    input  logic select_src,         // Bit de seleção
    output logic [7:0] w_SrcB       // Saída mux
);

    always_comb begin
        case (select_src)
            1'b0: w_SrcB <= w_rd2;
            1'b1: w_SrcB <= constante; 
            default: w_SrcB <= w_SrcB;
        endcase
    end

endmodule