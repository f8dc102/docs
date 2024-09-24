# autostop-ec2

This is a simple script that stops an AWS EC2 instance when it is not in use. It is intended to be run on the instance itself. It is useful for development instances that are not needed outside of working hours.

Example usage:

First, Link the script to the /usr/local/bin directory and the systemd service to the /etc/systemd/system directory.

```bash
sudo ln -s $HOME/autostop/scripts/autostop.service /etc/systemd/system/autostop.service
sudo ln -s $HOME/autostop/scripts/autostop.sh /usr/local/bin/autostop.sh
```

Then, enable and start the service

```bash
sudo systemctl enable autostop.service
sudo systemctl start autostop.service
```

To view the logs, use the following command

```bash
cat /var/log/autostop.log
```
