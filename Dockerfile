FROM ubuntu:16.04

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y  aptitude
RUN aptitude install -y ntp ntpdate
RUN apt-get install -y apache2 apache2-bin apache2-data apache2-utils 
RUN apt-get install -y libapache2-mod-php libapache2-mod-php7.0 
RUN apt-get install -y php7.0-bz2 php7.0-cli php7.0-common 
RUN apt-get install -y php7.0-curl php7.0-gd php7.0-json php7.0-mbstring 
RUN apt-get install -y php7.0-mcrypt php7.0-mysql 
RUN apt-get install -y php7.0-opcache php7.0-readline 
RUN apt-get install -y php7.0-xml phpmyadmin
RUN apt-get install -y dbconfig-mysql mysql-client-5.7 mysql-client-core-5.7 mysql-common php-mysql php7.0-mysql
RUN apt-get install -y curl libcurl3 libcurl3-dev
RUN apt-get install -y nano wget unzip sudo ssh

RUN service apache2 stop
RUN a2enmod rewrite
RUN ln -s /usr/share/phpmyadmin /var/www/phpmyadmin

RUN wget -P /root https://github.com/sergejey/majordomo/archive/master.zip
RUN unzip -d /root /root/master.zip

RUN rm -Rf /var/www/*
RUN cp -r /root/majordomo-master/* /var/www
RUN cp -r /root/majordomo-master/.htaccess /var/www
RUN rm -Rf /root/majordomo-master

ADD config.php /var/www/config.php
ADD apache2.conf /etc/apache2/apache2.conf
ADD 000-default.conf /etc/apache2/sites-available/000-default.conf
ADD php.apache.ini /etc/php/7.0/apache2/php.ini
ADD php.cli.ini /etc/php/7.0/cli/php.ini
ADD majordomo.service /etc/systemd/system/majordomo.service

VOLUME /var/www
VOLUME /etc

RUN cd /var/www
RUN chown www-data:www-data /var/www
RUN chmod 777 /var/www
RUN chown -Rf www-data:www-data /var/www/*
RUN chmod -Rf 0777 /var/www/*
RUN chmod -Rf 0777 /var//www
RUN chown www-data:www-data /var/lock/apache2
RUN chown www-data:www-data /var/log/apache2
RUN systemctl enable majordomo
RUN apache2ctl restart


EXPOSE 80
EXPOSE 22
