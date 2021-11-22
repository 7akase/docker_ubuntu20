`ifndef PKG_SV
`define PKG_SV

package pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
typedef virtual ApbIf DRV_VIF;
typedef virtual SpiIf COL_VIF;

`include "color.svh"
`include "ApbItem.sv"
`include "SpiItem.sv"
`include "ApbDriver.sv"
`include "ApbSequencer.sv"
`include "ApbTestSequenceBase.sv"
`include "ApbTestSequence0001.sv"
`include "SpiCollector.sv"
`include "ApbToSpiMonitor.sv"
`include "MyAgent.sv"
`include "MyEnv.sv"
`include "MyTest0001.sv"
 
endpackage

`endif