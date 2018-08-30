
#!/bin/bash

# Set the working target folders
subfolders=$(find /syslogs -mindepth 3 -type d -regextype posix-extended -regex '.*[[:digit:]]{1,3}')

# Set the retention in days
retention=60

# set the name of the logrotate log
dailylog=logrotate.log

#debug to a file
set -x; exec 2>/root/debug_logrotate.log
	 
	 for i in $subfolders

          do
#	 echo "changing into $i"
          cd $i
                  if [ -f archive.tar.gz ]
                  then
                  gzip -d archive.tar.gz

                  else
                  true
	  fi 
	  
		targetfiles=$(find $i -regextype posix-extended -regex '.*[[:digit:]]{1,3}'  -type f -mtime +$retention)	   
	  
	  
	  		##### Per host directory logging overwritten daily ############################
						
			echo "" >$dailylog			
		    date >>$dailylog
			echo "**This log is overwritten daily." >>$dailylog
            echo "" >$dailylog
			echo "Retention is $retention Days" >>$dailylog
			echo "Adding the following files into the archive" >>$dailylog
            echo "---------------------------------------------" >>$dailylog
            echo "$targetfiles" >>$dailylog
            echo "---------------------------------------------" >>$dailylog
            echo "**********************************************************" >>$dailylog
                        
			# Archive the files and remove them~

			for x in $targetfiles; do tar -rvf archive.tar $x; done
	
			for y in $targetfiles; do 
				echo "Deleting $y" >>$dailylog
		       		rm $y
				done

             	gzip archive.tar
	        
		echo "" >>$dailylog
	
		chmod 770 $dailylog
	
	done	
