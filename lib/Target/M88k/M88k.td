include "llvm/Target/Target.td"

//
// Register File, Calling Conv, Instruction Descriptions
//

include "M88kRegisterInfo.td"
include "M88kCallingConv.td"
include "M88kSchedule.td"
include "M88kInstrFormats.td"
include "M88kInstrInfo.td"

//
// M88k processors supported
//

def : ProcessorModel<"mc88100", M88kSchedModel, []>;
def : ProcessorModel<"mc88110", M88kSchedModel, []>;

//
// Declare the target which we are implementing
//

def M88kInstrInfo : InstrInfo;
def M88kAsmParser : AsmParser;
def M88kAsmParserVariant : AsmParserVariant {
    let RegisterPrefix = "%";
}

def M88kAsmWriter : AsmWriter;

def M88k : Target {
    let InstructionSet = M88kInstrInfo;
    let AssemblyParsers = [M88kAsmParser];
    let AssemblyParserVariants = [M88kAsmParserVariant];
    let AssemblyWriters = [M88kAsmWriter];
    let AllowRegisterRenaming = 1;
}
