## Digital Integrated Circuits Lab - SS 2024

Useful links: 
+ [Official Picorv32 Repo](https://github.com/YosysHQ/picorv32)
+ [Fork Picorv32 Repo](https://github.com/sevjaeg/picorv32/tree/master)
+ [Hardware Mockup](mockup.pdf)
+ [FPGA Documentation](https://docs.icebreaker-fpga.org/hardware/icebreaker/)

# What's it about? 

We developed a parametrizable approximate multiplier unit for the picoSoC based on the picoRV32 RISC-V core. 
Modifying the low level implementations of the 1bit adder and 2bit multiplier allows for a number of design tradeoffs. 
You choose! 

# Verification and Performance Evaluation
To verify the correct behavior of the multiplier, 500 random number pairs are generated for the inputs a and b.
In the first step, the 2x2 approx_mul is overwritten with a 2x2 accu_mul, and N4,N8,N16 are all set to 0. After
verifying that the results are correct for this "fully accurate" version, the following combination of hyperparameters
are tested: (with the 2x2 approx_mul back in place)
+ N4=0, N8=0, N16=0
+ N4=8, N8=0, N16=0
+ N4=0, N8=8, N16=0
+ N4=0, N8=0, N16=8
+ N4=4, N8=8, N16=16
+ N4=0, N8=16, N16=0
+ N4=0, N8=0, N16=32
+ N4=8, N8=16, N16=32

The same 500 number pairs are also run through the Golden Model (Python implementation) and the outputs are compared.
All 4000 tested values are identical and deemed sufficient for verification.
The used files are stored in the "Verification" sub-directory.

Additionally, the relative error of the approximated result compared to the accurate multiplication is calculated
for each of those 8 parameters configurations and visualized here:

![verif](https://github.com/thakim1/PicoMul/assets/88373056/df4e5f1e-4e30-4b0b-b657-4adae656a7b8)

The underwhelming performance originates from the very crude low-level implementation of the approximate Fulladder. 
However, as mentioned changing the 2bit multiplier or the 1bit adder can significantly change the results. 
The goal was to evaluate the accuracy for the currently used low level adder/mutliplier combination.

# License
Copyright (c) 2024 Karel Rusy, Hakim Tayari, Marcus Meysel

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

# Acknolwedgements 
Team: [Karel](https://github.com/KarelRusy), [Marcus](https://github.com/marcus-meysel), me 

Special thanks to [Stefan](https://github.com/SteBaj/LDISPython) and [Christian](https://github.com/christian-krieg) for providing us with the golden model for verification and for their support. 

