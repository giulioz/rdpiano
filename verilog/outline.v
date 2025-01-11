// IC19
env_speed_some_high = (env_speed_r[6] || env_speed_r[5] || env_speed_r[4] || env_speed_r[3]) &&
                      (env_speed_r[2] || env_speed_r[1] || env_speed_r[0]);
adder1_b_invert = env_speed_some_high && env_speed_r[7];

ad_a = flags[0] ? 0 : env_prev;
ad_a[25] = !ad_a[25];
// ad_a[25] inverted?

// check again
ad_b = exp(env_speed, env_speed_some_high, adder1_b_invert);

// adder1 28-bit
if (adder1_b_invert)
  adder1_co, adder1_o = ad_a + (ad_b | (0x7f << 21)) + 1; // (or << 20?)
else
  adder1_co, adder1_o = ad_a + ad_b;

adder2_co = (adder1_o[27:20] + ~env_dest_r[7:0] + 8'd1) > 9'hFF;
should_fire_irq = env_speed_some_high &
                  ((adder1_co ^ env_speed_r[7]) || (adder2_co ^ env_speed_r[7]));

env_next = should_fire_irq ? env_dest : adder1_o;

// adder3 8-bit
adder3_co, adder3_o = (ad_a >> 20) + env_par_7 + 1;

// 14 bit
volume = (env_next >> 14) & 0x3f | (adder3_o << 6);
// or with ag1_phase_hi?





// IC9
pitch = (config[0] << 8) | config[1];
// adder1 24-bit
adder1_o = exp_pitch_lut(pitch) + phase_prev;
// adder2 8-bit
adder2_co, adder2_o = (adder1_o >> 16) + ~config[2] + 1;
phase_next = !flags[1] && adder1_o;
if (adder2_co)
  phase_next[23:16] = !flags[1] && adder2_o;
waverom_addr = (config[3] << 11) | scramble(phase_next >> 9);

ag3_sel_sample_type = (config[3][16] || config[3][15] || config[3][14] ||
                        (wr_sel_0000 && wr_sel_0800 && wr_sel_1000 && wr_sel_1800 && wr_sel_2000));
ag1_phase_hi = (config[0][7] && config[0][6]) ||
               (phase_next[23] || phase_next[22] || phase_next[21] || phase_next[20]) ||
               flags[1];





// IC8
waverom in => unscramble
  // or the other way around?
  waverom_pa[0] &= ~ag3_sel_sample_type;
  waverom_pb[0] &= ag3_sel_sample_type;

  // adder3, 9 bit
  expdec_lut(phase[8:5]) + waverom_pb[8:0]

  volume[13:10] |= ag1_phase_hi;
  // adder1, 14 bit
  volume + (waverom_pa ?? (adder3 << 5))
    [9:0] => rom10_a[10:1]
    [13:10] => audio output adder2_lut

rom10 in => unscramble => adder2_lut

// adder2, 18 bit
adder2_lut(r10, adder1[13:10], wavein_sign) + (prev ?? 0)

current sample val (18 bit) =>
  discard b0
  not 16 bit, and with b16, b17
  16b latch
  8x16b latches
  not 16 bit (except b15)
  DAC

