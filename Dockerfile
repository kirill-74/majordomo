FROM debian:jessie

RUN apt-get update
RUN apt-get install -y  aptitude
RUN aptitude install -y ntp ntpdate
RUN apt-get install -y apache2 apache2-utils apache2-doc
RUN apt-get install -y php5 php5-cgi php5-cli libapache2-mod-php5 php-pear php5-xcache php5-gd php5-mysql php5-xdebug php5-common php5-dev
RUN apt-get install -y curl libcurl3 libcurl3-dev php5-curl
RUN apt-get install -y wget unzip sudo ssh

RUN useradd md -d /home/md -G sudo -m -U
RUN echo "md" >> passwd md
RUN usermod -aG sudo md
RUN service apache2 stop
RUN a2enmod rewrite

RUN wget -P /root https://github.com/sergejey/majordomo/archive/master.zip
RUN unzip -d /root /root/master.zip

RUN rm -Rf /var/www/*
RUN cp -r /root/majordomo-master/* /var/www
RUN cp -r /root/majordomo-master/.htaccess /var/www
RUN rm -Rf /root/majordomo-master

ADD config.php /var/www/config.php
ADD envvars /etc/apache2/envvars
ADD apache2.conf /etc/apache2/apache2.conf
ADD 000-default.conf /etc/apache2/sites-available/000-default.conf
ADD php.apache.ini /etc/php5/apache2/php.ini
ADD php.cli.ini /etc/php5/cli/php.ini
ADD majordomo /etc/init.d/majordomo


RUN cd /var/www
RUN chown md:md /var/www
RUN chmod 777 /var/www
RUN chown -Rf md:md /var/www/*
RUN chmod -Rf 0777 /var/www/*
RUN chmod -Rf 0777 /var//www
RUN chown md:md /var/lock/apache2
RUN chown md:md /var/log/apache2
RUN chmod 0755 /etc/init.d/majordomo
RUN update-rc.d majordomo defaults
RUN service apache2 start


EXPOSE 80
