"""
Author: SteBaj
Date: 2024-07-10
Description: This script implements a 16-bit approximate multiplier for use in LDIS. 
             It includes various modules for generating test data and performing approximate multiplications. 
             Each module can be executed independently to generate test data, and the golden model combines 
             these modules to perform and verify approximate multiplications.
             GitHub: https://github.com/SteBaj/LDISPython
"""

import os
from sys import argv
import random

from helperfunctions import *
from approxadd1 import *
from approxaddN import *
from approxmul2 import *

test_vec_size = 100
n16=13
n8=14
n4=3

'''
4 or 5 arguments must be given when launching the script: 
test vector size, N16, N8 and N4 and optionally a filename modifier; 
argv[0] is reserved
''' 
filenamemodifier = ""
if len(argv) == 5: 
    test_vec_size = int(argv[1])
    n16=int(argv[2])
    n8=int(argv[3])
    n4=int(argv[4])
    print("Input parameters received\n")

if len(argv) == 6:
    test_vec_size = int(argv[1])
    n16=int(argv[2])
    n8=int(argv[3])
    n4=int(argv[4])
    filenamemodifier = argv[5]
    print("Input parameters and filename received\n")


N_ = {16: n16, 8: n8, 4: n4}

def approxmulN(a:int, b:int, N:int):
    if N % 2 != 0:
        raise ValueError("N is odd, this shouldn't happen")
    if a.bit_length()>N or b.bit_length()>N:
            print("\n here\n")
            print(a, b)
            raise ValueError("Values too long!")
    a0, a1 = split_bits(a, int(N/2))
    b0, b1 = split_bits(b, int(N/2))
    if N == 2:
        
        return approxmul2(a0, a1, b0, b1)
    
    HH = approxmulN(a1, b1, int(N/2))
    HH = HH << int(N)

    HL = approxmulN(a1, b0, int(N/2))
    HL = HL << int(N/2)

    LH = approxmulN(a0, b1, int(N/2))
    LH = LH << int(N/2)

    LL = approxmulN(a0, b0, int(N/2))
    LL = LL

    LL_LH = limitlen(approxaddN(LL, LH, N_[N]), 2*N)
    HL_HH = limitlen(approxaddN(HL, HH, N_[N]), 2*N)
    result = limitlen(approxaddN(LL_LH, HL_HH, N_[N]), 2*N)
    return limitlen(result, 32)

if __name__ == "__main__":
    in1, in2 = generate_input_vectors(test_vec_size, 16)
    path = os.path.join('approxmulN_data' + filenamemodifier + '.txt') # modify this to your prefered path
    with open(path, 'w') as file:
        for i in range(test_vec_size):
            result = approxmulN(in1[i], in2[i], 16)
            data = f'{in1[i]:016b}{in2[i]:016b}{result:032b}\n'
            file.write(data)


