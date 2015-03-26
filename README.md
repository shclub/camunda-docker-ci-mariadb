camunda-docker-ci-mariadb
=========================

MariaDB docker image for Jenkins CI builds base on [camunda-ci-base-centos][].

# Additional Packages

  - mariadb server

# MariaDB User

  - `root` without password
  - `camunda` with password `camunda`

# Database

  - `process-engine`

# Usage (local)

```
# Start docker container
docker run -d -p 3306:3306 camunda/camunda-ci-mariadb
# Connect to docker mariadb (password: camunda)
mysql -u camunda -p -h 127.0.0.1
```


[camunda-ci-base-centos]: https://github.com/camunda-ci/camunda-docker-ci-base-centos
