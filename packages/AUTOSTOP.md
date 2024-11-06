# AUTOSTOP

## Description

This service stops the instance to prevent unexpected charges. The instance will be stopped if it is running and has been running for more than 10 minutes.

## Installation

Just run the following commands to install the service.

```bash
sudo bash -c 'cat > /etc/systemd/system/autostop.service <<EOF
[Unit]
Description=AutoStop

[Service]
Type=simple
ExecStart=/usr/local/bin/autostop.sh

[Install]
WantedBy=multi-user.target
EOF'
```

```bash
sudo bash -c 'cat > /usr/local/bin/autostop.sh <<EOF
#!/bin/bash

LOGFILE=/var/log/autostop.log

# Reset Counter
counter=0

# Print Start Message
echo "\$(date): Starting Autostop Script." >>\$LOGFILE

# Loop
while true; do
  # Check SSH Connection Established on Port 22
  connections=\$(/usr/bin/ss -tnp | /bin/grep ":22" | /bin/grep ESTAB)

  # If There is No Active Connection, Then
  if [ -z "\$connections" ]; then
    # Increment Counter
    counter=\$((counter + 1))
    echo "\$(date): No SSH Connection. Counter: \$counter" >>\$LOGFILE

    # If The Counter Reaches 10 (10 minutes)
    if [ \$counter -ge 10 ]; then
      echo "\$(date): Counter Reached 10, Poweroff." >>\$LOGFILE
      /usr/sbin/shutdown -h now
      exit
    fi
  else
    # Else, Reset Counter
    counter=0
    echo "\$(date): Active SSH Connection Found, Resetting Counter." >>\$LOGFILE
  fi

  # Wait a minute
  /bin/sleep 60
done
EOF'
```

```bash
sudo chmod +x /usr/local/bin/autostop.sh
sudo systemctl enable autostop.service
sudo systemctl start autostop.service
sudo systemctl status autostop.service
```

You can check the log file `/var/log/autostop.log` to see the status of the service.

```bash
cat /var/log/autostop.log
```

## Uninstall

```bash
sudo systemctl stop autostop.service
sudo systemctl disable autostop.service
sudo rm /etc/systemd/system/autostop.service
sudo rm /usr/local/bin/autostop.sh
sudo systemctl daemon-reload
```

## Note

After the first run, you can check the status of the service with the following command.

```bash
sudo systemctl status autostop.service
```
