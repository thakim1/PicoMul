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
from approxadd1 import *

def approxaddN(a:int, b:int, N:int): 
    cin = [0] * (N+1)
    out = [0] * N
    cin[0] = 0
    for i in range(N):
        out[i], cin[i+1] = approxadd1(get_bit(a,i), get_bit(b,i), cin[i])
    approxRes = binary_array_to_int(out)
    return ((a >> N) << N) + ((b >> N) << N) + cin[N] * 2**N + approxRes

if __name__ == "__main__": 
    test_vec_size = 100
    bits_approx = 2
    in1, in2 = generate_input_vectors(test_vec_size, 8)
    path = os.path.join('Verification', 'approxaddN_data.txt') # modify this to your prefered path
    with open(path, 'w') as file:
        for i in range(test_vec_size):
            result = approxaddN(in1[i], in2[i], bits_approx)
            result = limitlen(result, 8)    
            data = f'{in1[i]:08b}_{in2[i]:08b}_{result:08b}\n'
            file.write(data)
