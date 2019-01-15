# camunda-docker-ci-mariadb

MariaDB docker image for Jenkins CI builds base on [camunda-ci-base-centos][].

## Additional Packages

- mariadb server

## MariaDB User

- `root` without password
- `camunda` with password `camunda`

## Database

- `process-engine`

## Usage (local)

```
make daemon
```

## Build and test all MariaDB versions

```
make build-all
```

## Check Galera Cluster status

  * connect to cluster with mysql client
  * execute
    ```SHOW GLOBAL STATUS LIKE 'wsrep_%';```


[camunda-ci-base-centos]: https://github.com/camunda-ci/camunda-docker-ci-base-centos
