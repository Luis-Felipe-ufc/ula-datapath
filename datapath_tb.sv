`timescale 1ns/10ps
module datapath_tb;
  logic [7:0] wd3, y;
  logic [7:0] constante = 1;
  logic [2:0] wa3, ra1, ra2, op;
  logic clk, reset, we3, co, zero, s;
  int qtd_testes;
  int verif_count = 0;          // Conta quantas verificações
  
  // instantiating the module to map connections
  datapath dtp(.clk(clk), .reset(reset), .wd3(wd3), .wa3(wa3), 
  .we3(we3), .ra1(ra1), .ra2(ra2), .constante(constante), .select_src(s),
  .ULAControl(op), .ULAResult(y), .CarryOut(co), .Flag_z(zero)
  );

  // Geração do clock
  initial clk = 0;
  always #5 clk = ~clk; // Clock com período de 10 ns

  // Variação s
  initial s = 0;
  always #20 
  s = ~s; // Período de 40 ns

  // Reset inicial
  initial begin
  generate_reset (1);
  end

  initial begin
    we3 = 1;
    wa3 = 1;
    wd3 = 5;
    ra1 = 1;
    ra2 = 0;

    // Espera gravar tudo
    #200;
    // Define quantos testes vão ser realizados
    qtd_testes = 99999;

    // Testa soma
    op = 3'b000;
    repeat(qtd_testes) begin
      #11;
      assert(y == dtp.w_rd1SrcA + dtp.w_SrcB) verif_count++; else $fatal;
    end
    // Testa reset
    generate_reset (1);
    s = 0;              // Garante que o operando venha do registrador
    #1;
    assert(y == 0) verif_count++; else $fatal;
    #10;

    // Testa subtração
    op = 3'b001;
    repeat(qtd_testes) begin
      #11;
      assert(y == dtp.w_rd1SrcA - dtp.w_SrcB) verif_count++; else $fatal;
    end
    // Testa reset
    generate_reset (1);
    s = 0;              // Garante que o operando venha do registrador
    #1;
    assert(y == 0) verif_count++; else $fatal;
    #10;

    // Testa AND
    op = 3'b010;
    repeat(qtd_testes) begin
      #11;
      assert(y == (dtp.w_rd1SrcA & dtp.w_SrcB)) verif_count++; else $fatal;
    end
    // Testa reset
    generate_reset (1);
    s = 0;              // Garante que o operando venha do registrador
    #1;
    assert(y == 0) verif_count++; else $fatal;
    #10;

    // Testa OR
    op = 3'b011;
    repeat(qtd_testes) begin
      #11;
      assert(y == (dtp.w_rd1SrcA | dtp.w_SrcB)) verif_count++; else $fatal;
    end
    // Testa reset
    generate_reset (1);
    s = 0;              // Garante que o operando venha do registrador
    #1;
    assert(y == 0) verif_count++; else $fatal;
    #10;

    // Testa se a < b
    op = 3'b101;
    repeat(qtd_testes) begin
      #11;
      if (dtp.w_rd1SrcA < dtp.w_SrcB) assert(y) verif_count++; else $fatal;
      else assert(!y) verif_count++; else $fatal;
    end
    // Testa reset
    generate_reset (1);
    s = 0;              // Garante que o operando venha do registrador
    #1;
    assert(y == 0) verif_count++; else $fatal;
    $display("A simulação foi concluída sem erros. Foram realizados %0d testes específicos.", verif_count);
    $finish();
  end

  // Executa um reset (padrão 1)
  task automatic generate_reset(input int duration);
    begin
      reset = 0;
      #duration;
      reset = 1; 
    end
  endtask

  // Cria um valor randomico a cada intervalo de tempo
  task automatic generate_rand(output logic [7:0] variavel, input int atraso);
    begin
      variavel = $urandom; //& tamanho;  // tamanho: 8'hFF ou 4'hF ou 2'b11....
      #atraso;
    end
  endtask //automatic
  
  always generate_rand (wd3, 10);         // Cria valores aleatorios para wd3 a cada 10ns
  always generate_rand (wa3, 10);         // Cria valores aleatorios para wd3 a cada 10ns
  always generate_rand (ra1, 10);         // Cria valores aleatorios para ra1 a cada 10ns
  always generate_rand (ra2, 10);         // Cria valores aleatorios para ra2 a cada 10ns
  always generate_rand (constante, 10);   // Cria valores aleatorios para constante a cada 10ns

endmodule
