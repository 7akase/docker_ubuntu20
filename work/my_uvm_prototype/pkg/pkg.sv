`ifndef PKG_SV
`define PKG_SV

package pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
typedef virtual MyIf DRV_VIF;
typedef virtual MyIf COL_VIF;

`include "MyItem.sv"
`include "uvclib_driver_base.sv"
`include "MyDriver.sv"
`include "MySequencer.sv"
`include "MyTestSequenceBase.sv"
`include "MyTestSequence0001.sv"
`include "uvclib_collector_base.sv"
`include "MyCollector.sv"
`include "uvclib_monitor_base.sv"
`include "MyMonitor.sv"
`include "MyAgent.sv"
`include "MyEnv.sv"
`include "MyTest0001.sv"
 
endpackage

`endif