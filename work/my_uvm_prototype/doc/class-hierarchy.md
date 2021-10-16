
# aaa

```plantuml
!$pkg="../pkg"
!$dut="../dut"

class MyIf [[$pkg/MyIf.sv]] {
    cb: clocking
}

class top [[$pkg/top.sv]] #yellow{
    dut: DUT
    run_test()
}

class dut [[$dut/dut.sv]] #yellow

top         o-down--    dut
top         o-right--   MyIf
dut         <-right->   MyIf

class MyEnv [[$pkg/MyEnv.sv]]
class MyAgent [[$pkg/MyAgent.sv]]{
    sequencer
}

class uvm_sequencer_base #white {
    # default_sequence: string
    start_default_sequence()
}

class MySequencer [[$pkg/MySequencer.sv]]{
    MyItem: type
}

uvm_sequencer_base <|- MySequencer


class MyTest0001 [[$pkg/MyTest0001.sv]]

MyTest0001  o-right-    MyEnv
MyEnv       o-right-    MyAgent
MyAgent     o-down-     MySequencer
MyTest0001  ---->       MySequencer: set("default_sequence")

class uvm_sequence_base #white
class MyTestSequenceBase [[$pkg/MyTestSequenceBase.sv]]{
    MyItesm: type
    num_data: rand int
    phase: uvm_phaseMyTestSeq
    pre_body()
    post_body()
}
class MyTestSequence0001 [[$pkg/MyTestSequence0001.sv]]

uvm_sequence_base  <|-right-    MyTestSequenceBase
MyTestSequenceBase <|-right-    MyTestSequence0001

uvm_sequence_base  <--up-       uvm_sequencer_base: use



```