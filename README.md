# Bareos Director

* Based on CentOS7
* **Automatic Database initialization and updates**
* Splitted Config Defaults
* [docker-compose file](docker-compose.yml)

### Bareos Components

* **Director**: Supervises all the backup, restore, verify and archive operations
* **StorageDeamon**: Service to perform the storage and recovery to the physical backup media or volumes.
* **WebUI**: Communicate with the Director using a web browser
* **bconsol**: Communicate with the Director using a terminal
* **Catalog**: A (postgres) Databases holding the Directors data


### Bareos Director

* Image: `shoifele/bareos-dir`
* Needs: `postgresql`
* Port: `9101`
* ENV-Vars: (For DB auto init/update)
    - `DB_HOST="postgres"`
    - `DB_NAME="bareos"`
    - `DB_USER="bareos"`
    - `DB_PASS="bareos"`
* Volume: `/etc/bareos`


```bash

# Run
docker run \
    --rm \
    --name bareos-dir \
    --link postgres \
    --link bareos-sd \
    --env DB_PASS=bareos \
    --volume $PWD/bareos-conf:/etc/bareos \
    shoifele/bareos-dir

# Config check
docker exec bareos-dir bareos-dir -t -c /etc/bareos/bareos-dir.conf

# bconsole
docker exec -ti bareos-dir bconsole

# Config reload
docker exec bareos-dir /bin/bash -c 'echo reload | bconsole'
```