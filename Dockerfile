ARG BASE_TAG=2022-CU11-ubuntu-22.04
FROM mcr.microsoft.com/mssql/server:${BASE_TAG}

USER root
ENV DEBIAN_FRONTEND=noninteractive \
    MSSQL_DB_NAME=db

# iptables to restrict access until database is ready
RUN apt-get update \
    && apt-get install -yqq iptables \
    && apt-get clean autoclean \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Add latest matching FTS package
ADD https://packages.microsoft.com/ubuntu/20.04/mssql-server-2019/pool/main/m/mssql-server-fts/mssql-server-fts_15.0.4178.1-3_amd64.deb /root/
RUN dpkg --extract /root/mssql-server-fts_15.0.4178.1-3_amd64.deb / \
    && rm /root/mssql-server-fts_15.0.4178.1-3_amd64.deb

# Add latest mssql-tools
ADD https://packages.microsoft.com/ubuntu/20.04/prod/pool/main/m/mssql-tools/mssql-tools_17.8.1.1-1_amd64.deb /root/
RUN dpkg --extract /root/mssql-tools_17.8.1.1-1_amd64.deb / \
    && rm /root/mssql-tools_17.8.1.1-1_amd64.deb

HEALTHCHECK --timeout=5s --retries=5 \
    CMD /bin/bash -c "test -f /var/opt/mssql/sql-server-up.marker"

COPY ./resources/startup.sh /startup.sh
RUN chmod +x /startup.sh

CMD ["/startup.sh"]
