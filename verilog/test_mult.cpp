#include <stdio.h>

unsigned int boolean_network(
  unsigned int net_in_a, // 4 bit
  unsigned int net_in_b  // 13 bit
) {
  bool net_in_a_0 = (net_in_a >> 0) & 1;
  bool net_in_a_1 = (net_in_a >> 1) & 1;
  bool net_in_a_2 = (net_in_a >> 2) & 1;
  bool net_in_a_3 = (net_in_a >> 3) & 1;
  
  bool net_in_b_0 = (net_in_b >> 0) & 1;
  bool net_in_b_1 = (net_in_b >> 1) & 1;
  bool net_in_b_2 = (net_in_b >> 2) & 1;
  bool net_in_b_3 = (net_in_b >> 3) & 1;
  bool net_in_b_4 = (net_in_b >> 4) & 1;
  bool net_in_b_5 = (net_in_b >> 5) & 1;
  bool net_in_b_6 = (net_in_b >> 6) & 1;
  bool net_in_b_7 = (net_in_b >> 7) & 1;
  bool net_in_b_8 = (net_in_b >> 8) & 1;
  bool net_in_b_9 = (net_in_b >> 9) & 1;
  bool net_in_b_10 = (net_in_b >> 10) & 1;
  bool net_in_b_11 = (net_in_b >> 11) & 1;
  bool net_in_b_12 = (net_in_b >> 12) & 1;

  bool out_0 = (~net_in_b_6 && ~net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && ~net_in_a_3) || (~net_in_b_5 && net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && ~net_in_a_3) || (net_in_b_4 && ~net_in_a_0 && net_in_a_1 && ~net_in_a_2 && ~net_in_a_3) || (net_in_b_3 && net_in_a_0 && net_in_a_1 && ~net_in_a_2 && ~net_in_a_3) || (net_in_b_2 && ~net_in_a_0 && ~net_in_a_1 && net_in_a_2 && ~net_in_a_3) || (net_in_b_1 && net_in_a_0 && ~net_in_a_1 && net_in_a_2 && ~net_in_a_3) || (net_in_b_0 && ~net_in_a_0 && net_in_a_1 && net_in_a_2 && ~net_in_a_3) || (net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && net_in_a_3 && net_in_a_0 && net_in_a_1 && net_in_a_2 && ~net_in_a_3);
  bool out_1 = (~net_in_b_7 && ~net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && ~net_in_a_3) || (~net_in_b_6 && net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && ~net_in_a_3) || (~net_in_b_5 && ~net_in_a_0 && net_in_a_1 && ~net_in_a_2 && ~net_in_a_3) || (net_in_b_4 && net_in_a_0 && net_in_a_1 && ~net_in_a_2 && ~net_in_a_3) || (net_in_b_3 && ~net_in_a_0 && ~net_in_a_1 && net_in_a_2 && ~net_in_a_3) || (net_in_b_2 && net_in_a_0 && ~net_in_a_1 && net_in_a_2 && ~net_in_a_3) || (net_in_b_1 && ~net_in_a_0 && net_in_a_1 && net_in_a_2 && ~net_in_a_3) || (net_in_b_0 && net_in_a_0 && net_in_a_1 && net_in_a_2 && ~net_in_a_3);
  bool out_2 = ~(~((~net_in_b_8 && ~net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && ~net_in_a_3) || (~net_in_b_7 && net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && ~net_in_a_3) || (~net_in_b_6 && ~net_in_a_0 && net_in_a_1 && ~net_in_a_2 && ~net_in_a_3) || (~net_in_b_5 && net_in_a_0 && net_in_a_1 && ~net_in_a_2 && ~net_in_a_3) || (net_in_b_4 && ~net_in_a_0 && ~net_in_a_1 && net_in_a_2 && ~net_in_a_3) || (net_in_b_3 && net_in_a_0 && ~net_in_a_1 && net_in_a_2 && ~net_in_a_3) || (net_in_b_2 && ~net_in_a_0 && net_in_a_1 && net_in_a_2 && ~net_in_a_3) || (net_in_b_1 && net_in_a_0 && net_in_a_1 && net_in_a_2 && ~net_in_a_3)) && ~(net_in_b_0 && ~net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && net_in_a_3));
  bool out_3 = ~(~((~net_in_b_9 && ~net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && ~net_in_a_3) || (~net_in_b_8 && net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && ~net_in_a_3) || (~net_in_b_7 && ~net_in_a_0 && net_in_a_1 && ~net_in_a_2 && ~net_in_a_3) || (~net_in_b_6 && net_in_a_0 && net_in_a_1 && ~net_in_a_2 && ~net_in_a_3) || (~net_in_b_5 && ~net_in_a_0 && ~net_in_a_1 && net_in_a_2 && ~net_in_a_3) || (net_in_b_4 && net_in_a_0 && ~net_in_a_1 && net_in_a_2 && ~net_in_a_3) || (net_in_b_3 && ~net_in_a_0 && net_in_a_1 && net_in_a_2 && ~net_in_a_3) || (net_in_b_2 && net_in_a_0 && net_in_a_1 && net_in_a_2 && ~net_in_a_3)) && ~((net_in_b_1 && ~net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && net_in_a_3) || (net_in_b_0 && net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && net_in_a_3)));
  bool out_4 = ~(~((~net_in_b_10 && ~net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && ~net_in_a_3) || (~net_in_b_9 && net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && ~net_in_a_3) || (~net_in_b_8 && ~net_in_a_0 && net_in_a_1 && ~net_in_a_2 && ~net_in_a_3) || (~net_in_b_7 && net_in_a_0 && net_in_a_1 && ~net_in_a_2 && ~net_in_a_3) || (~net_in_b_6 && ~net_in_a_0 && ~net_in_a_1 && net_in_a_2 && ~net_in_a_3) || (~net_in_b_5 && net_in_a_0 && ~net_in_a_1 && net_in_a_2 && ~net_in_a_3) || (net_in_b_4 && ~net_in_a_0 && net_in_a_1 && net_in_a_2 && ~net_in_a_3) || (net_in_b_3 && net_in_a_0 && net_in_a_1 && net_in_a_2 && ~net_in_a_3)) && ~((net_in_b_2 && ~net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && net_in_a_3) || (net_in_b_1 && net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && net_in_a_3) || (net_in_b_0 && ~net_in_a_0 && net_in_a_1 && ~net_in_a_2 && net_in_a_3) || (0 && net_in_a_0 && net_in_a_1 && ~net_in_a_2 && net_in_a_3)));
  bool out_5 = ~(~((~net_in_b_11 && ~net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && ~net_in_a_3) || (~net_in_b_10 && net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && ~net_in_a_3) || (~net_in_b_9 && ~net_in_a_0 && net_in_a_1 && ~net_in_a_2 && ~net_in_a_3) || (~net_in_b_8 && net_in_a_0 && net_in_a_1 && ~net_in_a_2 && ~net_in_a_3) || (~net_in_b_7 && ~net_in_a_0 && ~net_in_a_1 && net_in_a_2 && ~net_in_a_3) || (~net_in_b_6 && net_in_a_0 && ~net_in_a_1 && net_in_a_2 && ~net_in_a_3) || (~net_in_b_5 && ~net_in_a_0 && net_in_a_1 && net_in_a_2 && ~net_in_a_3) || (net_in_b_4 && net_in_a_0 && net_in_a_1 && net_in_a_2 && ~net_in_a_3)) && ~((net_in_b_3 && ~net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && net_in_a_3) || (net_in_b_2 && net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && net_in_a_3) || (net_in_b_1 && ~net_in_a_0 && net_in_a_1 && ~net_in_a_2 && net_in_a_3) || (net_in_b_0 && net_in_a_0 && net_in_a_1 && ~net_in_a_2 && net_in_a_3)));
  bool out_6 = ~(~((~net_in_b_12 && ~net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && ~net_in_a_3) || (~net_in_b_11 && net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && ~net_in_a_3) || (~net_in_b_10 && ~net_in_a_0 && net_in_a_1 && ~net_in_a_2 && ~net_in_a_3) || (~net_in_b_9 && net_in_a_0 && net_in_a_1 && ~net_in_a_2 && ~net_in_a_3) || (~net_in_b_8 && ~net_in_a_0 && ~net_in_a_1 && net_in_a_2 && ~net_in_a_3) || (~net_in_b_7 && net_in_a_0 && ~net_in_a_1 && net_in_a_2 && ~net_in_a_3) || (~net_in_b_6 && ~net_in_a_0 && net_in_a_1 && net_in_a_2 && ~net_in_a_3) || (~net_in_b_5 && net_in_a_0 && net_in_a_1 && net_in_a_2 && ~net_in_a_3)) && ~((net_in_b_4 && ~net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && net_in_a_3) || (net_in_b_3 && net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && net_in_a_3) || (net_in_b_2 && ~net_in_a_0 && net_in_a_1 && ~net_in_a_2 && net_in_a_3) || (net_in_b_1 && net_in_a_0 && net_in_a_1 && ~net_in_a_2 && net_in_a_3)));
  bool out_7 = ~(~((1 && ~net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && ~net_in_a_3) || (~net_in_b_12 && net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && ~net_in_a_3) || (~net_in_b_11 && ~net_in_a_0 && net_in_a_1 && ~net_in_a_2 && ~net_in_a_3) || (~net_in_b_10 && net_in_a_0 && net_in_a_1 && ~net_in_a_2 && ~net_in_a_3) || (~net_in_b_9 && ~net_in_a_0 && ~net_in_a_1 && net_in_a_2 && ~net_in_a_3) || (~net_in_b_8 && net_in_a_0 && ~net_in_a_1 && net_in_a_2 && ~net_in_a_3) || (~net_in_b_7 && ~net_in_a_0 && net_in_a_1 && net_in_a_2 && ~net_in_a_3) || (~net_in_b_6 && net_in_a_0 && net_in_a_1 && net_in_a_2 && ~net_in_a_3)) && ~((~net_in_b_5 && ~net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && net_in_a_3) || (net_in_b_4 && net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && net_in_a_3) || (net_in_b_3 && ~net_in_a_0 && net_in_a_1 && ~net_in_a_2 && net_in_a_3) || (net_in_b_2 && net_in_a_0 && net_in_a_1 && ~net_in_a_2 && net_in_a_3)));
  bool out_8 = ~(~((0 && ~net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && ~net_in_a_3) || (1 && net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && ~net_in_a_3) || (~net_in_b_12 && ~net_in_a_0 && net_in_a_1 && ~net_in_a_2 && ~net_in_a_3) || (~net_in_b_11 && net_in_a_0 && net_in_a_1 && ~net_in_a_2 && ~net_in_a_3) || (~net_in_b_10 && ~net_in_a_0 && ~net_in_a_1 && net_in_a_2 && ~net_in_a_3) || (~net_in_b_9 && net_in_a_0 && ~net_in_a_1 && net_in_a_2 && ~net_in_a_3) || (~net_in_b_8 && ~net_in_a_0 && net_in_a_1 && net_in_a_2 && ~net_in_a_3) || (~net_in_b_7 && net_in_a_0 && net_in_a_1 && net_in_a_2 && ~net_in_a_3)) && ~((~net_in_b_6 && ~net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && net_in_a_3) || (~net_in_b_5 && net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && net_in_a_3) || (net_in_b_4 && ~net_in_a_0 && net_in_a_1 && ~net_in_a_2 && net_in_a_3) || (net_in_b_3 && net_in_a_0 && net_in_a_1 && ~net_in_a_2 && net_in_a_3)));
  bool out_9 = ~(~((1 && ~net_in_a_0 && net_in_a_1 && ~net_in_a_2 && ~net_in_a_3) || (~net_in_b_12 && net_in_a_0 && net_in_a_1 && ~net_in_a_2 && ~net_in_a_3) || (~net_in_b_11 && ~net_in_a_0 && ~net_in_a_1 && net_in_a_2 && ~net_in_a_3) || (~net_in_b_10 && net_in_a_0 && ~net_in_a_1 && net_in_a_2 && ~net_in_a_3) || (~net_in_b_9 && ~net_in_a_0 && net_in_a_1 && net_in_a_2 && ~net_in_a_3) || (~net_in_b_8 && net_in_a_0 && net_in_a_1 && net_in_a_2 && ~net_in_a_3) || (~net_in_b_7 && ~net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && net_in_a_3) || (~net_in_b_6 && net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && net_in_a_3)) && ~((~net_in_b_5 && ~net_in_a_0 && net_in_a_1 && ~net_in_a_2 && net_in_a_3) || (net_in_b_4 && net_in_a_0 && net_in_a_1 && ~net_in_a_2 && net_in_a_3)));
  bool out_10 = ~(~((1 && net_in_a_0 && net_in_a_1 && ~net_in_a_2 && ~net_in_a_3) || (~net_in_b_12 && ~net_in_a_0 && ~net_in_a_1 && net_in_a_2 && ~net_in_a_3) || (~net_in_b_11 && net_in_a_0 && ~net_in_a_1 && net_in_a_2 && ~net_in_a_3) || (~net_in_b_10 && ~net_in_a_0 && net_in_a_1 && net_in_a_2 && ~net_in_a_3) || (~net_in_b_9 && net_in_a_0 && net_in_a_1 && net_in_a_2 && ~net_in_a_3) || (~net_in_b_8 && ~net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && net_in_a_3) || (~net_in_b_7 && net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && net_in_a_3) || (~net_in_b_6 && ~net_in_a_0 && net_in_a_1 && ~net_in_a_2 && net_in_a_3)) && ~(~net_in_b_5 && net_in_a_0 && net_in_a_1 && ~net_in_a_2 && net_in_a_3));
  bool out_11 = (1 && ~net_in_a_0 && ~net_in_a_1 && net_in_a_2 && ~net_in_a_3) || (~net_in_b_12 && net_in_a_0 && ~net_in_a_1 && net_in_a_2 && ~net_in_a_3) || (~net_in_b_11 && ~net_in_a_0 && net_in_a_1 && net_in_a_2 && ~net_in_a_3) || (~net_in_b_10 && net_in_a_0 && net_in_a_1 && net_in_a_2 && ~net_in_a_3) || (~net_in_b_9 && ~net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && net_in_a_3) || (~net_in_b_8 && net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && net_in_a_3) || (~net_in_b_7 && ~net_in_a_0 && net_in_a_1 && ~net_in_a_2 && net_in_a_3) || (~net_in_b_6 && net_in_a_0 && net_in_a_1 && ~net_in_a_2 && net_in_a_3);
  bool out_12 = (0 && ~net_in_a_0 && ~net_in_a_1 && net_in_a_2 && ~net_in_a_3) || (1 && net_in_a_0 && ~net_in_a_1 && net_in_a_2 && ~net_in_a_3) || (~net_in_b_12 && ~net_in_a_0 && net_in_a_1 && net_in_a_2 && ~net_in_a_3) || (~net_in_b_11 && net_in_a_0 && net_in_a_1 && net_in_a_2 && ~net_in_a_3) || (~net_in_b_10 && ~net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && net_in_a_3) || (~net_in_b_9 && net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && net_in_a_3) || (~net_in_b_8 && ~net_in_a_0 && net_in_a_1 && ~net_in_a_2 && net_in_a_3) || (~net_in_b_7 && net_in_a_0 && net_in_a_1 && ~net_in_a_2 && net_in_a_3);
  bool out_13 = (1 && ~net_in_a_0 && net_in_a_1 && net_in_a_2 && ~net_in_a_3) || (~net_in_b_12 && net_in_a_0 && net_in_a_1 && net_in_a_2 && ~net_in_a_3) || (~net_in_b_11 && ~net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && net_in_a_3) || (~net_in_b_10 && net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && net_in_a_3) || (~net_in_b_9 && ~net_in_a_0 && net_in_a_1 && ~net_in_a_2 && net_in_a_3) || (~net_in_b_8 && net_in_a_0 && net_in_a_1 && ~net_in_a_2 && net_in_a_3);
  bool out_14 = ~(1 && ~(1 && net_in_a_0 && net_in_a_1 && net_in_a_2 && ~net_in_a_3) && ~(~net_in_b_12 && ~net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && net_in_a_3) && ~(~net_in_b_11 && net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && net_in_a_3) && ~(~net_in_b_10 && ~net_in_a_0 && net_in_a_1 && ~net_in_a_2 && net_in_a_3) && ~(~net_in_b_9 && net_in_a_0 && net_in_a_1 && ~net_in_a_2 && net_in_a_3));
  bool out_15 = ~(~(~net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && net_in_a_3) && ~(~net_in_b_12 && net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && net_in_a_3) && ~(~net_in_b_11 && ~net_in_a_0 && net_in_a_1 && ~net_in_a_2 && net_in_a_3) && ~(~net_in_b_10 && net_in_a_0 && net_in_a_1 && ~net_in_a_2 && net_in_a_3));
  bool out_16 = ~(~(net_in_a_0 && ~net_in_a_1 && ~net_in_a_2 && net_in_a_3) && ~(~net_in_b_12 && ~net_in_a_0 && net_in_a_1 && ~net_in_a_2 && net_in_a_3) && ~(~net_in_b_11 && net_in_a_0 && net_in_a_1 && ~net_in_a_2 && net_in_a_3));
  bool out_17 = ~(~(~net_in_a_0 && net_in_a_1 && ~net_in_a_2 && net_in_a_3) && ~(~net_in_b_12 && net_in_a_0 && net_in_a_1 && ~net_in_a_2 && net_in_a_3));
  bool out_18 = net_in_a_0 && net_in_a_1 && ~net_in_a_2 && net_in_a_3;

  unsigned int out = 0;
  out |= out_0 << 0;
  out |= out_1 << 1;
  out |= out_2 << 2;
  out |= out_3 << 3;
  out |= out_4 << 4;
  out |= out_5 << 5;
  out |= out_6 << 6;
  out |= out_7 << 7;
  out |= out_8 << 8;
  out |= out_9 << 9;
  out |= out_10 << 10;
  out |= out_11 << 11;
  out |= out_12 << 12;
  out |= out_13 << 13;
  out |= out_14 << 14;
  out |= out_15 << 15;
  out |= out_16 << 16;
  out |= out_17 << 17;
  out |= out_18 << 18;
  return out;
}

