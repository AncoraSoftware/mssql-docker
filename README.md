# Custom Microsoft SQL Server - Ubuntu based image

[![Image tags](https://ghcr-badge.egpl.dev/AncoraSoftware/mssql-docker/tags?color=%2344cc11&ignore=&n=3&label=image+tags)](https://github.com/AncoraSoftware/mssql-docker/pkgs/container/mssql)

```shell
docker pull  ghcr.io/ancorasoftware/mssql:latest
```
## Usage

```bash
MSYS_NO_PATHCONV=1 docker run -e "ACCEPT_EULA=Y" -e 'MSSQL_SA_PASSWORD=yourStrong(!)Password' -e 'MSSQL_PID=Express' -e "MSSQL_DB_NAME=testing" -v "$PWD/sql:/sql" -p 1433:1433 ghcr.io/AncoraSoftware/mssql:latestancorasoftware/mssql:latest  
```

## Enhancements

This image will execute all SQL (`*.sql`) scripts under the `/scripts` directory. The default database targeted by these scripts will be the `$MSSQL_DB_NAME` environment variable (see below).

### Base image environment variables

Additionally, this image supports all of the environment variables supported by the base image:

- `ACCEPT_EULA` - confirms your acceptance of the End-User Licensing Agreement.

- `MSSQL_SA_PASSWORD` - the database system administrator (userid = 'sa') password used to connect to SQL Server once the container is running. Important note: This password needs to include at least 8 characters of at least three of these four categories: uppercase letters, lowercase letters, numbers and non-alphanumeric symbols.

- `MSSQL_PID` is the Product ID (PID) or Edition that the container will run with. Acceptable values:

    - `Developer` - This will run the container using the Developer Edition (this is the default if no MSSQL_PID environment variable is supplied)
    - `Express` : This will run the container using the Express Edition
    - `Standard` : This will run the container using the Standard Edition
    - `Enterprise` : This will run the container using the Enterprise Edition
    - `EnterpriseCore` : This will run the container using the Enterprise Edition Core


For a complete list of environment variables that can be used, [refer to the documentation here](https://hub.docker.com/_/microsoft-mssql-server).
