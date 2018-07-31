all: tests

tests: counter.vvp cntclk.vvp onehzclk.vvp tlfsm.vvp

counter.vvp: countertb.v counter.v
	iverilog -o counter.vvp countertb.v counter.v
	vvp counter.vvp
	open counter.vcd

cntclk.vvp: cntclktb.v cntclk.v counter.v
	iverilog -o cntclk.vvp cntclktb.v cntclk.v counter.v
	vvp cntclk.vvp
	open cntclk.vcd

onehzclk.vvp: onehzclktb.v onehzclk.v cntclk.v counter.v
	iverilog -o onehzclk.vvp onehzclktb.v onehzclk.v cntclk.v counter.v
	vvp onehzclk.vvp
	open onehzclk.vcd

tlfsm.vvp: tlfsmtb.v tlfsm.v cntclk.v counter.v
	iverilog -o tlfsm.vvp tlfsmtb.v tlfsm.v cntclk.v counter.v
	vvp tlfsm.vvp
	open tlfsm.vcd

.PHONY: all tests clean
clean:
	-rm -rf *.vvp *.vcd
