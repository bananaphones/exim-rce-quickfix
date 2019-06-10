#!/bin/bash
rhrelease=/etc/redhat-release
echo "First we will update the Exim, so no new malware could be uploaded"
if [[ -f "$rhrelease" ]]; then
        echo "Centos is installed on server"
	if [[ ! -z  $(rpm -qa | grep exim) ]]; then
        	if [[ "$(cat /etc/redhat-release | tr -dc '0-9.'|cut -d \. -f1)" -gt "6" ]]; then

                	echo "Centos 7. Trying to update Exim and reintall curl"
                	yum install -y -q -e 0 exim   2>&1
			yum reinstall -y -q -e 0 curl  2>&1
        	else
                	echo "Centos 6 only has fix in testing repo. Installing from it."
			wget https://kojipkgs.fedoraproject.org//packages/exim/4.92/1.el6/x86_64/exim-4.92-1.el6.x86_64.rpm 
			rpm -Fvh exim-4.92-1.el6.x86_64.rpm  2>&1
			yum reinstall -y -q -e 0 curl  2>&1
        	fi
	else 
		echo "No exim installed. We should stop"
		exit 1
	fi
		else
	if [[ ! -z $(dpkg -l | grep exim) ]]; then
		echo "All Debian-based distro should already get the update. Updating"
        	apt-get update  2>&1
        	apt-get --yes --force-yes install exim4  2>&1
		apt-get --yes --force-yes install --reinstall curl  2>&1
	else
		echo "No exim installed. We shoudl stop"
		exit 1
	fi
fi

if [[ ! -z `grep -Rls tor2web /etc` ]]; then
		echo "Removing Virus, will cause a reboot"
		service crond stop  2>&1
		service cron stop  2>&1
		kill -9 `pgrep kthrotlds`  2>&1
		killall -9 curl wget sh  2>&1
		killall -9 curl wget sh  2>&1
		killall -9 curl wget sh  2>&1
		killall -9 curl wget sh  2>&1
		exipick -i | xargs exim -Mrm  2>&1
		chattr -i   /etc/cron.daily/cronlog /etc/cron.d/root  /etc/cron.d/.cronbus /etc/cron.hourly/cronlog /etc/cron.monthly/cronlog /var/spool/cron/root /var/spool/cron/crontabs/root /etc/cron.d/root /etc/crontab /root/.cache/ /root/.cache/a /usr/local/bin/nptd /root/.cache/.kswapd /usr/bin/\[kthrotlds\] /root/.ssh/authorized_keys /.cache/* /.cache/.sysud /.cache/.a /.cache/.favicon.ico /.cache/.kswapd /.cache/.ntp  2>&1
		rm -rf    /etc/cron.daily/cronlog /etc/cron.d/root  /etc/cron.d/.cronbus /etc/cron.hourly/cronlog /etc/cron.monthly/cronlog /var/spool/cron/root /var/spool/cron/crontabs/root /etc/cron.d/root /etc/crontab /root/.cache/ /usr/local/bin/npt /usr/local/bin/nptd /usr/bin/\[kthrotlds\] /.cache  2>&1
		sed -i -e '/bin\/npt/d' /etc/rc.local  2>&1
		sed -i -e '/user@localhost/d' ~/.ssh/authorized_keys  2>&1
		exipick -i | xargs exim -Mrm
		service crond start  2>&1
		service cron start  2>&1
		echo "fixed"
		reboot
else
		echo "No virus spotted"
fi
