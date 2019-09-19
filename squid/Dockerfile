FROM fedora:30

RUN dnf install squid openssl which -y && \
    dnf clean all

COPY squid.conf /etc/squid/squid.conf

EXPOSE 3128 3130
CMD ["/usr/sbin/squid", "--foreground"]
