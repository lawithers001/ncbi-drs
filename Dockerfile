FROM ubuntu:latest
# Currently LTS (5 year support). 18.04 likely will roll to 20.04

LABEL author="Kenneth Durbrow" maintainer="kenneth.durbrow@nih.gov"

RUN apt-get -qq update && apt-get -qq install -y \
    apache2 \
    libapache2-mod-wsgi-py3 \
    python3-pip \
 >> /dev/null \
 && pip3 -q install connexion \
 && rm -rf /var/lib/apt/lists \
 && rm `find /var/log -type f`

COPY files/ /
COPY ga4gh /var/www/wsgi-scripts/ga4gh
RUN echo \
    "ServerName 127.0.0.1:80\n" \
    "LogLevel info\n" \
    "ServerSignature Off\n" \
    "ServerTokens Prod\n" >> /etc/apache2/apache2.conf \
 && rm -f /var/www/wsgi-scripts/ga4gh/drs/test_values.py \
 && chmod 755 `find /var/www -type f`

EXPOSE 80

CMD ["/usr/sbin/apache2ctl", "-DFOREGROUND"]
