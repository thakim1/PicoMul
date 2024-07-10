
/*
 *  Implements software to be simulated on in the Verilog testbench tb_software_exec.v
 *
 *  Authors: Marcus Meysel, Karel Rusy, Hakim Tayari
 *  Date: 2024-07-10
 *
 *  Permission to use, copy, modify, and/or distribute this software for any
 *  purpose with or without fee is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHORS DISCLAIM ALL WARRANTIES
 *  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR
 *  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 *  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 *  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 *  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 */

#define approx_mul(a, b, result) __asm__ (".insn r 0xB, 0x0, 0x1, %0, %1, %2" : "=r" (result) : "r" (a), "r" (b))
/*
Breakdown of Makro
    approx_mul(a, b, result) : This is the macro definition. It takes three arguments a, b, and result, and it's used to invoke the approximate multiplication operation.
    __asm___                 : This is a GCC extension used to embed assembly language code within C/C++ code.
    ".insn r                 : This is the inline assembly code. 
    0xB, 0x0, 0x1            : This represents the assembly instruction for approximate multiplication.
    %0, %1, %2               : The placeholders %0, %1, and %2 will be replaced by the registers corresponding to the variables result, a, and b, respectively.
    "=r" (result)            : This the output constraint specifier tells the compiler to expect the output result in a register. The = sign indicates that it's an output, and "r" specifies that any general-purpose register can be used.
    "r" (a)                  : This is the input constraint specifier for variable a. It tells the compiler to expect a in a register.
    "r" (b)                  : Similar to the previous one.
*/

#define normal_add(a, b, result) __asm__ ("add %0, %1, %2" : "=r" (result) : "r" (a), "r" (b))


main () {
  
  printf ("Hello world\n");


  int a = 12;
  int b = 13;
  int result;
  int result2;

  // Perform approximate multiplication
  normal_add(a, b, result);
  approx_mul(a, b, result2);

  // Output the result
  printf("Normal addition result of %d and %d is: %d\n", a, b, result);
  
  printf("Approx mul result of %d and %d is: %d\n", a, b, result2);

}
