"""
Author: SteBaj
Date: 2024-07-10
Description: This script implements a 16-bit approximate multiplier for use in LDIS. 
             It includes various modules for generating test data and performing approximate multiplications. 
             Each module can be executed independently to generate test data, and the golden model combines 
             these modules to perform and verify approximate multiplications.
             GitHub: https://github.com/SteBaj/LDISPython
"""
from helperfunctions import *

def approxmul2(a0:int, a1:int, b0:int, b1:int):
    #
    #
    # put your implementation here
    #
    #
    out = 0
    out = set_bit(out, 0, a0 & b0)
    out = set_bit(out, 1, (a0 & b1) ^ (a1 & b0))
    out = set_bit(out, 2, a1 & b1)
    out = set_bit(out, 3, a1 & b1)
    return out

if __name__ == "__main__": 
    path = 'approxmul2_data.txt' # change this to your prefered path
    with open(path, 'w') as file:
        for i in range(2**4): # generates truth table for 2 bit approx multiplier
            b1 = (i & 0b1000) >> 3
            b0 = (i & 0b0100) >> 2
            a1 = (i & 0b0010) >> 1
            a0 = i & 0b0001
            out = approxmul2(a0, a1, b0, b1)
            data = f'{a1:b}{a0:b}{b1:b}{b0:b}{out:04b}\n'
            file.write(data)