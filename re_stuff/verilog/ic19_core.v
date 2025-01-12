adder1_a = prev_env
if (!IRQ_OUT)
  adder1_a = env_dest << 20
if (env_flag_r_0)
  adder1_a = 1 << 25

env_speed_some_high = (env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0)
adder1_b_invert = env_speed_some_high && env_speed_7
adder1_b = env_lut(env_speed)

if (adder1_b_invert)
  adder1_b = adder1_b | (0x7f << 21)

// 28 bit
adder1_co, adder1_o = adder1_a + adder1_b + adder1_b_invert

// 8 bit
adder3_co, adder3_o = adder1_a[27:20] + env_offset + 1


// VOLUME OUT
// => ric12_a0
~  (adder3_of && adder3_o7)
  ~(adder3_of && adder3_o6)
  ~(adder3_of && adder3_o5)
~  (adder3_of && adder3_o4)
  ~(adder3_o3)
~  (adder3_o2)
  ~(adder3_o1)

// => ~ric12_a0
~  adder3_o0
   env_flag_r_0 || ~prev_env[19]
   env_flag_r_0 || ~prev_env[18]
~~(env_flag_r_0 || ~prev_env[17])
   env_flag_r_0 || ~prev_env[16]
~~(env_flag_r_0 || ~prev_env[15])
   env_flag_r_0 || ~prev_env[14]


// IRQ
// 8 bit
adder2_co, adder2_o = adder1_o[27:20] + ~env_dest + 1
IRQ_OUT = ~env_speed_some_high || ~((adder1_co ^ env_speed_7) || (env_speed_7 ^ adder2_co));
