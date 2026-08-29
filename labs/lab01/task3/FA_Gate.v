module FA_Gate(
  input  a,
  input  b,
  input  cin,
  output sum,
  output cout
);
  wire ps, pc1, pc2;

  xor #(2,3) (ps,  a,   b);
  and #(2,3) (pc1, a,   b);
  xor #(2,3) (sum, cin, ps);
  and #(2,3) (pc2, cin, ps);
  or  #(2,3) (cout, pc1, pc2);


endmodule
