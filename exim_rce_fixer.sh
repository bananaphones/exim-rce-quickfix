#!/bin/bash
rhrelease=/etc/redhat-release
echo "First we will update the Exim, so no new malware could be uploaded"
if [[ -f "$rhrelease" ]]; then
        echo "Centos is installed on server"
	if [[ ! -z  $(rpm -qa | grep exim) ]]; then
        	if [[ "$(cat /etc/redhat-release | tr -dc '0-9.'|cut -d \. -f1)" -gt "6" ]]; then

                	echo "Centos 7. Trying to update Exim and reintall curl"
                	yum install -y -q -e 0 exim  >/dev/null 2>&1
			yum reinstall -y -q -e 0 curl >/dev/null 2>&1
        	else
                	echo "Centos 6 only has fix in testing repo. Installing from it."
			wget https://kojipkgs.fedoraproject.org//packages/exim/4.92/1.el6/x86_64/exim-4.92-1.el6.x86_64.rpm 
			rpm -Fvh exim-4.92-1.el6.x86_64.rpm >/dev/null 2>&1
			yum reinstall -y -q -e 0 curl >/dev/null 2>&1
        	fi
	else 
		echo "No exim installed. We should stop"
		exit 1
	fi
		else
	if [[ ! -z $(dpkg -l | grep exim) ]]; then
		echo "All Debian-based distro should already get the update. Updating"
        	apt-get update >/dev/null 2>&1
        	apt-get --yes --force-yes install exim4 >/dev/null 2>&1
		apt-get --yes --force-yes install --reinstall curl >/dev/null 2>&1
	else
		echo "No exim installed. We shoudl stop"
		exit 1
	fi
fi

if [[ ! -z `grep -Rls tor2web /etc` ]]; then
		echo "Removing Virus, will cause a reboot"
		service crond stop >/dev/null 2>&1
		service cron stop >/dev/null 2>&1
		kill -9 `pgrep kthrotlds` >/dev/null 2>&1
		killall -9 curl wget sh >/dev/null 2>&1
		killall -9 curl wget sh >/dev/null 2>&1
		killall -9 curl wget sh >/dev/null 2>&1
		killall -9 curl wget sh >/dev/null 2>&1
		exipick -i | xargs exim -Mrm >/dev/null 2>&1
		chattr -i   /etc/cron.daily/cronlog /etc/cron.d/root  /etc/cron.d/.cronbus /etc/cron.hourly/cronlog /etc/cron.monthly/cronlog /var/spool/cron/root /var/spool/cron/crontabs/root /etc/cron.d/root /etc/crontab /root/.cache/ /root/.cache/a /usr/local/bin/nptd /root/.cache/.kswapd /usr/bin/\[kthrotlds\] /root/.ssh/authorized_keys /.cache/* /.cache/.sysud /.cache/.a /.cache/.favicon.ico /.cache/.kswapd /.cache/.ntp >/dev/null 2>&1
		rm -rf    /etc/cron.daily/cronlog /etc/cron.d/root  /etc/cron.d/.cronbus /etc/cron.hourly/cronlog /etc/cron.monthly/cronlog /var/spool/cron/root /var/spool/cron/crontabs/root /etc/cron.d/root /etc/crontab /root/.cache/ /usr/local/bin/npt /usr/local/bin/nptd /usr/bin/\[kthrotlds\] /.cache >/dev/null 2>&1
		sed -i -e '/bin\/npt/d' /etc/rc.local >/dev/null 2>&1
		sed -i -e '/user@localhost/d' ~/.ssh/authorized_keys >/dev/null 2>&1
		service crond start >/dev/null 2>&1
		service cron start >/dev/null 2>&1
		exipick -i | xargs exim -Mrm
		echo "fixed"
		reboot
else
		echo "No virus spotted"
fi
