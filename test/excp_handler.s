# A simple handler to test the interrupt facility.

			.ktext 0x80000180
			mtc0 $zero, $13
			mfc0 $k0, $12
			andi $k0, 0xfffd
			ori $k0, 0x1
			mtc0 $k0, $12
			eret
