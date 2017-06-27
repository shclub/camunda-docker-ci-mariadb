FROM gcr.io/ci-30-162810/centos:v0.1.4

ARG TAG_NAME

# set environment variables for database
ENV DB_USERNAME=camunda \
    DB_PASSWORD=camunda \
    DB_NAME=process-engine \
    TRANSACTION_ISOLATION_LEVEL_MARIADB=REPEATABLE-READ \
    TRANSACTION_ISOLATION_LEVEL_GALERA=READ-COMMITTED

RUN save-env.sh DB_USERNAME DB_PASSWORD DB_NAME TRANSACTION_ISOLATION_LEVEL_MARIADB TRANSACTION_ISOLATION_LEVEL_GALERA

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

# add scripts
ADD bin/* /usr/local/bin/

# add mysql service to supervisor config
ADD etc/supervisord.d/* /etc/supervisord.d/
ADD etc/my.cnf.d/* /tmp/my.cnf.d/

RUN build_container

EXPOSE 3306 4567 4568 4444
