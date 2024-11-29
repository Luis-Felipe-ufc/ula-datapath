`timescale 1ns/10ps
module mux2_tb;
  logic [7:0] a, b, y;
  logic s = 0;
  int verif_count = 0;          // Conta quantas verificações

  // instantiating the module to map connections
  mux2 dut(.w_rd2(a), .constante(b), .select_src(s), .w_SrcB(y) 
  );

  always begin
    #1;
    s = ~s;
    a = $urandom;
    b = $urandom;
    #1;
    assert ((s & (y == b)) | (!s & (y == a))) verif_count++; else $fatal;
  end

   initial begin 
    #1ms;
    $display(" Foram feitas %0d verificações.", verif_count);
    $finish();
   end

endmodule
