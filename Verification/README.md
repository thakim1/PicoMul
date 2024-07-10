# 16 bit approx. multiplier

This python scripts implements the 16 bit approximate multiplier to be implemented in LDIS. It can be used to understand how it is supposed to work and in the makefile to verify the results of your implementation.

Each module is implementated in its own python file, which, when executed explicitly, generate their own test data as a .txt file. All these files are generated with binary numbers with no formating or spacing between the numbers.
While this may be hard to read, its easier to evaluate in the automated testing.

[approxadd1.py](approxadd1.py) and [approxmul2.py](approxmul2.py) generate a truth table, [approxaddN](approxaddN.py) and the [golden model](goldenmodel.py) generate random tests instead.

The [golden model](goldenmodel.py) combines all modules into the golden model of the 16 bit approximate multiplier, and when executed generates a configurable number of random number pairs and the approximate multiplication results, saving them in a .txt file. When called, it must be given either 4 or 5 launch arguments:
- test vector size 
- N16 
- N8 
- N4 
- optional: filename modifier 

Example: 

    python goldenmodel.py 3 2 1

The [helper functions](helperfunctions.py) file contains some helpful bit operations and the function to generate the random test vectors.