PHONY: help
help:
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

OPTS_VIVADO   = -work work -sv
OPTS_IVERILOG = -g2012 -sv

UVM_TOP       = ../../../uvm
UVM_EXTRAS    = ../../../uvclib
SRCS_UVM      = $(UVM_TOP)/uvm_pkg.sv
OPTS_UVM      = $(shell echo $(UVM_TOP) $(UVM_EXTRAS) | xargs -n1 echo -i)

JISSENUVM_TOP      = .
SRCS_JISSENUVM     = $(SRCS_UVM)
SRCS_JISSENUVM    += $(wildcard $(JISSENUVM_TOP)/*.sv)
SRCS_JISSENUVM     = $(SRCS_UVM) pkg.sv Chapter_5.sv dut.sv

# SRCS_JISSENUVM    += $(shell find hello_jissen_uvm/ -type f -name '*.sv*')
OPTS_JISSENUVM     = $(OPTS_UVM) -i $(JISSENUVM_TOP)

00000:  ## # This makefile is for Jissen UVM
00001:  ## * Before run uvmprimer codes, confirm if xilinx tools are available.

all: jissenuvm  ## all

clean:
	rm -f $(OUTFILE) $(VCD)
	rm -rf ./xsim.dir
	rm -f webtalk* xelab* xsim* xvlog*
	
jissenuvm    :    $(SRCS_JISSENUVM)  ## Jissen UVM Chapter 5
	xvlog $(OPTS_VIVADO) $(OPTS_JISSENUVM) $^
	xelab --debug all --notimingchecks top
	xsim top_class	--runall
