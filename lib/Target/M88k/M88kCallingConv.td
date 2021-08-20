//
// describe the calling convention
// Only OpenBSD variant is supported
//
def CC_M88k : CallingConv<[
    // Promote i8/i16 args to i32 since M88k only has 32 bit register.
    CCIfType<[i1, i8, i16], CCPromoteToType<i32>>,
    // Register R12 is ised to pass structure return pointer.
    CCIfSRet<CCIfType<[i32], CCAssignToReg<[R12]>>>,
    // Registers R2 to R9 are used for passing paramters.
    CCIfType[i32, i64, f32, f64], CCAssignToReg<[R2, R3, R4, R5, R6, R7, R8, R9]>>,
    // Other arguments are passed on the stack, at least 4-byte-aligned.
    CCAssignToStack<4, 4>
]>;

// M88k 32-bit ELF C return-value convention.

def RetCC_M88k : CallingConv<[
    CCIfType<[i32, f32], CCAssignToReg<[R2]>>,
    CCIfType<[i64, f64], CCAssignToReg<[R2, R3]>>
]>;

// M88k 32-bit ELF C callee saved registers.

def CSR_M88k : CalleeSavedRegs<(add (sequence "R%d", 14, 25), R30)>;
