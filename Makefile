NAME = setup

INFILES = setup.sh setup.conf

all: build
build: $(INFILES)

include buildenv/Makefile.common.nopython


modules/150-conf-snmptrapd/run.sh: modules/150-conf-snmptrapd/run.sh.in
	sed -e 's,@LIBEXECDIR@,$(LIBEXECDIR),g' $^ > $@
	rm modules/150-conf-snmptrapd/run.sh.in

setup.sh: setup.sh.in
	sed -e 's,@SYSCONFDIR@,$(SYSCONFDIR),g' $^ > $@

setup.conf: setup.conf.in
	sed -e 's,@LIBEXECDIR@,$(LIBEXECDIR),g' $^ > $@

install: setup.sh setup.conf modules/150-conf-snmptrapd/run.sh $(PYTHON)
	install -D -m 755 -p setup.sh $(DESTDIR)$(SBINDIR)/$(PKGNAME)
	install -D -m 644 -p setup.conf $(DESTDIR)$(SYSCONFDIR)/vigilo/setup/setup.conf
	mkdir -p $(DESTDIR)$(LIBEXECDIR)/vigilo/setup
	cp -pr modules/* $(DESTDIR)$(LIBEXECDIR)/vigilo/setup/

clean:
	rm -f $(INFILES)
	rm -rf build


.PHONY: all build install clean
