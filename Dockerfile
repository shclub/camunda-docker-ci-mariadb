FROM ci1.camunda.loc:5000/camunda-ci-base-centos:latest

# set environment variables for database
ENV DB_USERNAME=camunda \
    DB_PASSWORD=camunda \
    DB_NAME=process-engine \
    MARIADB_VERSION=10.0.17
RUN save-env.sh DB_USERNAME DB_PASSWORD DB_NAME MARIADB_VERSION

# install required packages
RUN install-packages.sh libaio net-tools hostname perl-Data-Dumper perl-DBI

# install mysql standard RPMs
RUN wget -P /tmp/mariadb \
      https://nginx.service.consul/ci/binaries/mariadb/MariaDB-${MARIADB_VERSION}-centos7-x86_64-client.rpm \
      https://nginx.service.consul/ci/binaries/mariadb/MariaDB-${MARIADB_VERSION}-centos7-x86_64-common.rpm \
      https://nginx.service.consul/ci/binaries/mariadb/MariaDB-${MARIADB_VERSION}-centos7-x86_64-server.rpm \
      https://nginx.service.consul/ci/binaries/mariadb/MariaDB-${MARIADB_VERSION}-centos7-x86_64-shared.rpm && \
    rpm -ivh /tmp/mariadb/*.rpm && \
    rm -rf /tmp/mariadb

# add scripts
ADD bin/* /usr/local/bin/

# add mariadb user and create database
RUN /etc/init.d/mysql start && \
    mysql -u root -e "DELETE FROM user WHERE user=''; FLUSH PRIVILEGES;" mysql && \
    mysql -u root -e "GRANT ALL ON *.* TO '$DB_USERNAME'@'%' IDENTIFIED BY '$DB_PASSWORD' WITH GRANT OPTION; FLUSH PRIVILEGES;" && \
    mysql -u root -e "CREATE DATABASE IF NOT EXISTS \`$DB_NAME\` CHARACTER SET utf8 COLLATE utf8_general_ci;" && \
    mysql -u root -e "DROP DATABASE test" && \
    /etc/init.d/mysql stop

# add mysql service to supervisor config
ADD etc/supervisord.d/* /etc/supervisord.d/

# expose mysql port
EXPOSE 3306
