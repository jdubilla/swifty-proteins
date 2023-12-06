#!/bin/bash
# wait-for-it.sh

host="mon_mysql"
port="3306"
shift 2
cmd="$@"

apt-get update
apt-get install -y netcat-openbsd

until nc -z -v -w30 $host $port; do
  echo "Attente de la disponibilité de $host:$port..."
  sleep 1
done

>&2 echo "$host:$port est disponible, exécution de la commande : $cmd"

exec $cmd
