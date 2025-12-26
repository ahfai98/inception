FROM alpine:3.21

RUN apk add --no-cache ca-certificates

RUN cat <<EOF > /etc/apk/repositories
https://dl-cdn.alpinelinux.org/alpine/v3.21/main
https://dl-cdn.alpinelinux.org/alpine/v3.21/community
EOF

RUN apk add --no-cache nginx openssl curl mariadb-client \
    && mkdir -p /var/log/nginx /run/nginx

COPY ./conf/nginx.conf /etc/nginx/nginx.conf

#x509 creates self signed cert
#days expire
#nodes do not encrypt the private key
#sha digest(hash algorithm used to sign the cert)
RUN	openssl req -x509 -days 365 -nodes -sha256  \
	-subj "/C=MY/ST=KL/O=42/CN=jyap.42.fr"  \
	-out /etc/ssl/self.crt  \
	-keyout /etc/ssl/self.key \
    && chmod 600 /etc/ssl/self.key

COPY ./tool/nginx_setup.sh /nginx_setup.sh
RUN chmod +x /nginx_setup.sh

EXPOSE 443

ENTRYPOINT ["/nginx_setup.sh"]
