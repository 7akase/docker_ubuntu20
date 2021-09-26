`ifndef PKG_SV
`define PKG_SV

package pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
typedef virtual saradc_logic_if DRV_VIF;
typedef virtual saradc_logic_if COL_VIF;

`include "saradc_logic_item.sv"
`include "uvclib_driver_base.sv"
`include "saradc_logic_driver.sv"
`include "saradc_logic_sequencer.sv"
`include "saradc_logic_sequence_base.sv"
`include "saradc_logic_sequence_test1.sv"
`include "uvclib_collector_base.sv"
`include "saradc_logic_collector.sv"
`include "uvclib_monitor_base.sv"
`include "saradc_logic_monitor.sv"
`include "saradc_logic_agent.sv"
`include "saradc_logic_env.sv"
`include "saradc_logic_test_base.sv"
`include "saradc_logic_test_0001.sv"
 
endpackage

`endif