# Whats this and why?

This script is intended for icinga/nagios/icinga2 to check the state of a
systemd service. We check the ServiceState and the Substate.

This tools uses dbus to gather needed informations, as systemd-developer
Lennart Poettering says it is the right way to do and cli output is not stable and should not be parsed.

https://github.com/systemd/systemd/issues/83

## How to install?

    git clone https://github.com/pengutronix/monitoring-check-systemd-service.git
    apt-get install python3-nagiosplugin python3-gi


## How to use?

    > ./check-systemd-service -h
    usage: check-systemd-service [-h] [-v] [-t TIMEOUT] unit

    Nagios plugin to check a systemd service on different properties

    positional arguments:
      unit                  Check this Unit

    optional arguments:
      -h, --help            show this help message and exit
      -v, --verbose         increase output verbosity (use up to 3 times)
      -t TIMEOUT, --timeout TIMEOUT
			    abort execution after TIMEOUT seconds


    > ./check-systemd-service -t 3 systemd-logind 
    SYSTEMD SERVICE SYSTEMD-LOGIND OK - ServiceState is active(running)


## optional features (future)

It could check for every systemd service property. The plugin has access to the whole systemd-dbus dataset without parsing any CLI output.


