FROM jjshin/my_stretch:latest


MAINTAINER Gary Ritchie <gary@garyritchie.com>

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
