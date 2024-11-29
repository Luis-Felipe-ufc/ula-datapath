`timescale 1ns/10ps
module ula_tb;
  logic [7:0] a, b, y;
  logic [2:0] op;
  logic zero, co;
  int qtd_testes;           // Quantos testes deseja realizar
  int testes_feitos = 0;    // Quantos testes foram realizados

  ula dut(.SrcA(a), .SrcB(b), .ULAResult(y), .ULAControl(op),
  .Flag_z(zero), .CarryOut(co));

  // Teste fundamental
  initial begin
    $display("Teste básico das operações da ULA:");
    $display("-------------------------------------------------------------------------------------");
    a = 8'd200;
    b = 8'd100;
    op = 3'b000;
    #1;
    $display("Soma com carry out:\ta = %0b\tb = %0b\tCarry out = %b\ty = %b\tFlag zero = %0b", a, b, co, y, zero);
    $display("-------------------------------------------------------------------------------------");
    #5;
    a = 8'd5;
    b = 8'd8;
    op = 3'b001;
    #1;
    $display("Subtração com carry out:\ta = %0d\tb = %0d\tCarry out = %b\ty = %d\tFlag zero = %0b", a, b, co, y, zero);
    $display("-------------------------------------------------------------------------------------");
    #5;
    a = 8'b11110101;
    b = 8'b11101010;
    op = 3'b010;
    #1;
    $display("Operação AND entre a e b:\ta = %b\tb = %b\ty = %b\tFlag zero = %0b", a, b, y, zero);
    $display("-------------------------------------------------------------------------------------");
    #5;
    a = 8'b10111001;
    b = 8'b10000110;
    op = 3'b011;
    #1;
    $display("Operação OR entre a e b:\ta = %b\tb = %b\ty = %b\tFlag zero = %0b", a, b, y, zero);
    $display("-------------------------------------------------------------------------------------");
    #5;
    a = 3;
    b = 5;
    op = 3'b101;
    #1;
    $display("a é menor que b? (1 para sim, 0 para não):\ta = %0d\tb = %0d\ty = %0d\tFlag zero = %0b", a, b, y, zero);
    $display("-------------------------------------------------------------------------------------");
    #5;
    a = 120;
    b = 150;
    op = 3'b101;
    #5;
    a = 120;
    b = 110;
    op = 3'b111;
    #1;
    $display("Erro: Seleção de operação inválida.\ta = %0d\tb = %0d\top = %b  y = %0d\tFlag zero = %0b", a, b, op, y, zero);
    $display("-------------------------------------------------------------------------------------");
    $display("Testes básicos finalizados. Iniciando testes automáticos e exaustivos...");
    $display("-------------------------------------------------------------------------------------");
  end

  // Testes automáticos e exaustivos
  initial begin
    #37;                // Espera tempo para finalizar os testes básicos
    qtd_testes = 999999;    // Define quantos testes serão realizados para cada operação

    // Testa soma
    op = 3'b000;
    repeat(qtd_testes) begin
      generate_rand;
      assert(y == a + b) testes_feitos++; else $fatal;
    end

    // Testa subtração
    op = 3'b001;
    repeat(qtd_testes) begin
      generate_rand;
      assert(y == a - b) testes_feitos++; else $fatal;
    end

    // Testa AND
    op = 3'b010;
    repeat(qtd_testes) begin
      generate_rand;
      assert(y == (a & b)) testes_feitos++; else $fatal;
    end

    // Testa OR
    op = 3'b011;
    repeat(qtd_testes) begin
      generate_rand;
      assert(y == (a | b)) testes_feitos++; else $fatal;
    end

    // Testa se a < b
    op = 3'b101;
    repeat(qtd_testes) begin
      generate_rand;
      if (a < b) assert(y) testes_feitos++; else $fatal;
      else assert(!y) testes_feitos++; else $fatal;
    end

    // Testa operação inválida
    repeat(qtd_testes) begin
      op = $urandom_range(3'b111, 3'b100);
      #1;
      if (op != 3'b101) assert(!y) testes_feitos++; else $fatal;
    end

    // Testa o flag zero
    repeat(qtd_testes) begin
      op = $urandom;
      generate_rand;
      if (!y & !co) assert(zero) testes_feitos++; else $fatal;
      else assert(!zero) testes_feitos++; else $fatal;
    end

    // Finaliza os testes
    $display("==================================================================================");
    $display("A simulação foi concluída sem erros. Foram realizados %0d testes específicos.", testes_feitos);
    $display("==================================================================================");
  end

// Gera valores aleatórios para a e b
  task automatic generate_rand();
    begin
      a = $urandom;
      b = $urandom;
      #5;
    end
  endtask

endmodule