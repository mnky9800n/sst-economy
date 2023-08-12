# Makefile for the SST2K project

VERS=$(shell sed <sst -n -e '/version *= \"*\(.*\)\"/s//\1/p')

MANDIR=/usr/share/man/man1
BINDIR=/usr/bin

DOCS    = README COPYING NEWS doc/HACKING doc/sst-doc.xml doc/sst-layer.xsl doc/sst.xml
SOURCES = sst Makefile replay doc/makehelp.py control $(DOCS)

all: super-star-trek-$(VERS).tar.gz

install: sst.6
	cp sst $(BINDIR)
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

check: pylint
	cd test; $(MAKE) --quiet

pylint:
	@pylint --score=n sst

clean:
	rm -f sst.6 sst.html sst-doc.html
	rm -f *.6 MANIFEST index.html

SHIPPER = version=$(VERS) bkgimage=lpt.jpg

release: super-star-trek-$(VERS).tar.gz sst.html sst-doc.html
	shipper $(SHIPPER) | sh -e -x

refresh: sst.html
	shipper -N -w $(SHIPPER)  | sh -e -x
