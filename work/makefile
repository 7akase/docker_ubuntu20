PHONY: help
help:
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

TB         = top_module.sv
SRCS       = d_ff.v
OPTS       = -g2012 -L work

TOP_MODULE = tb_top
OUTFILE    = a.out
VCD        = out.vcd

UVMPRIMER_TOP = uvmprimer
UVMPRIMER05 = $(UVMPRIMER_TOP)/05_Classes_and_Extension
SRCS_UVMPRIMER05 = $(UVMPRIMER05)/classes.sv

UVMPRIMER06   = $(UVMPRIMER_TOP)/06_Polymorphism
UVMPRIMER0601 = $(UVMPRIMER06)/01_Not_Virtual
UVMPRIMER0602 = $(UVMPRIMER06)/02_Virtual
UVMPRIMER0603 = $(UVMPRIMER06)/03_Pure_Virtual
SRCS_UVMPRIMER0601 = $(UVMPRIMER0601)/not_virtual.sv
SRCS_UVMPRIMER0602 = $(UVMPRIMER0602)/virtual.sv

00000:  ## ** This makefile is for UVM Primer **

all: $(VCD)  ## all

$(OUTFILE):  $(SRCS) $(TB)  ## run $(TB) with iverilog
	iverilog $(OPTS) $(TB) $(SRCS) -s $(TOP_MODULE) -o $(OUTFILE)
	vvp $(OUTFILE)

view:  $(VCD)  ## gtkwave
	gtkwave $(VCD)

uvmprimer05:  $(SRCS_UVMPRIMER05)  ## UVM Primer 05_Classes_and_Extension
	xvlog -sv $^
	xelab --debug all --notimingchecks top_class
	xsim top_class	--runall

uvmprimer0601:  $(SRCS_UVMPRIMER0601)  ## UVM Primer 06_Polymorphism/01_Not_Virtual
	xvlog -sv $^
	xelab --debug all --notimingchecks top_class
	xsim top_class	--runall

uvmprimer0602:  $(SRCS_UVMPRIMER0602)  ## UVM Primer 06_Polymorphism/02_Virtual
	xvlog -sv $^
	xelab --debug all --notimingchecks top_class
	xsim top_class	--runall

clean:
	rm -f $(OUTFILE) $(VCD)
	