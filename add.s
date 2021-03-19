.arch	armv8-a
.cpu	cortex-a72

.global _start
.text

_start:

bl	GetInput	// return count/error in x0, address in x1
ldr	w10, [x1]	// get character in address in x1
and	w10, w10, #0x0F	// 0x0F = 00001111 in binary


//
// Read other character
//
mov	x0, #1		// file description of stdin
ldr	x1, =InBuffer	// Address of the input buffer
mov	x2, #10		// Count of characters (max)
mov	x8, #63		// Operating system code for read
svc	0		// call OS
			// x0 will have count read, or error code
			// x1 will be address pointer to buffer

ldr	w11, [x1]	// get character in address in x1
and	w11, w11, #0x0F	// 0x0F = 00001111 in binary


add	w0, w10, w11

// These two are the same
// orr	w0, w0, #0x30	// convert binary to ASCII
orr	w0, w0, #'0'	// convert binary to ASCII

//
// Store character in w0 to output buffer
//
ldr	x1, =OutBuffer	// get address of buffer
strb	w0, [x1]

//
// Print to stdout
//
mov	x0, #1		// file description of stdout
ldr	x1, =OutBuffer	// Address of the output buffer
mov	x2, #2		// Count of characters
mov	x8, #64		// Operating system code for write
svc	0		// call OS
			// on return x0 will be error if exist

// exit to operating system
mov	x0, #0		// return code
mov	x8, #93		// exit requested
svc	0		// call the operating system

//
// Input character
//
GetInput:
sub	sp, sp, #64	// Make room for 8 words on stack
str	x30, [sp, #0]
str	x29, [sp, #8]
str	x2,  [sp, #16]
str	x8,  [sp, #24]

mov	x0, #1		// file description of stdin
ldr	x1, =InBuffer	// Address of the input buffer
mov	x2, #10		// Count of characters (max)
mov	x8, #63		// Operating system code for read
svc	0		// call OS
			// x0 will have count read, or error code
			// x1 will be address pointer to buffer

ldr	x30, [sp, #0]
ldr	x29, [sp, #8]
ldr	x2,  [sp, #16]
ldr	x8,  [sp, #24]
add	sp, sp, #64
ret


// ---------------------------------------

.data			// can be modified by program

OutBuffer:
.ascii	"A"
.ascii	"\n"
.byte	0x0A		// end of line
.byte	0,0,0,0,0

.align 4

InBuffer:
.skip	256
.align 4
