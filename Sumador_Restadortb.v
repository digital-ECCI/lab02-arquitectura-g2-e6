`timescale 1ns/1ps
`include "Sumador_Restador.v"

module SR4b_tb;

    reg  [3:0] A;
    reg  [3:0] B;
    reg        M; 

    wire       Co;
    wire [3:0] So;

    integer i, j, k;

    Sumador_Restador DUT (
        .A(A),
        .B(B),
        .M(M),
        .Co(Co),
        .So(So)
    );

    initial begin

        $dumpfile("SR4b_tb.vcd");
        $dumpvars(0, SR4b_tb);

        $display("Tiempo | M |   A     B   |  So    Co ");
        $display("------------------------------------------------");

        for (k = 0; k < 2; k = k + 1) begin          
            for (i = 0; i < 16; i = i + 1) begin     
                for (j = 0; j < 16; j = j + 1) begin 

                    M = k;
                    A = i;
                    B = j;

                    #10;

                    $display(" %4t  | %b | %b  %b | %b   %b",
                              $time, M, A, B, So, Co);

                end
            end
        end

        $finish;
    end

endmodule
