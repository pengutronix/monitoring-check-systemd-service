Name:          monitoring-check-systemd-service
Version:       %{version}
Release:       %{release}%{?dist}
Epoch:         1
Summary:       Nagios/Icinga check for systemd services
AutoReqProv:   no
BuildArch:     noarch
Source0:       https://github.com/joernott/monitoring-check-systemd-service/archive/v%{version}.tar.gz#/monitoring-check-systemd-service-%{version}.tar.gz
License:       BSD
URL:           https://github.com/joernott/monitoring-check-systemd-service
%if 0%{?rhel} == 8
Requires:      python36
Requires:      python3-gobject
Requires:      python3-nagiosplugin
%else
Requires:      rh-python36
Requires:      python36-gobject
Requires:      python3-nagiosplugin
%endif


%description
This script is intended for icinga/nagios/icinga2 to check the state of a
systemd service. We check the ServiceState and the Substate.

This tools uses dbus to gather needed informations, as systemd-developer
Lennart Poettering says it is the right way to do and cli output is not stable
and should not be parsed.

%prep
%setup -q monitoring-check-systemd-service-%{version}

%install
mkdir -p "$RPM_BUILD_ROOT/usr/lib64/nagios/plugins"
cp check-systemd-service "$RPM_BUILD_ROOT/usr/lib64/nagios/plugins/"

%files
%attr(755,root,root) /usr/lib64/nagios/plugins/check-systemd-service

%changelog
* Wed Apr 27 2022 Joern Ott <joern.ott@ott-consult.de>
- Standardize builds for plugins

