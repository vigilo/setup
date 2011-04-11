NAME = setup
PKGNAME = vigilo-$(NAME)
SBINDIR = $(PREFIX)/sbin
LIBEXECDIR = $(PREFIX)/libexec
DESTDIR =

VERSION := $(shell cat VERSION.txt)

INFILES = setup.sh setup.conf

build: $(INFILES)

define find-distro
if [ -f /etc/debian_version ]; then \
	echo "debian" ;\
elif [ -f /etc/mandriva-release ]; then \
	echo "mandriva" ;\
elif [ -f /etc/redhat-release ]; then \
	echo "redhat" ;\
else \
	echo "unknown" ;\
fi
endef
DISTRO := $(shell $(find-distro))
DIST_TAG = $(DISTRO)

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
	rm -rf build
	rm -f $(INFILES)

sdist: dist/$(PKGNAME)-$(VERSION).tar.gz
dist/$(PKGNAME)-$(VERSION).tar.gz:
	mkdir -p build/sdist/$(PKGNAME)-$(VERSION)
	rsync -a --exclude .svn --exclude /dist --exclude /build --delete ./ build/sdist/$(PKGNAME)-$(VERSION)
	mkdir -p dist
	cd build/sdist; tar -czf $(CURDIR)/dist/$(PKGNAME)-$(VERSION).tar.gz $(PKGNAME)-$(VERSION)

SVN_REV = $(shell LANGUAGE=C LC_ALL=C svn info 2>/dev/null | awk '/^Revision:/ { print $$2 }')
rpm: clean pkg/$(NAME).$(DISTRO).spec dist/$(PKGNAME)-$(VERSION).tar.gz
	mkdir -p build/rpm/{$(NAME),BUILD,TMP}
	mv dist/$(PKGNAME)-$(VERSION).tar.gz build/rpm/$(NAME)/
	sed -e 's/@VERSION@/'`cat VERSION.txt`'/g' pkg/$(NAME).$(DISTRO).spec \
		> build/rpm/$(NAME)/$(PKGNAME).spec
	rpmbuild -ba --define "_topdir $(CURDIR)/build/rpm" \
				 --define "_sourcedir %{_topdir}/$(NAME)" \
				 --define "_specdir %{_topdir}/$(NAME)" \
				 --define "_rpmdir %{_topdir}/$(NAME)" \
				 --define "_srcrpmdir %{_topdir}/$(NAME)" \
				 --define "_tmppath %{_topdir}/TMP" \
				 --define "_builddir %{_topdir}/BUILD" \
				 --define "svn .svn$(SVN_REV)" \
				 --define "dist .$(DIST_TAG)" \
				 $(RPMBUILD_OPTS) \
				 build/rpm/$(NAME)/$(PKGNAME).spec
	mkdir -p dist
	find build/rpm/$(NAME) -type f -name "*.rpm" | xargs cp -a -f -t dist/


.PHONY: all install clean rpm
