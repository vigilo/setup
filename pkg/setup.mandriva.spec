%define module  setup

Name:       vigilo-%{module}
Summary:    Install scripts for Vigilo
Summary(fr): Scripts d'install de Vigilo
Version:    @VERSION@
Release:    @RELEASE@%{?dist}
Source0:    %{name}-%{version}.tar.gz
URL:        http://www.projet-vigilo.org
Group:      System/Servers
BuildRoot:  %{_tmppath}/%{name}-%{version}-%{release}-build
License:    GPLv2

#Buildarch:  noarch  # Sur mandriva _libexecdir == _libdir


%description
This module contains the Vigilo install script
This application is part of the Vigilo Project <http://vigilo-project.org>

%description -l fr
Ce module contient les scripts d'installation de Vigilo.
Ce programme fait partie du projet Vigilo <http://vigilo-project.org>

%prep
%setup -q

%build
make \
	LIBEXECDIR=%{_libexecdir} \
	SYSCONFDIR=%{_sysconfdir}

%install
rm -rf $RPM_BUILD_ROOT
make install \
	DESTDIR=$RPM_BUILD_ROOT \
	SBINDIR=%{_sbindir} \
	LIBEXECDIR=%{_libexecdir} \
	SYSCONFDIR=%{_sysconfdir}


%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(644,root,root,755)
%doc COPYING.txt
%attr(755,root,root) %{_sbindir}/vigilo-setup
%{_libexecdir}/vigilo
%dir %{_sysconfdir}/vigilo/
%config %{_sysconfdir}/vigilo/%{module}


%changelog
* Fri Jul 16 2010 Aurelien Bompard <aurelien.bompard@c-s.fr>
- initial package
