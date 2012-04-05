NAME = setup

INFILES = setup.sh setup.conf

all: build
build: $(INFILES)

include buildenv/Makefile.common.nopython


setup.sh: setup.sh.in
	sed -e 's,@SYSCONFDIR@,$(SYSCONFDIR),g' $^ > $@

setup.conf: setup.conf.in
	sed -e 's,@LIBEXECDIR@,$(LIBEXECDIR),g' $^ > $@

install: setup.sh setup.conf
	install -D -m 755 -p setup.sh $(DESTDIR)$(SBINDIR)/$(PKGNAME)
	install -D -m 644 -p setup.conf $(DESTDIR)$(SYSCONFDIR)/vigilo/setup/setup.conf
	mkdir -p $(DESTDIR)$(LIBEXECDIR)/vigilo/setup
	cp -pr modules/* $(DESTDIR)$(LIBEXECDIR)/vigilo/setup/
	chmod 755 $(DESTDIR)$(LIBEXECDIR)/vigilo/setup/*/run.sh

clean: clean_common
	rm -f $(INFILES)


.PHONY: all build install clean
