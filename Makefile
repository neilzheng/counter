all: tests tests2

tests: counter.vvp cntclk.vvp onehzclk.vvp tlfsm.vvp

counter.vvp: countertb.v counter.v
	iverilog -o counter.vvp countertb.v counter.v
	vvp counter.vvp
#	open counter.vcd

cntclk.vvp: cntclktb.v cntclk.v counter.v
	iverilog -o cntclk.vvp cntclktb.v cntclk.v counter.v
	vvp cntclk.vvp
#	open cntclk.vcd

onehzclk.vvp: onehzclktb.v onehzclk.v cntclk.v counter.v
	iverilog -o onehzclk.vvp onehzclktb.v onehzclk.v cntclk.v counter.v
	vvp onehzclk.vvp
#	open onehzclk.vcd

tlfsm.vvp: tlfsmtb.v tlfsm.v cntclk.v counter.v
	iverilog -o tlfsm.vvp tlfsmtb.v tlfsm.v cntclk.v counter.v
	vvp tlfsm.vvp
#	open tlfsm.vcd

tests2: counter2.vvp cntclk2.vvp onehzclk2.vvp tlfsm2.vvp

counter2.vvp: counter2tb.v counter2.v
	iverilog -o counter2.vvp counter2tb.v counter2.v
	vvp counter2.vvp
#	open counter2.vcd

cntclk2.vvp: cntclk2tb.v cntclk2.v counter2.v
	iverilog -o cntclk2.vvp cntclk2tb.v cntclk2.v counter2.v
	vvp cntclk2.vvp
#	open cntclk2.vcd

onehzclk2.vvp: onehzclk2tb.v onehzclk2.v cntclk2.v counter2.v
	iverilog -o onehzclk2.vvp onehzclk2tb.v onehzclk2.v cntclk2.v counter2.v
	vvp onehzclk2.vvp
#	open onehzclk2.vcd

tlfsm2.vvp: tlfsm2tb.v tlfsm2.v cntclk2.v counter2.v
	iverilog -o tlfsm2.vvp tlfsm2tb.v tlfsm2.v cntclk2.v counter2.v
	vvp tlfsm2.vvp
#	open tlfsm2.vcd

.PHONY: all tests test2 clean
clean:
	-rm -rf *.vvp *.vcd

