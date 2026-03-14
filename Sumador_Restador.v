`timescale 1ns/1ps
`include "Sumador_4b.v"

module Sumador_Restador(

    input  [3:0] A,
    input  [3:0] B,
    input        M,
    output       Co,
    output [3:0] So
);

wire [3:0] B_mod;


assign B_mod[0] = B[0] ^ M;
assign B_mod[1] = B[1] ^ M;
assign B_mod[2] = B[2] ^ M;
assign B_mod[3] = B[3] ^ M;


sumador_4b instancia_S4b (
    .A(A),
    .B(B_mod),
    .Ci(M),      
    .Co(Co),
    .So(So)
);
endmodule
