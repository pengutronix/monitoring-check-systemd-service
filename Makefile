PREFIX?=/usr

# an empty make target as there is nothing todo
build:

install:
	install -d $(DESTDIR)$(PREFIX)/lib/nagios/plugins/
	install check-systemd-service $(DESTDIR)$(PREFIX)/lib/nagios/plugins/check_systemd_service