unsigned int mystery_function(
  unsigned int in_a, // bus[0], upper 4 bit
  unsigned int in_b, // rom, 13 bit
  unsigned int in_c,  // ram, 24 bit
  unsigned int in_d  // bus[2], 8 bit
) {
  unsigned int adder1_a = boolean_network(in_a, in_b); // 19 bit
  // printf("net %d %d = %d\n", in_a, in_b, adder1_a);
  
  unsigned int temp; // 24 bit

  for (int i = 0; i < 8; i++) {
    // printf("temp %x\n", temp);

    bool mult_select = i != 0;
    unsigned int adder1_b = mult_select ? temp : in_c; // 24 bit

    unsigned int adder1 = (adder1_a + adder1_b) & 0xffffff; // 24 bit

    unsigned int adder1_lsb = adder1 & 0xffff;
    unsigned int adder1_msb = (adder1 >> 16) & 0xff;

    unsigned int adder2 = (adder1_msb + in_d); // 8 bit with carry
    bool adder2_carry = adder2 > 0xff;

    temp = adder1_lsb | ((adder2_carry ? adder2 : adder1_msb) << 16);
  }

  return temp;
}

int main() {
  // 41 25 14 02 E0 7E

  // unsigned int temp = 0;
  // for (size_t i = 0; i < 32; i++) {
  //   temp = mystery_function(0x4, 0xCD52, temp, 0x14);
  //   printf("final %x\n", temp);
  // }
  
  for (size_t i = 0; i < 0xF; i++) {
    printf("%x\n", boolean_network(i, 0x1000));
  }
  
  return 0;
}
