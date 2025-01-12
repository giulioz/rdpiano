# Cycles IC19
0:  set O16
1:  reset O39, store adder result
2:  
3:  store adder result
4:  read values from RIC12 and RIC13
5:  read values from RIC12 and RIC13, store adder result
6:  read values from RIC12(bit 0) and RIC13
7:  do stuff with output to IPT, save adder1 result to then output to RIC13, store value from ric12 cycle4/5 and 6(bit 0) again, store adder result
8:  store current 3-10 ric12 address (part+voice) to be read when IRQ is fired
9:  write to ic12 from cpu, store adder result
10: write to ic12 from cpu (cont)
11: store adder result
12: 
13: store adder result
14: 
15: store adder result

## RIC12 Address Counter
0:  RIC12 Read
1:  RIC12 Read
2:  RIC12 Read
3:  RIC12 Read
4:  RIC12 Read
5:  RIC12 Read
6:  RIC12 Read
7:  RIC12 Read

8:  RIC12 Read
9:  RIC12 Write
10: RIC12 Write
11: RIC12 Read
12: RIC12 Read, RIC13 Out adder 0-7
13: RIC12 Read, RIC13 Out adder 16-23
14: RIC12 Read, RIC13 Out adder 8-15
15: RIC12 Read, RIC13 Out adder 24-27
