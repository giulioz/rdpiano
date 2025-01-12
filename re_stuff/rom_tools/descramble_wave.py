import math
import matplotlib.pyplot as plt

file1_path = 'RD200_IC5_desc.bin'
file2_path = 'RD200_IC6_desc.bin'
file3_path = 'RD200_IC7_desc.bin'
# file1_path = 'MK80_IC5_desc.bin'
# file2_path = 'MK80_IC6_desc.bin'
# file3_path = 'MK80_IC7_desc.bin'

array5 = []
array6 = []
array7 = []

def invert_bits(num):
  return (
    ((num >> 0) & 1) << 0 |
    ((~num >> 1) & 1) << 1 |
    ((num >> 2) & 1) << 2 |
    ((~num >> 3) & 1) << 3 |
    ((num >> 4) & 1) << 4 |
    ((~num >> 5) & 1) << 5 |
    ((num >> 6) & 1) << 6 |
    ((num >> 7) & 1) << 7 |
    ((~num >> 8) & 1) << 8 |
    ((~num >> 9) & 1) << 9 |
    ((num >> 10) & 1) << 10 |
    ((num >> 11) & 1) << 11 |
    ((num >> 12) & 1) << 12 |
    ((num >> 13) & 1) << 13 |
    ((num >> 14) & 1) << 14 |
    ((num >> 15) & 1) << 15 |
    ((num >> 16) & 1) << 16
  )

def BIT(number, bit_position):
  return (number >> bit_position) & 1


with open(file1_path, 'rb') as file1, open(file2_path, 'rb') as file2, open(file3_path, 'rb') as file3:
  array5 = list(file1.read())
  array6 = list(file2.read())
  array7 = list(file3.read())

signs_1 = []
results_1 = []
for i in range(0, len(array5)):
  result = (
      # ((~array7[invert_bits(i)] >> 3) & 1) << 14 |
      ((array5[invert_bits(i)] >> 0) & 1) << 13 |
      ((array6[invert_bits(i)] >> 4) & 1) << 12 |
      ((array7[invert_bits(i)] >> 4) & 1) << 11 |
      ((~array6[invert_bits(i)] >> 0) & 1) << 10 |
      ((array7[invert_bits(i)] >> 7) & 1) << 9 |
      ((array5[invert_bits(i)] >> 7) & 1) << 8 |
      ((~array5[invert_bits(i)] >> 5) & 1) << 7 |
      ((array6[invert_bits(i)] >> 2) & 1) << 6 |
      ((array7[invert_bits(i)] >> 2) & 1) << 5 |
      ((array7[invert_bits(i)] >> 1) & 1) << 4 |
      ((~array5[invert_bits(i)] >> 1) & 1) << 3 |
      ((array5[invert_bits(i)] >> 3) & 1) << 2 |
      ((array6[invert_bits(i)] >> 5) & 1) << 1 |
      ((~array6[invert_bits(i)] >> 7) & 1) << 0
  )
  sign = (~array7[invert_bits(i)] >> 3) & 1
  # result = 0x4000 - result
  # if result <= 0:
  #   result = -result - 0x4000
  # result = 0x4000 - result
  # if sign:
  #   result = -result
  results_1.append(result)
  signs_1.append(sign)

# with open('RD200_descrambled.bin', 'wb') as file:
#   for result in results_1:
#     file.write(result.to_bytes(2, byteorder='little', signed=True))


signs_2 = []
results_2 = []
for i in range(0, len(array5)):
  result = (
      ((~array7[invert_bits(i)] >> 6) & 1) << 8 |
      ((array5[invert_bits(i)] >> 4) & 1) << 7 |
      ((array7[invert_bits(i)] >> 0) & 1) << 6 |
      ((~array6[invert_bits(i)] >> 3) & 1) << 5 |
      ((array5[invert_bits(i)] >> 2) & 1) << 4 |
      ((~array5[invert_bits(i)] >> 6) & 1) << 3 |
      ((array6[invert_bits(i)] >> 6) & 1) << 2 |
      ((array7[invert_bits(i)] >> 5) & 1) << 1 |
      ((~array6[invert_bits(i)] >> 7) & 1) << 0
  )
  sign = (array6[invert_bits(i)] >> 1) & 1
  # result = 0x100 - result
  # if sign:
  #   result = -result
  results_2.append(result)
  signs_2.append(sign)

