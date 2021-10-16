PHONY: help
help:
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

----:  ## * Before run uvmprimer codes, confirm if xilinx tools are available.

# =======================================================
# variables
# =======================================================
OPTS_VIVADO   = -sv -L uvm

OPTS_JISSENUVM  = -i uvclib/ -i .

DUT             = dut
TOP_MODULE      = top

SIMK       		= xsim.dir/work.$(TOP_MODULE)/xsimk  	# exists if xelab was done
WDB        		= work.$(TOP_MODULE).wdb             	# exists if xsim was done

UVM_TESTNAME   	= MyTest0001
UVM_VERBOSITY	= UVM_DEBUG 	# NONE, LOW, MEDIUM, HIGH, FULL, DEBUG

# =======================================================
all: compile elaborate test  ## all
	echo $(SDBS)

# =======================================================
# compile
# =======================================================
SDBS += xsim.dir/work/pkg.sdb
xsim.dir/work/pkg.sdb: $(wildcard pkg/*.sv*)
	xvlog $(OPTS_VIVADO) $(OPTS_JISSENUVM) -i pkg/ pkg/pkg.sv

SDBS += xsim.dir/work/$(DUT).sdb
xsim.dir/work/$(DUT).sdb: $(wildcard dut/*.sv*)
	xvlog $(OPTS_VIVADO) $(OPTS_JISSENUVM) -i dut/ dut/$(DUT).sv

SDBS += xsim.dir/work/$(TOP_MODULE).sdb
xsim.dir/work/$(TOP_MODULE).sdb: $(wildcard pkg/$(TOP_MODULE).sv)
	xvlog $(OPTS_VIVADO) $(OPTS_JISSENUVM) -i pkg/ pkg/$(TOP_MODULE).sv

compile:    $(SDBS)  ## xsim.dir/work/*.sdb     to xsim.dir/work.top/xsimk

# =======================================================
# elaborate
# =======================================================
$(SIMK): $(SDBS)
	xelab $(TOP_MODULE) --debug all --notimingchecks

elaborate:  $(SIMK)  ## xsim.dir/work.top/xsimk to work.top.wdb

# =======================================================
# test
# =======================================================
$(addsuffix .log,$(UVM_TESTNAME)): $(SIMK)
	xsim  $(TOP_MODULE)	--runall \
		-testplusarg UVM_TESTNAME=$(UVM_TESTNAME)\
		-testplusarg UVM_VERBOSITY=$(UVM_VERBOSITY)\
	|tee $@

test: $(addsuffix .log,$(UVM_TESTNAME)) ## run test using xsim
# ex. make test UVM_TESTNAME=MyTest0001

# =======================================================
# clean
# =======================================================
clean:
	rm -f $(OUTFILE) $(VCD)
	rm -rf ./xsim.dir
	rm -f webtalk* xelab* xsim* xvlog* *.wdb
	
