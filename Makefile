NAME = setup
SBINDIR = $(PREFIX)/sbin
LIBEXECDIR = $(PREFIX)/libexec

all: setup.sh setup.conf

setup.sh: setup.sh.in
	sed -e 's,@SYSCONFDIR@,$(SYSCONFDIR),g' $^ > $@

setup.conf: setup.conf.in
	sed -e 's,@LIBEXECDIR@,$(LIBEXECDIR),g' $^ > $@

install: setup.sh setup.conf
	install -D -m 755 -p setup.sh $(DESTDIR)$(SBINDIR)/vigilo-setup
	install -D -m 644 -p setup.conf $(DESTDIR)$(SYSCONFDIR)/vigilo/setup/setup.conf
	mkdir -p $(DESTDIR)$(LIBEXECDIR)/vigilo/setup
	cp -pr modules/* $(DESTDIR)$(LIBEXECDIR)/vigilo/setup/


.PHONY: all install