# plt.plot(results_2)
# plt.show()

# with open('RD200_descrambled.bin', 'wb') as file:
#   for result in results_2:
#     file.write(result.to_bytes(2, byteorder='little', signed=True))

exp_lut = []
with open('../luts/ic8_expdec_table.csv', 'r') as file:
  for line in file:
    exp_lut.append(int(line, 16))
pitch_lut = []
with open('../luts/ic9_phase_table.csv', 'r') as file:
  for line in file:
    pitch_lut.append(int(line, 16))
env_lut = []
with open('../luts/ic19_env_table.csv', 'r') as file:
  for line in file:
    env_lut.append(int(line, 16))


results = []

# for i in range(0, len(results_1)):
#   waverom_pa = results_1[i]
#   waverom_pb = results_2[i]
#   sign_pa = signs_1[i]

#   volume = 0
#   adder_1 = (volume + waverom_pa) & (2**14-1)

#   result = exp_lut[(16384 * sign_pa) + (1024 * (adder_1 >> 10)) + (adder_1 & 1023)]
#   if sign_pa:
#     result = result - 0x8000
#   results.append(result)

addr_table = [0x1e0, 0x080, 0x060, 0x04d, 0x040, 0x036, 0x02d, 0x026, 0x020, 0x01b, 0x016, 0x011, 0x00d, 0x00a, 0x006, 0x003]

# env_dests = [0x93, 0xca, 0xda, 0xd6, 0xcc, 0xba, 0xa9, 0x85, 0x5d, 0x00, 0x00]
# env_speeds = [0xff, 0x78, 0x66, 0xa5, 0xac, 0xa7, 0x9e, 0xa4, 0x9e, 0x93, 0xcf]
env_dests = [0xcb, 0xd3, 0xd2, 0xc5, 0xbb, 0x9d, 0xa5, 0x00]
env_speeds = [0x7f, 0x4a, 0xa9, 0xbd, 0xae, 0xb4, 0x30, 0xcc]

pitch_lut_i = 0x6C00
# pitch_lut_i = 0x1000
wave_addr_loop = 0x10
# wave_addr_loop = 0x00
flag_0 = 0
flag_1 = 0
# wave_addr_high = 1
env_offset = 0xff

