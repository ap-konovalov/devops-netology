FROM elasticsearch:7.17.2
MAINTAINER Konovalov Aleksandr

ENV PATH_ES=/usr/share/elasticsearch

COPY elasticsearch.yml ${PATH_ES}/config

RUN mkdir /var/lib/logs \
    && chown elasticsearch:elasticsearch /var/lib/logs \
    && mkdir /var/lib/data \
    && chown elasticsearch:elasticsearch /var/lib/data \
    && chown -R elasticsearch:elasticsearch ${PATH_ES} \
    && mkdir ${PATH_ES}/snapshots \
    && chown elasticsearch:elasticsearch ${PATH_ES}/snapshots

EXPOSE 9200 9300

USER elasticsearch

CMD ["/usr/sbin/init"]
#CMD ["/etc/elasticsearch-7.17.2/bin/elasticsearch"]
CMD ["/usr/local/bin/docker-entrypoint.sh"]