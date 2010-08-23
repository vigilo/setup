%define module  setup
%define name    vigilo-%{module}
%define version 2.0.0
%define release 1%{?svn}

Name:       %{name}
Summary:    Install scripts for Vigilo
Summary(fr): Scripts d'install de Vigilo
Version:    %{version}
Release:    %{release}
Source0:    %{module}.tar.bz2
URL:        http://www.projet-vigilo.org
Group:      System/Servers
BuildRoot:  %{_tmppath}/%{name}-%{version}-%{release}-build
License:    GPLv2
Buildarch:  noarch


%description
This module contains the Vigilo install script
This application is part of the Vigilo Project <http://vigilo-project.org>

%description -l fr
Ce module contient les scripts d'installation de Vigilo.
Ce programme fait partie du projet Vigilo <http://vigilo-project.org>

%prep
%setup -q -n %{module}

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
%defattr(-,root,root)
%doc COPYING
%{_sbindir}/vigilo-setup
%{_libexecdir}/vigilo
%dir %{_sysconfdir}/vigilo/
%config %{_sysconfdir}/vigilo/%{module}


%changelog
* Fri Jul 16 2010 Aurelien Bompard <aurelien.bompard@c-s.fr>
- initial package