for wave_addr_high in range(0, 1):
  sub_phase = 0
  env_value = 0
  env_stage = 0
  irq = False
  for i in range(0, 2048 * 32):
    # ===================================================
    # cpu

    env_dest = env_dests[env_stage]
    env_speed = env_speeds[env_stage]
    if irq:
      env_stage += 1
      if env_stage == len(env_dests):
        print("end")
        break
      print("stage", env_stage, "speed", env_speed, "dest", env_dest)


    # ===================================================
    # ic19
    env_speed_some_high = \
        (BIT(env_speed, 6) or BIT(env_speed, 5) or BIT(env_speed, 4) or BIT(env_speed, 3)) or \
        (BIT(env_speed, 2) or BIT(env_speed, 1) or BIT(env_speed, 0))

    adder1_a = env_value
    if flag_0:
        adder1_a = 1 << 25
    adder1_b = env_lut[env_speed]
    adder1_ci = env_speed_some_high and BIT(env_speed, 7)
    if adder1_ci:
        adder1_b |= 0x7f << 21

    adder3_o = 1 + (adder1_a >> 20) + env_offset
    adder3_of = adder3_o > 0xff
    adder3_o &= 0xff

    volume = ~(((adder1_a >> 14) & 0b111111) | ((adder3_o & 0b1111) << 6) | (((adder3_o & 0b11110000) << 6) if adder3_of else 0)) & 0x3fff

    adder1_o = adder1_a + adder1_b + (1 if adder1_ci else 0)
    adder1_of = adder1_o > 0xfffffff
    adder1_o &= 0xfffffff

    adder2_o = (adder1_o >> 20) + (~env_dest & 0xff) + 1
    adder2_of = adder2_o > 0xff

    end_reached = env_speed_some_high and ((adder1_of != BIT(env_speed, 7)) or (BIT(env_speed, 7) != adder2_of))
    irq = end_reached

    env_value = (env_dest << 20) if end_reached else adder1_o


    # print(volume)
    # print(end_reached)
    # print(env_value)


    # ===================================================
    # ic9
    adder1 = (pitch_lut[pitch_lut_i] + sub_phase) & 0xffffff
    adder2 = 1 + (adder1 >> 16) + ((~wave_addr_loop) & 0xff)
    adder2_co = adder2 > 0xff
    adder2 &= 0xff
    adder1_and = 0 if flag_1 else (adder1 & 0xffff)
    adder1_and |= (0 if flag_1 else (adder2 if adder2_co else (adder1 >> 16))) << 16

    sub_phase = adder1_and
    waverom_addr = (wave_addr_high << 11) | ((sub_phase >> 9) & 0x7ff)

    ag3_sel_sample_type = BIT(waverom_addr, 16) or BIT(waverom_addr, 15) or BIT(waverom_addr, 14) or \
                        not((BIT(waverom_addr, 13) and not BIT(waverom_addr, 11) and not BIT(waverom_addr, 12)) or not BIT(waverom_addr, 13))
    ag1_phase_hi = (
        (BIT(pitch_lut_i, 15) and BIT(pitch_lut_i, 14)) or \
        (BIT(sub_phase, 23) or BIT(sub_phase, 22) or BIT(sub_phase, 21) or BIT(sub_phase, 20)) or \
        flag_1
    )
    

    # ===================================================
    # ic8
    waverom_pa = results_1[waverom_addr]
    waverom_pb = results_2[waverom_addr]
    sign_pa = signs_1[waverom_addr]
    sign_pb = signs_2[waverom_addr]

    waverom_pa |= 1 if ag3_sel_sample_type else 0
    waverom_pb |= 0 if ag3_sel_sample_type else 1

    # volume = (int)((i / (2048 * 16)) * (16384))
    # volume = 0

    if ag1_phase_hi:
      volume |= 0b1111 << 10

    adder1_o = volume + waverom_pa
    adder1_co = adder1_o > 0x3fff
    adder1_o &= 0x3fff
    if adder1_co:
        adder1_o |= 0x3c00
    tmp_1 = adder1_o

    adder3_o = addr_table[(sub_phase >> 5) & 0xf] + (waverom_pb & 0x1ff)
    adder3_of = adder3_o > 0x1ff
    adder3_o &= 0x1ff
    if adder3_of:
        adder3_o |= 0x1e0
    
    adder1_o = volume + (adder3_o << 5)
    adder1_co = adder1_o > 0x3fff
    adder1_o &= 0x3fff
    if adder1_co:
        adder1_o |= 0x3c00
    tmp_2 = adder1_o
    
    exp_val1 = exp_lut[(16384 * sign_pa) + (1024 * (tmp_1 >> 10)) + (tmp_1 & 1023)]
    if sign_pa:
      exp_val1 = exp_val1 - 0x8000
    exp_val2 = exp_lut[(16384 * sign_pb) + (1024 * (tmp_2 >> 10)) + (tmp_2 & 1023)]
    if sign_pb:
      exp_val2 = exp_val2 - 0x8000
    exp_val = exp_val1 + exp_val2
    
    result = exp_val
    results.append(result)


with open('RD200_descrambled.bin', 'wb') as file:
  for result in results:
    file.write(result.to_bytes(2, byteorder='little', signed=True))
