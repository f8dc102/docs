#!/bin/bash

LOGFILE=/var/log/autostop.log

# Reset Counter
counter=0

# Print Start Message
echo "$(date): Starting Autostop Script." >>$LOGFILE

# Loop
while true; do
  # Check SSH Connection Established on Port 22
  connections=$(/usr/bin/ss -tnp | /bin/grep ':22' | /bin/grep ESTAB)

  # If There is No Active Connection, Then
  if [ -z "$connections" ]; then
    # Increment Counter
    counter=$((counter + 1))
    echo "$(date): No SSH Connection. Counter: $counter" >>$LOGFILE

    # If The Counter Reaches 10 (10 minutes)
    if [ $counter -ge 10 ]; then
      echo "$(date): Counter Reached 10, Poweroff." >>$LOGFILE
      /usr/sbin/shutdown -h now
      exit
    fi
  else
    # Else, Reset Counter
    counter=0
    echo "$(date): Active SSH Connection Found, Resetting Counter." >>$LOGFILE
  fi

  # Wait a minute
  /bin/sleep 60
done
