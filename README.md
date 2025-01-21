# Custom Microsoft SQL Server - Ubuntu based image

![base image](https://img.shields.io/badge/base_image-ghcr%2eio%2fancorasoftware%2fmssql-lime)
[![Image tags](https://ghcr-badge.egpl.dev/AncoraSoftware/mssql/tags?color=%2344cc11&n=6&label=image+tags)](https://github.com/AncoraSoftware/mssql-docker/pkgs/container/mssql)
![alt text](image.png)




```shell
docker pull  ghcr.io/AncoraSoftware/mssql:2022-latest
```
## Usage

```bash
MSYS_NO_PATHCONV=1 docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=yourStrong(!)Password" -e "MSSQL_PID=Express" -v "$PWD/sql:/sql" -p 1433:1433 ghcr.io/ancorasoftware/mssql:2022-latest
```

### Startup SQL scripts

All SQL scripts (`*.sql`) mounted in the `/sql` will be executed during container startup as means of provisioning databases and performing SQL-based migrations. The default database targeted by these scripts is the `master` database; the `USE` statement must be used accordingly.

### Configuration

This image supports all of the environment variables supported by the base image, notably:

- `ACCEPT_EULA` - confirms your acceptance of the End-User Licensing Agreement.

- `MSSQL_SA_PASSWORD` - the database system administrator (userid = 'sa') password used to connect to SQL Server once the container is running. Important note: This password needs to include at least 8 characters of at least three of these four categories: uppercase letters, lowercase letters, numbers and non-alphanumeric symbols.

- `MSSQL_PID` is the Product ID (PID) or Edition that the container will run with. Acceptable values:

    - `Developer` - This will run the container using the Developer Edition (this is the default if no MSSQL_PID environment variable is supplied)
    - `Express` : This will run the container using the Express Edition
    - `Standard` : This will run the container using the Standard Edition
    - `Enterprise` : This will run the container using the Enterprise Edition
    - `EnterpriseCore` : This will run the container using the Enterprise Edition Core


For a complete list of environment variables that can be used, [refer to the documentation here](https://hub.docker.com/_/microsoft-mssql-server).
