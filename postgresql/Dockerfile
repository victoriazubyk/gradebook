FROM postgres:13

ENV PGSSLCERT /ssl/server.crt
ENV PGSSLKEY /ssl/server.key

COPY ./certificates/ /ssl/

RUN gpasswd -a postgres ssl-cert

RUN chown root:ssl-cert ${PGSSLKEY} && chmod 740 ${PGSSLKEY}

CMD ["postgres", "-c", "ssl=on", "-c", "ssl_cert_file=/ssl/server.crt", "-c", "ssl_key_file=/ssl/server.key"]
