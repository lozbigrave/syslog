
This folder structure, of course, can be changed as you so wish, just be sure to ammend the crontab as this runs the below scripts and will fail if the files cannot be found.  The 'syslog_logrotate.sh' targets /syslogs, as does the apache config '000-default.conf' so bare that in mind. 

/root
Contents:
syslog_commander.sh (runs alert scripts from cron)
syslog_logrotate.sh (runs log archiving from cron)
webperms.sh (sets permissions on web content from cron) 
debug.x (files created by the alert .sh files, useful for troubleshooting alert scripts) 

/root/configs
Contents:
Cisco config files straight from the switches used to lookup interface descriptions when sending email alerts. Save your CISCO DEVICE CONFIGS here.

/root/syslog_mailers
Contents:
The auto-generated email bodies, helps prevent being flooded by email alerts. Conrtolled by code within the alert rule files below.

/root/syslog_rules
Contents:
Alert .sh files that look for triggers within syslogs

/syslogs/
Contents:
The auto-generated syslog folders and logs. This can be mounted within a folder of your choice, or a seperate partition or disk. Populated by syslog-ng

/etc/apache2/sites-available/
Contents:
000-default.conf (the apache web server config used to display logs in a browser (indexing mode))

/etc/syslog-ng/
Contents:
syslog-ng.conf (the syslog server config, used to set listening ports and the syslog log folder structure),
