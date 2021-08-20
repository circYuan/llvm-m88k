// Scheduling model is used by the code generation to order the instructions in an optimal way.
// Not necessary for implementation, so this file only define the placeholder for the model

def M88kSchedModel : SchedMachineModel {
    let IssueWidth = 2;
    let MicroOpBufferSize = 0;
    let CompleteModel = 0;
    let NoModel = 1;
}
