#!/bin/bash

_term() {
  echo "Stopping SQL Server..."
  pkill -SIGINT -c -e sql
  sleep 2
  pkill -SIGTERM -c -e sql
}

echo "Starting SQL Server..."

# Remove running/healthcheck marker
[ -f "/var/opt/mssql/sql-server-up.marker" ] && rm /var/opt/mssql/sql-server-up.marker

# remove prior runtime log - this outputs to docker anyway.
[ -f "/tmp/sqlserver.log" ] && rm /tmp/sqlserver.log

echo "Blocking outside connections until ready."
iptables-legacy -A INPUT -i lo -p tcp --dport 1433 -j ACCEPT
iptables-legacy -A INPUT -p tcp --dport 1433 -j DROP

# run SQL Server in the background
nohup /opt/mssql/bin/sqlservr --accept-eula 2>&1 > /tmp/sqlserver.log &

# capture the child process reference
child=$!

# start outputting the sqlserver.log to stdout (detached)
tail -q -n 1000 -F /tmp/sqlserver.log &

# trap for SIGTERM, forward to child
trap _term SIGTERM

# wait for SQL Server to be ready to accept connections
grep -q "Service Broker manager has started" <(tail -q -n 1000 -F /tmp/sqlserver.log)
sleep 3
echo "SQL Server Started, "

# Execute user-defined SQL scripts.
if [ -d "/sql" ]; then
  for sql_script in $(ls /sql/*.sql | sort); do
    echo "Executing SQL script: $sql_script" 
    sqlcmd -S localhost -U sa -P $MSSQL_SA_PASSWORD -d master -i "$sql_script" -C
  done
fi

# Unblock/allow connections.
sleep 1
echo "Restoring outside connections."
iptables-legacy -I INPUT -p tcp --dport 1433 -j ACCEPT
touch /var/opt/mssql/sql-server-up.marker
echo "Ready for connections"

wait "$child"
