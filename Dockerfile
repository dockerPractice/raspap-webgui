# FROM armv7/armhf-ubuntu:yakkety
# FROM resin/raspberrypi3-python:3-slim-20171125
# FROM resin/raspberry-pi3-debian:wheezy-2017042
 FROM jjshin/my_stretch:latest


MAINTAINER Gary Ritchie <gary@garyritchie.com>

# RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0x908332071dd2e32e
# RUN echo "deb http://deb.best-hosting.cz/debian/ wheezy main" > /etc/apt/sources.list.d/best-hosting.list

#RUN wget https://archive.raspbian.org/raspbian.public.key -O - | sudo apt-key add -

########
## RUN echo "deb http://archive.raspbian.org/raspbian wheezy main contrib non-free" > /etc/apt/sources.list
## RUN echo "deb-src http://archive.raspbian.org/raspbian wheezy main contrib non-free" >> /etc/apt/sources.list

# RUN echo "deb http://httpredir.debian.org/debian wheezy main" > /etc/apt/sources.list
# RUN echo "deb http://httpredir.debian.org/debian wheezy-updates main" >> /etc/apt/sources.list
# RUN echo "deb http://security.debian.org wheezy/updates main" >> /etc/apt/sources.list

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -q -y install \
        apt-utils \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common \
        nano \
        sudo \
        net-tools \
        wireless-tools \
        lighttpd \
        php-cgi \
        git \
        && apt-get clean

 RUN apt-get install -y git lighttpd php7.0-cgi hostapd dnsmasq

 RUN lighttpd-enable-mod fastcgi-php
 RUN /etc/init.d/lighttpd restart
 RUN service lighttpd restart

# AP stuff
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -q -y install \
        wget \
        unzip \
        hostapd \
        bridge-utils \
#       rfkill \
        hostap-utils \
        iw \
        dnsmasq \
        wpasupplicant \
        && apt-get clean
        #wicd-cli \

## Add the following to the end of /etc/sudoers:

 RUN wget -q https://git.io/voEUQ -O /tmp/raspap
 RUN echo 'www-data ALL=(ALL) NOPASSWD: ALL\n%www-date ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/www-data

 RUN chmod 0440 /etc/sudoers.d/www-data
 RUN git clone https://github.com/billz/raspap-webgui /var/www/ap
 RUN chown -R www-data:www-data /var/www

EXPOSE 80
EXPOSE 100

 ENTRYPOINT ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
