	.global _main
_main:
	// Establish a stack pointer
	adrp	x9, stack_top
	add	 x9, x9, :lo12:stack_top
	mov	 sp, x9

	// Save all of the entry registers to callee saved registers.
	// These can be cut down when the bootloader interface is
	// defined
	mov	 x19, x0
	mov	 x20, x1
	mov	 x21, x2
	mov	 x22, x3
	mov	 x23, x4
	mov	 x24, x5
	mov	 x25, x6
	mov	 x26, x7

	// Don't trap on use of NEON and floating point feature
	//msr	 cptr_el3, xzr
	//msr	 cptr_el3, xzr

	mov	 x1, #(0x3 << 20)
	msr	 cpacr_el1, x1
	isb

	// Off to the main Rustland
	bl	main
0:	b	0b

	.pushsection	.bss,"aw",@progbits
	.align  16
	.space  4096
stack_top:
	.popsection
