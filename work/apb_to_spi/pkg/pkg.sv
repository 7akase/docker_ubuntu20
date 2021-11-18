`ifndef PKG_SV
`define PKG_SV

package pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
typedef virtual ApbIf DRV_VIF;
typedef virtual ApbIf COL_VIF;

`include "color.svh"
`include "ApbItem.sv"
`include "ApbDriver.sv"
`include "ApbSequencer.sv"
`include "ApbTestSequenceBase.sv"
`include "ApbTestSequence0001.sv"
//`include "uvclib_collector_base.sv"
`include "ApbCollector.sv"
//`include "uvclib_monitor_base.sv"
`include "ApbMonitor.sv"
`include "MyAgent.sv"
`include "MyEnv.sv"
`include "MyTest0001.sv"
 
endpackage

`endif