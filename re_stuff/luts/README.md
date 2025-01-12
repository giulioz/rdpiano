# LUT ROMs
There are two ROMs (IC11 and IC10) that are used as lookup table.
Using those verilog and python scripts, we can investigate their content, and try to fit a function over them.

Uncomment what you need in the verilog and python files, then run `iverilog -g2012 ic8_gen_lut.v ; ./a.out > points.csv; python3 plot.py`.

The ROMs IC11 and IC10 can be perfectly reproduced using an exponential function (see plot.py).

# GA LUTs
Inside the three gate array chips, there are four lookup tables implemented using logic gates.
I still haven't found a way to reproduce them using a mathematical function, but we can easily reproduce their values anyway by evaluating the logic expressions.
