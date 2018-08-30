#! /bin/bash
# June/July 2018 Loz Bigrave

# This alert is per-device, in this case 1.0.0.96, hostname MySwitch

#create a debug file
set -x; exec 2>/root/debug_myswitch_cisco_login_failure.log


# Find files modified in the last x minutes, change this to search your device IP
targetfiles=$(find /syslogs/1.0.0.96/ -type f -mmin -1 -exec ls {} +)

#  Exit if no files have been modified in the last x minutes
if [ -z "$targetfiles" ]; then

		exit 0
	
		else


		logentry=SEC_LOGIN-4-LOGIN_FAILED
		device=MySwitch
		subject="Syslog alert: Cisco logon failure : $device"
		TO=admin@mycompany.com
		SITE="Daventry"
		mailbody="/root/syslog_mailers/cisco_myswitch_logonfailure.mailer"

		# don't change anything below here apart from from=

		rightnow=$(date +%H:%M:)
		loadedcontent=$(cat $targetfiles | grep -i "$logentry" | grep -E $rightnow'[[:digit:]]{2}')

		if [ -z "$loadedcontent" ]; then

		exit 0

		fi
	
		echo "test here $mailbody"	
		
			if [ -e "$mailbody" ]; then

			echo "file exists"
		
			exit 0	
			fi		

			
		if [ ! -e "$mailbody" ]; then
		
		#No existing mailer file:

		# Send an email alert
		now=$(date)
		loadedfiles=$(grep -i $logentry -l $targetfiles)
		loadedfiles_for_html_link=$(echo $loadedfiles | cut -d'/' -f3,4,5,6)
		from=svr-syslog@mycompany.com
		
		echo "A failed login has been detected on device $device." >$mailbody
		echo "" >>$mailbody
		echo "Site name:" >>$mailbody 
		echo "$SITE" >>$mailbody
		echo "" >>$mailbody
		echo "Trigger time:" >>$mailbody 
		echo "$now" >>$mailbody
	    echo ""	>>$mailbody
		echo "Trigger event (Cisco):" >>$mailbody
		echo "'$logentry'" >>$mailbody
	    echo "" >>$mailbody
		echo "Log file:" >>$mailbody
	    echo "$loadedfiles" >>$mailbody
		echo "" >>$mailbody
		echo "Log File quick link" >>$mailbody
        echo "http://syslog-svr-sys.mydomain.com/$loadedfiles_for_html_link" >>$mailbody
        echo "" >>$mailbody
		echo "Details:" >>$mailbody
		echo "$loadedcontent" >>$mailbody
		echo "" >>$mailbody

		/usr/bin/mail --return-address=$from -s "$subject" "$TO" <$mailbody

	fi	
fi
	
