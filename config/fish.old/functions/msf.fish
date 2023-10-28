function msf -d "Run metasploit console in a container"
  set -lx DB_CONTAINER msf-db
  set -lx MSF_IMAGE 'metasploitframework/metasploit-framework'
  set -lx EXPIRATION_TIME '1 week ago'

  function __is_msf_old
    set -l date_cmd (which gdate; or which date)
    set -l expiration ($date_cmd --date $EXPIRATION_TIME +%s 2>/dev/null)
    set -l created_string (docker image inspect -f '{{.Created}}' metasploitframework/metasploit-framework)
    set -l created_at ($date_cmd  --date $created_string +%s 2>/dev/null)
    if test -z "$expiration"
      echo "coudln't figure out an expiration time"
      return 1
    end
    if test -z "$created_at"
      echo "coudln't figure out a creation time"
      return 1
    end
    test $created_at -lt $expiration
      and return 0
    return 1
  end

  set pull 0


  docker network inspect msf > /dev/null
    or begin
      echo Creating msf docker network
      docker network create msf
    end

  switch (docker container inspect -f '{{.State.Running}}' msf-db)
    case true
      echo database is running
    case false
      echo starting database...
      docker start "$DB_CONTAINER"
    case '*'
      echo Creating metasplot database
      docker run -d \
        --name "$DB_CONTAINER" \
        --network msf \
        -e POSTGRES_PASSWORD=postgres \
        postgres:10-alpine
  end

  if __is_msf_old
    echo msf is kinda old, gonna force a pull
    docker pull $MSF_IMAGE
  end

  docker run --rm -it \
    --name msf \
    --network msf \
    -p 4444:4444 \
    -e "DATABASE_URL=postgres://postgres:postgres@$DB_CONTAINER:5432/msf?pool=200&timeout=5" \
    $MSF_IMAGE

  echo
  echo Stopping the database...
  docker stop "$DB_CONTAINER"
end
