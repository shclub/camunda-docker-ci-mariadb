FROM gcr.io/ci-30-162810/centos:v0.4.0

ARG TAG_NAME

RUN [ ! -z "${TAG_NAME}" ] || { echo "Please specify a tag name using TAG_NAME build arg"; exit 1; }

# set environment variables for database
ENV DB_USERNAME=camunda \
    DB_PASSWORD=camunda \
    DB_NAME=process-engine \
    TRANSACTION_ISOLATION_LEVEL=READ-COMMITTED \
    MARIADB_OPTS=

RUN save-env.sh DB_USERNAME DB_PASSWORD DB_NAME

# install required packages
RUN install-packages.sh boost-program-options \
                        hostname \
                        iproute \
                        libaio \
                        lsof \
                        net-tools \
                        perl-Data-Dumper \
                        perl-DBI \
                        openssl

COPY bin/* /usr/local/bin/

# add mysql service to supervisor config
COPY etc/supervisord.d/* /etc/supervisord.d/
COPY etc/my.cnf.d/* /tmp/my.cnf.d/

RUN /usr/local/bin/database_install

EXPOSE 3306 4567 4568 4444
