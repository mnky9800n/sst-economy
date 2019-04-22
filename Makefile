# Makefile for the SST2K project

VERS=$(shell sed <sst.py -n -e '/version *= \"*\(.*\)\"/s//\1/p')

MANDIR=/usr/share/man/man1
BINDIR=/usr/bin

DOCS    = README COPYING NEWS doc/HACKING doc/sst-doc.xml doc/sst-layer.xsl doc/sst.xml
SOURCES = sst.py Makefile replay doc/makehelp.py control $(DOCS)

all: super-star-trek-$(VERS).tar.gz

install: sst.6
	cp sst.py $(BINDIR)
	gzip <sst.6 >$(MANDIR)/sst.6.gz

sst.6: doc/sst.xml
	cd doc; xmlto man sst.xml; mv sst.6 ..

sst.html: doc/sst.xml
	cd doc; xmlto html-nochunks sst.xml; mv sst.html ..

sst-doc.html: doc/sst-doc.xml
	xmlto xhtml-nochunks doc/sst-doc.xml

super-star-trek-$(VERS).tar.gz: $(SOURCES) sst.6
	tar --transform='s:^:super-star-trek-$(VERS)/:' --show-transformed-names -cvzf super-star-trek-$(VERS).tar.gz $(SOURCES) sst.6

dist: sst-$(VERS).tar.gz

check: #pylint
	cd test; make --quiet

pychecker:
	@-pychecker --quiet --only --limit 50 sst.py

COMMON_PYLINT = --rcfile=/dev/null --reports=n \
	--msg-template="{path}:{line}: [{msg_id}({symbol}), {obj}] {msg}" \
	--dummy-variables-rgx='^_'
PYLINTOPTS = $(COMMON_PYLINT) --disable=C0103,C0111,C0113,C1001,C0301,C0302,C0321,C0325,C0326,C0410,C1801,E1120,R0101,R0902,R0903,R0911,R0912,R0914,R0915,R0916,R1705,R1706,R1710,W0110,W0123,W0141,W0312,W0603,W0611
pylint:
	@pylint --output-format=parseable $(PYLINTOPTS) sst.py

clean:
	rm -f sst.6 sst.html
	rm -f *.6 MANIFEST index.html

SHIPPER = version=$(VERS) bkgimage=lpt.jpg

release: super-star-trek-$(VERS).tar.gz sst.html sst-doc.html
	shipper $(SHIPPER) | sh -e -x

refresh: sst.html
	shipper -N -w $(SHIPPER)  | sh -e -x
