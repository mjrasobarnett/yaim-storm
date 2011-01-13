Summary:      INFN-GRID YAIM module for SE StoRM configuration
Name:         NNAME
Version:      VV
Release:      RR
BuildArch:    noarch
#Copyright:    LCG   # obsolete
Vendor:       INFN
Distribution: INFN-GRID
Packager:     grid-release@infn.it
Group:        Custom/INFN-GRID
License:      LCG
URL:          http://grid-it.cnaf.infn.it
Source:       %{name}-%{version}.tar.gz
BuildRoot:    %{_tmppath}/%{name}-%{version}-build
Prefix:	      /opt/glite
%description
YAIM is a generic configuration for Grid Middleware developed by EGEE.
This package provides additional customizations for INFN-GRID.

%prep

%setup

%install
[ -d $RPM_BUILD_ROOT ] && rm -fr $RPM_BUILD_ROOT
make install PREFIX=$RPM_BUILD_ROOT/opt/glite

#%clean
#rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%{prefix}/yaim/defaults
%{prefix}/yaim/etc/versions/%{name}
%{prefix}/yaim/examples/siteinfo/services
%{prefix}/yaim/functions/local
%{prefix}/yaim/node-info.d
