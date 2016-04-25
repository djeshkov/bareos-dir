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


