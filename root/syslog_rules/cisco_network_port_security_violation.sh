#! /bin/bash
# June/July 2018 Loz Bigrave
##### change these variables only:
# This alert is per-device, in this case 1.0.0.96, hostname MySwitch

# create a debug file
set -x; exec 2>/root/debug_myswitch_cisco_port_violation.log

logentry=PORT_SECURITY-2-PSECURE_VIOLATION
subject="Syslog alert: myswitch CoreSwitch: A network security violation has occurred"
TO=admin@acme.com
SITE="myswitch Daventry"
mailbody="/root/syslog_mailers/Cisco_Port_Sec_Alert.mailer"
config="/root/configs/myswitch-coresw-config"

# Find files modified in the last x minutes
targetfiles=$(find /syslogs/1.0.0.96/ -type f -mmin -1 -exec ls {} +)

#  Exit if no files have been modified in the last x minutes
if [ -z "$targetfiles" ]; then

		exit 0
	
	else
		rightnow=$(date +%H:%M:)
		loadedcontent=$(cat $targetfiles | grep -i "$logentry" | grep -E -m1 $rightnow'[[:digit:]]{2}')

		if [ -z "$loadedcontent" ]; then

		exit 0

		fi
	#else
		echo "test here $mailbody"	
		
			if [ -e "$mailbody" ]; then

			echo "file exists"
		
			already_mailed_port=$(cat $mailbody | grep -ohE -m1 GigabitEthernet'[[:digit:]]{1}/[[:digit:]]{1}/[[:digit:]]{1,2}')
			port=$(echo $loadedcontent | grep -ohE GigabitEthernet'[[:digit:]]{1}/[[:digit:]]{1}/[[:digit:]]{1,2}')
			if [ "$port" == "$already_mailed_port" ]; then
			echo "$already_mailed_port matches $port, exiting"
		
			exit 0	
			fi		

			if  [ "$port" != "$already_mailed_port" ]; then
                       	echo "$already_mailed_port does not match $port, continuing"
                       	rm $mailbody 
			# Send an email alert
			port=$(echo $loadedcontent | grep -ohE GigabitEthernet'[[:digit:]]{1}/[[:digit:]]{1}/[[:digit:]]{1,2}' | grep -v $already_mailed_port)
			echo "already = $already_mailed_port and port not match = $port"
			portlookup=$(cat $config | grep $port -A1)
            now=$(date)
            loadedfiles=$(grep -i $logentry -l $targetfiles)
			loadedfiles_for_html_link=$(echo $loadedfiles | cut -d'/' -f3,4,5,6)
            
              		from=myswitch-svr-syslog@myswitchuk.com

			echo "A network security violation has occurred. An unexpected device has been connected to a switch port." >$mailbody
	                echo "" >>$mailbody
        	        echo "Site name:" >>$mailbody
                	echo "$SITE" >>$mailbody
                	echo "" >>$mailbody
                	echo "Trigger time:" >>$mailbody
                	echo "$now" >>$mailbody
                	echo "" >>$mailbody
                	echo "Trigger event (Cisco):" >>$mailbody
                	echo "'$logentry'" >>$mailbody
                	echo "" >>$mailbody
                	echo "Log file:" >>$mailbody
                	echo "$loadedfiles" >>$mailbody
                	echo "" >>$mailbody
					echo "Log File quick link" >>$mailbody
                	echo "http://myswitch-svr-sys.myswitchuk.ad.com/$loadedfiles_for_html_link" >>$mailbody
                	echo "" >>$mailbody
					echo "The port is (switch/module/port):" >>$mailbody
                	echo "$portlookup" >>$mailbody
                	echo "" >>$mailbody
					echo "Details:" >>$mailbody
                	echo "$loadedcontent" >>$mailbody
					echo "" >>$mailbody
                	echo "Full switch configuration file:" >>$mailbody
                	echo "https://acme.sharepoint.com/configs" >>$mailbody
                	echo "" >>$mailbody
                	echo "Useful links:" >>$mailbody
                	echo "https://www.cisco.com/c/en/us/td/docs/switches/lan/catalyst4500/12-2/25ew/configuration/guide/conf/port_sec.html#wp1047696 " >>$mailbody
                	/usr/bin/mail --return-address=$from -s "$subject" "$TO" <$mailbody
			
			exit 0 
			fi

		else

			
		if [ ! -e "$mailbody" ]; then
		
		#No existing mailer file:

		# Send an email alert
		port=$(echo $loadedcontent | grep -ohE GigabitEthernet'[[:digit:]]{1}/[[:digit:]]{1}/[[:digit:]]{1,2}')
		portlookup=$(cat $config | grep $port -A1)
		now=$(date)
		loadedfiles=$(grep -i $logentry -l $targetfiles)
		loadedfiles_for_html_link=$(echo $loadedfiles | cut -d'/' -f3,4,5,6)
		from=myswitch-svr-syslog@myswitchuk.ad.com
		
		echo "A network security violation has occurred. An unexpected device has been connected to a switch port." >$mailbody
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
        echo "http://myswitch-svr-sys.myswitchuk.ad.com/$loadedfiles_for_html_link" >>$mailbody
        echo "" >>$mailbody
		echo "The port is (switch/module/port):" >>$mailbody
		echo "$portlookup" >>$mailbody
		echo "" >>$mailbody
		echo "Details:" >>$mailbody
		echo "$loadedcontent" >>$mailbody
		echo "" >>$mailbody
		echo "Full switch configuration file:" >>$mailbody
		echo "https://acme.sharepoint.com/configs" >>$mailbody
		echo "" >>$mailbody
		echo "Useful links:" >>$mailbody
		echo "https://www.cisco.com/c/en/us/td/docs/switches/lan/catalyst4500/12-2/25ew/configuration/guide/conf/port_sec.html#wp1047696 " >>$mailbody

		/usr/bin/mail --return-address=$from -s "$subject" "$TO" <$mailbody

	fi	
fi
	fi
