# Test-suite makefile for sst

PYTHON=python3

all:
	@echo "With Python 2:"
	@$(MAKE) -e PYTHON=python2 regress | ./tapview
	@echo "With Python 3:"
	@$(MAKE) -e PYTHON=python3 regress | ./tapview
	@echo "No diff output is good news."

.SUFFIXES: .log .chk

.log.chk:
	../sst -r $< >$@ 2>&1

TESTLOADS := $(shell ls *.log | sed '/.log/s///')
buildregress:
	@for test in $(TESTLOADS); do \
	    if [ ! -f $${test}.tst ] ; \
	    then \
		    echo "Remaking $${test}.chk"; \
		    rm -f $${test}.chk && ../sst -r $${test}.log >$${test}.chk 2>&1; \
	    fi \
	done
regress:
	echo "1..$$(ls *.log | wc -l)"
	@for test in $(TESTLOADS); \
	do \
	    if [ ! -f $${test}.tst ] ; \
	    then \
		legend=$$(sed -n -e '/# Test/s//Test/p' <$${test}.log); \
		../sst -r "$${test}.log" | ./tapdiffer "$${legend}" "$${test}.chk"; \
	    fi \
	done
	@rm -f /tmp/regress
