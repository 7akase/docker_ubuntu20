PHONY: help
help:
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

TOOLCHAIN     = vivado    # vivado | iverilog

OPTS_VIVADO   = -sv -L uvm
OPTS_IVERILOG = -g2012 -sv -i ../uvm

ifeq      ($(TOOLCHAIN),vivado)
	OPTS = OPTS_VIVADO
else ifeq ($(TOOLCHAIN),iverilog)
	OPTS = OPTS_IVERILOG
else
	OPTS = OPTS_VIVADO
endif


UVMPRIMER_TOP      = .
UVMPRIMER05        = $(UVMPRIMER_TOP)/05_Classes_and_Extension
UVMPRIMER0601      = $(UVMPRIMER_TOP)/06_Polymorphism/01_Not_Virtual
UVMPRIMER0602      = $(UVMPRIMER_TOP)/06_Polymorphism/02_Virtual
UVMPRIMER0603      = $(UVMPRIMER_TOP)/06_Polymorphism/03_Pure_Virtual
UVMPRIMER1501      = $(UVMPRIMER_TOP)/15_Talking_Objects/01_No_Analysis_Port
UVMPRIMER1502      = $(UVMPRIMER_TOP)/15_Talking_Objects/02_With_Analysis_Port
UVMPRIMER21        = $(UVMPRIMER_TOP)/21_UVM_Transactions
SRCS_UVMPRIMER05   = $(UVMPRIMER05  )/classes.sv
SRCS_UVMPRIMER0601 = $(UVMPRIMER0601)/not_virtual.sv
SRCS_UVMPRIMER0602 = $(UVMPRIMER0602)/virtual.sv

OPTS_UVMPRIMER1501 = -i $(UVMPRIMER1501)
SRCS_UVMPRIMER1501 = $(UVMPRIMER1501)/dice_pkg.sv $(UVMPRIMER1501)/top.sv

OPTS_UVMPRIMER1502 = -i $(UVMPRIMER1502)
SRCS_UVMPRIMER1502 = $(UVMPRIMER1502)/dice_pkg.sv $(UVMPRIMER1502)/top.sv

OPTS_UVMPRIMER21   = -i $(UVMPRIMER21) -i $(UVMPRIMER21)/tb_classes
SRCS_UVMPRIMER21   = $(UVMPRIMER21)/tinyalu_pkg.sv $(UVMPRIMER21)/top.sv $(UVMPRIMER21)/tinyalu_bfm.sv $(UVMPRIMER21)/tinyalu_dut/single_cycle_add_and_xor.vhd $(UVMPRIMER21)/tinyalu_dut/three_cycle_mult.vhd $(UVMPRIMER21)/tinyalu_dut/tinyalu.vhd

00000:  ## # This makefile is for UVM Primer
00001:  ## * Before run uvmprimer codes, confirm if xilinx tools are available.

all: uvmprimer1502  ## all

clean:
	rm -f $(OUTFILE) $(VCD)
	rm -rf ./xsim.dir
	rm -f webtalk* xelab* xsim* xvlog*
	
uvmprimer05:  $(SRCS_UVMPRIMER05)    ## UVM Primer 05_Classes_and_Extension
	xvlog $(OPTS_VIVADO) $(OPTS_UVM) $(OPTS_UVMPRIMER05) $^
	xelab --debug all --notimingchecks -relax top_class
	xsim top_class	--runall

uvmprimer0601:  $(SRCS_UVMPRIMER0601)  ## UVM Primer 06_Polymorphism/01_Not_Virtual
	xvlog -sv $^
	xelab --debug all --notimingchecks top
	xsim top --runall

uvmprimer0602:  $(SRCS_UVMPRIMER0602)  ## UVM Primer 06_Polymorphism/02_Virtual:w
	xvlog $(OPTS_VIVADO) $^
	xelab top --debug all --notimingchecks
	xsim top --runall

uvmprimer1501:  $(SRCS_UVMPRIMER1501)  ## UVM Primer 15_Talking_Objects/01_No_Analysis_Port
	$(eval TOP_MODULE = top)
	xvlog $(OPTS_VIVADO) $(OPTS_UVMPRIMER1501) $^
	xelab $(TOP_MODULE) --debug all --notimingchecks
	xsim  $(TOP_MODULE) --runall

uvmprimer1502:  $(SRCS_UVMPRIMER1502)  ## UVM Primer 15_Talking_Objects/01_No_Analysis_Port
	$(eval TOP_MODULE = top)
	xvlog $(OPTS_VIVADO) $(OPTS_UVMPRIMER1502) $^
	xelab $(TOP_MODULE) --debug all --notimingchecks
	xsim  $(TOP_MODULE) --runall

uvmprimer1502_iverilog:  $(SRCS_UVMPRIMER1502)  ## UVM Primer 15_Talking_Objects/01_No_Analysis_Port
	iverilog $(OPTS_IVERILOG) $(OPTS_UVMPRIMER1502) $(SRCS_UVM) $^ \
				-s $(TOP_UVMPRIMER1502) -o a.out
	a.out
	gtkwave $(TOP_UVMPRIMER1502).vcd

uvmprimer21  :    $(SRCS_UVMPRIMER21)  ## UVM Primer 21_UVM_Transactioins
	$(eval TOP_MODULE = top)
	xvlog $(OPTS_VIVADO) $(OPTS_UVMPRIMER21) $(filter-out %.vhd,$^)
	xvhdl $(filter %.vhd,$^)
	xelab $(TOP_MODULE) --debug all --notimingchecks
	xsim  $(TOP_MODULE) --runall