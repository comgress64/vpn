# Original credit: https://github.com/jpetazzo/dockvpn

# Smallest base image
FROM alpine:latest

MAINTAINER Nikita Melnikov <ku3ku3@gmail.com>

ENV TIMEZONE Europe/London
ENV PHP_MEMORY_LIMIT 512M
ENV MAX_UPLOAD 50M
ENV PHP_MAX_FILE_UPLOAD 200
ENV PHP_MAX_POST 100M

RUN echo "http://dl-4.alpinelinux.org/alpine/edge/community/" >> /etc/apk/repositories && \
    echo "http://dl-4.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories && \
    apk update && apk upgrade && apk add --update tzdata && \
    cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
    apk add --update openvpn iptables bash easy-rsa openvpn-auth-pam google-authenticator pamtester openssh ip6tables \
	php7-mcrypt php7-openssl php7-json php7-fpm php7-mbstring php7-curl php7-posix php7-xml php7-session nginx sudo && \
    sed -i "s|listen = 127.0.0.1:9000|listen = /var/www/.sock|g" /etc/php7/php-fpm.d/www.conf && \
    sed -i "s|;listen.owner = nobody|listen.owner=nginx|" /etc/php7/php-fpm.d/www.conf && \
    sed -i "s|;*date.timezone =.*|date.timezone = ${TIMEZONE}|i" /etc/php7/php.ini && \
    sed -i "s|;*memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|i" /etc/php7/php.ini && \
    sed -i "s|;*upload_max_filesize =.*|upload_max_filesize = ${MAX_UPLOAD}|i" /etc/php7/php.ini && \
    sed -i "s|;*max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|i" /etc/php7/php.ini && \
    sed -i "s|;*post_max_size =.*|post_max_size = ${PHP_MAX_POST}|i" /etc/php7/php.ini && \
    sed -i "s|;*cgi.fix_pathinfo=.*|cgi.fix_pathinfo= 0|i" /etc/php7/php.ini && \
    ln -s /usr/share/easy-rsa/easyrsa /usr/local/bin && \
    apk del tzdata && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/* /var/www/* && \
    mkdir /run/nginx && \
    echo 'nobody ALL=(root) NOPASSWD:/usr/local/bin/gen,/usr/local/bin/susp,/usr/local/bin/unsusp,/usr/local/bin/remove,/usr/local/bin/fw' >> /etc/sudoers && \
    echo 'Defaults env_keep += "OPENVPN EASYRSA EASYRSA_PKI EASYRSA_VARS_FILE PATH"' >> /etc/sudoers


# Needed by scripts
ENV OPENVPN /etc/openvpn
ENV EASYRSA /usr/share/easy-rsa
ENV EASYRSA_PKI $OPENVPN/pki
ENV EASYRSA_VARS_FILE $OPENVPN/vars

VOLUME ["/etc/openvpn"]

# Internally uses port 1194/udp, remap using `docker run -p 443:1194/tcp`
EXPOSE 22 1194

CMD ["ovpn_run"]

ADD ./sshd.env /etc/profile.d/sshd.sh
ADD ./bin /usr/local/bin
ADD ./sshd/* /etc/ssh/
ADD ./authorized_keys /root/.ssh/authorized_keys
ADD ./nginx.conf /etc/nginx/conf.d/default.conf
RUN chmod 600 /etc/ssh/*_key
RUN chmod a+x /usr/local/bin/*
RUN sed -i /etc/ssh/sshd_config -e 's/#UseDNS/UseDNS/'

