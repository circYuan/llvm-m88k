//
// M88k Register definitions
//

class M88kReg<bits<5> Enc, string n> : Register<n> {
    let HWEncoding{15-5} = 0;
    let HWEncoding{4-0} = Enc;
    let Namespace = "M88k";
}

//
// General-purpose registers
//

class GRi<bits<5> Enc, string n> : M88kReg<Enc, n>;
foreach I = {0-31} in {
    def R#I : GRi<I, "r"#I>;
}

def GPR : RegisterClass<"M88k", [i32], 32,
                            (add (sequence "R%u", 0, 31))>;

//
// define operand based on the register class.
// The operand is used in selecting DAG nodes.
//

def GPROpnd : RegisterOperand<GPR>;
