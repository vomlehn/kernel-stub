/* Script for -z combreloc: combine and sort reloc sections */
/* Copyright (C) 2014-2019 Free Software Foundation, Inc.
   Copying and distribution of this script, with or without modification,
   are permitted in any medium without royalty provided the copyright
   notice and this notice are preserved.  */

OUTPUT_ARCH(aarch64)
ENTRY(_main)

SECTIONS
{
	. = 0x40000000;

	.text : {
		*(.text .text.*)
	}

	__etext = .;
	_etext = .;
	etext = .;
	.rodata : {
		*(.rodata .rodata.* .gnu.linkonce.r.*)
	}
	
	.data :
	{
		. = ALIGN(. != 0 ? 64 / 8 : 1);
		__data_start = .;
		*(.data*)
	}
	_edata = .; edata = .;
	. = .;

	__bss_start = .;
	__bss_start__ = .;
	.bss :
	{
		. = ALIGN(. != 0 ? 64 / 8 : 1);
		*(.bss .bss.* .gnu.linkonce.b.*)
	}
	_bss_end__ = .; __bss_end__ = .;
	. = ALIGN(64 / 8);
	. = SEGMENT_START("ldata-segment", .);
	. = ALIGN(64 / 8);
	__end__ = .;
	_end = .; end = .;

	/* DWARF debug sections.
	   Symbols in the DWARF debugging sections are relative to the beginning
	   of the section so we begin them at 0.  */
	/* DWARF 1 */
	.debug          0 : { *(.debug) }
	.line           0 : { *(.line) }
	/* GNU DWARF 1 extensions */
	.debug_srcinfo  0 : { *(.debug_srcinfo) }
	.debug_sfnames  0 : { *(.debug_sfnames) }
	/* DWARF 1.1 and DWARF 2 */
	.debug_aranges  0 : { *(.debug_aranges) }
	.debug_pubnames 0 : { *(.debug_pubnames) }
	/* DWARF 2 */
	.debug_info     0 : { *(.debug_info .gnu.linkonce.wi.*) }
	.debug_abbrev   0 : { *(.debug_abbrev) }
	.debug_line     0 : { *(.debug_line .debug_line.* .debug_line_end) }
	.debug_frame    0 : { *(.debug_frame) }
	.debug_str      0 : { *(.debug_str) }
	.debug_loc      0 : { *(.debug_loc) }
	.debug_macinfo  0 : { *(.debug_macinfo) }
	/* DWARF 3 */
	.debug_pubtypes 0 : { *(.debug_pubtypes) }
	.debug_ranges   0 : { *(.debug_ranges) }
	/* DWARF Extension.  */
	.debug_macro    0 : { *(.debug_macro) }
	.debug_addr     0 : { *(.debug_addr) }

	/DISCARD/ : { *(.note.GNU-stack) *(.gnu_debuglink) *(.gnu.lto_*) }
}
