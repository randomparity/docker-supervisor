docker-supervisor
=================

Docker container running a standardzied `supervisord` install.  Not very useful by itself but used by multiple child containers.

Assumptions
-----------

Child containers will create a `<service>.sv.conf` file and add it to the /etc/supervisor/conf.d directory so that supervisord can invoke and manage the particular <service>. 

