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

def approxadd1(a:int, b:int, cin:int):
    # approxadd_4
    result = b
    cout = a

    return limitlen(result, 1), limitlen(cout, 1)

if __name__ == "__main__": 
    path = os.path.join('approxadd_data.txt') # change this to your prefered path
    with open(path, 'w') as file:
        for i in range(2**3): # generates truth table for 1 bit approx adder
            cin = (i & 0b100) >> 2
            b = (i & 0b010) >> 1
            a = i & 0b001
            out, cout = approxadd1(a, b, cin)
            data = f'{a:b}{b:b}{cin:b}{out:b}{cout:b}\n'
            file.write(data)
