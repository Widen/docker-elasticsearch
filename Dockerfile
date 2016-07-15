FROM quay.io/widen/oracle-server-jre:8

ENV DEBIAN_FRONTEND noninteractive
ENV BUILD_DEPS "curl ca-certificates"

ARG MAJOR_VERSION
ENV MAJOR_VERSION ${MAJOR_VERSION}

ARG MINOR_VERSION
ENV MINOR_VERSION ${MINOR_VERSION}

ARG REVISION
ENV REVISION ${REVISION}

RUN groupadd -g 1000 elasticsearch && useradd elasticsearch -u 1000 -g 1000
RUN apt-get update && \
  apt-get -y --no-install-recommends install ${BUILD_DEPS} && \
  curl --silent --location --retry 3 -o /tmp/elasticsearch-${MAJOR_VERSION}.${MINOR_VERSION}.${REVISION}.deb \
    https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/deb/elasticsearch/${MAJOR_VERSION}.${MINOR_VERSION}.${REVISION}/elasticsearch-${MAJOR_VERSION}.${MINOR_VERSION}.${REVISION}.deb && \
  dpkg -i /tmp/elasticsearch-${MAJOR_VERSION}.${MINOR_VERSION}.${REVISION}.deb && \
  apt-get -y --purge remove ${BUILD_DEPS} && \
  apt-get -y --purge autoremove && apt-get -y clean && \
  rm -rf /var/lib/apt/lists/* /var/cache/debconf/* /tmp/* /var/tmp/*

WORKDIR /usr/share/elasticsearch

RUN set -ex && for path in data logs config config/scripts; do \
    mkdir -p "${path}"; \
    chown -R elasticsearch:elasticsearch "${path}"; \
  done

USER elasticsearch

ENV PATH ${PATH}:/usr/share/elasticsearch/bin

ENTRYPOINT ["elasticsearch"]
