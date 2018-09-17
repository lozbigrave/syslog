
#!/bin/bash

set -x; exec 2>/root/debug_logrotate.log

subfolders=$(find /syslogs -mindepth 3 -type d -regextype posix-extended -regex ".*[[:digit:]]{1,3}")
retention=60
masterlog=/root/logrotate.masterlog

# Update the master log file
echo "**This log is overwritten daily**" >$masterlog
date >>$masterlog	 
echo "Retention is $retention Days" >>$masterlog
echo "Adding the following files into the archive:" >>$masterlog
echo "---------------------------------------------" >>$masterlog

# Begin the archive process: 

	for i in $subfolders

          do

          cd $i

      	       	if [ -f archive.tar.gz ]
                  then
		  echo "debug: archive exists, extracting"  
                  gzip -d archive.tar.gz

                  else
                  echo "debug: archive does not exist, nothing to extract"
		  #true
	  fi 
		targetfiles=$(find $i -regextype posix-extended -regex ".*[[:digit:]]{1,3}"  -type f -mtime +$retention)	   
	  
			echo "$targetfiles" >>$masterlog
			
			echo "**This log is overwritten daily**" >logrotate.log
			date >>logrotate.log	 
			echo "Retention is $retention Days" >>logrotate.log
			echo "Adding the following files into the archive:" >>logrotate.log
			echo "---------------------------------------------" >>logrotate.log
			echo "$targetfiles" >>logrotate.log


				for x in $targetfiles
				do tar -rvf archive.tar $x
				rm $x	
			    done
			
             	gzip archive.tar
	        
			echo "---------------------------------------------" >>logrotate.log
                echo "Have a nice day :)" >>logrotate.log

	done

		chmod 770 $masterlog	
