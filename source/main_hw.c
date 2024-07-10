/*
 *  PicoSoC - A simple example SoC using PicoRV32
 *
 *  Copyright (C) 2017  Claire Xenia Wolf <claire@yosyshq.com>
 *
 *  Permission to use, copy, modify, and/or distribute this software for any
 *  purpose with or without fee is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 *  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 *  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 *  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 *  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 *  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 */

/*
  Modified by 
  Authors: Marcus Meysel, Karel Rusy, Hakim Tayari
  Date: 2024-07-10
 */

#include <stdint.h>
#include <stdbool.h>

//#include "../dhrystone/dhry_top.h"

#ifdef ICEBREAKER
#  define MEM_TOTAL 0x3000
#else
#  error "Set -DICEBREAKER or -DHX8KDEMO when compiling firmware.c"
#endif

// a pointer to this is a null pointer, but the compiler does not
// know that because "sram" is a linker symbol from sections.lds.
extern uint32_t sram;

#define reg_spictrl (*(volatile uint32_t*)0x02000000)
#define reg_uart_clkdiv (*(volatile uint32_t*)0x02000004)
#define reg_uart_data (*(volatile uint32_t*)0x02000008)
#define reg_leds (*(volatile uint32_t*)0x03000000)

#define normal_add(a, b, result) __asm__ ("add %0, %1, %2" : "=r" (result) : "r" (a), "r" (b))
// The makro for using the approx_mul:
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

void putchar(char c)
{
	if (c == '\n')
		putchar('\r');
	reg_uart_data = c;
}

void print(const char *p)
{
	while (*p)
		putchar(*(p++));
}

void print_dec(uint32_t v)
{
	if (v >= 1000) {
		print(">=1000");
		return;
	}

	if      (v >= 900) { putchar('9'); v -= 900; }
	else if (v >= 800) { putchar('8'); v -= 800; }
	else if (v >= 700) { putchar('7'); v -= 700; }
	else if (v >= 600) { putchar('6'); v -= 600; }
	else if (v >= 500) { putchar('5'); v -= 500; }
	else if (v >= 400) { putchar('4'); v -= 400; }
	else if (v >= 300) { putchar('3'); v -= 300; }
	else if (v >= 200) { putchar('2'); v -= 200; }
	else if (v >= 100) { putchar('1'); v -= 100; }

	if      (v >= 90) { putchar('9'); v -= 90; }
	else if (v >= 80) { putchar('8'); v -= 80; }
	else if (v >= 70) { putchar('7'); v -= 70; }
	else if (v >= 60) { putchar('6'); v -= 60; }
	else if (v >= 50) { putchar('5'); v -= 50; }
	else if (v >= 40) { putchar('4'); v -= 40; }
	else if (v >= 30) { putchar('3'); v -= 30; }
	else if (v >= 20) { putchar('2'); v -= 20; }
	else if (v >= 10) { putchar('1'); v -= 10; }

	if      (v >= 9) { putchar('9'); v -= 9; }
	else if (v >= 8) { putchar('8'); v -= 8; }
	else if (v >= 7) { putchar('7'); v -= 7; }
	else if (v >= 6) { putchar('6'); v -= 6; }
	else if (v >= 5) { putchar('5'); v -= 5; }
	else if (v >= 4) { putchar('4'); v -= 4; }
	else if (v >= 3) { putchar('3'); v -= 3; }
	else if (v >= 2) { putchar('2'); v -= 2; }
	else if (v >= 1) { putchar('1'); v -= 1; }
	else putchar('0');
}

char getchar_prompt(char *prompt)
{
	int32_t c = -1;

	uint32_t cycles_begin, cycles_now, cycles;
	__asm__ volatile ("rdcycle %0" : "=r"(cycles_begin));

	reg_leds = ~0;

	if (prompt)
		print(prompt);

	while (c == -1) {
		__asm__ volatile ("rdcycle %0" : "=r"(cycles_now));
		cycles = cycles_now - cycles_begin;
		if (cycles > 12000000) {
			if (prompt)
				print(prompt);
			cycles_begin = cycles_now;
			reg_leds = ~reg_leds;
		}
		c = reg_uart_data;
	}

	reg_leds = 0;
	return c;
}

char getchar()
{
	return getchar_prompt(0);
}



void main()
{
	//reg_leds = 31;
	reg_uart_clkdiv = 104;

	//reg_leds = 63;
	//set_flash_qspi_flag();
	
	while (getchar_prompt("ENTER to continue..\n") != '\r') { /* wait */ }
	
	
	uint32_t  a = 5;
    uint32_t  b = 3;
	uint32_t  result;
	uint32_t  result2;
	

	while (1) {
		
			
    	normal_add(a, b, result);
		approx_mul(a, b, result2);
		printf("Normal addition result of %d and %d is: %d\n", a, b, result);
		
		printf("Approx mul result of %d and %d is: %d\n", a, b, result2);
		while (getchar_prompt("ENTER to continue..\n") != '\r') { /* wait */ }
		a+=2;
		b+=3;
	}
	
	return;
}