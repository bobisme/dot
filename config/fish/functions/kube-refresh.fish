# refresh local env vars with kube local stack stuff
function kube-refresh
  echo -n "Refreshing kubernetes environment variables"
  # postgres endpoints
  set -gx PGHOST (kubectl --context local get service postgresql -o json | jq -r .spec.clusterIP)
  set -gx PGUSER postgres
  set -gx PGPASSWORD password

  echo -n "."

  # Refresh local service IPs.
  for l in (kubectl get service --context=local -o json 2>/dev/null | jq -c .items[]);
    set name (echo $l | jq -r .metadata.name | tr a-z A-Z | tr - _)
    set host (echo $l | jq -r .spec.clusterIP)
    set port (echo $l | jq -r .spec.ports[0].port)

    set -gx "$name"_SERVICE_HOST $host
    set -gx "$name"_SERVICE_PORT $port
  end

  echo -n "."

  # Special case: EtcdV3 is translated to ETCDCTL_ENDPOINTS.
  set -gx ETCDCTL_ENDPOINTS $ETCD_SERVICE_HOST:$ETCD_SERVICE_PORT

  echo "Done."
end

