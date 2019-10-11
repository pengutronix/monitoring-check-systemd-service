%define        version   1.1.0
%define        plugindir /usr/lib64/nagios/plugins/
Name:          check-systemd-service
Version:       %{version}
Release:       1
Epoch:         1
Summary:       Nagios/Icinga check for systemd services
AutoReqProv:   no
BuildRoot:     %buildroot
BuildArch:     noarch
Source0:       https://github.com/joernott/monitoring-check-systemd-service/archive/v%{version}.tar.gz#/monitoring-check-systemd-service-%{version}.tar.gz

License:       BSD
URL:           https://github.com/joernott/monitoring-check-systemd-service
Requires:      python36-gobject
Requires:      python3-nagiosplugin

%description
This script is intended for icinga/nagios/icinga2 to check the state of a
systemd service. We check the ServiceState and the Substate.

This tools uses dbus to gather needed informations, as systemd-developer
Lennart Poettering says it is the right way to do and cli output is not stable
and should not be parsed.

%prep
%autosetup -n monitoring-check-systemd-service-%{version}

%build
%install
mkdir -p $RPM_BUILD_ROOT%{plugindir}
mv %{_builddir}/monitoring-check-systemd-service-%{version}/check-systemd-service $RPM_BUILD_ROOT%{plugindir}/
rm -rf $RPM_BUILD_ROOT/monitoring-check-systemd-service-%{version}

%clean
rm -rf $RPM_BUILD_ROOT/*

%files
%attr(755,root,root) %{plugindir}/check-systemd-service

