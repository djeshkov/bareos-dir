# Bareos Director

[Open Source Data Protection](https://www.bareos.org)

* Based on CentOS7
* **Automatic Database initialization and updates**
* **Out of the box backup system**
* Splitted Config Defaults
* [docker-compose file](docker-compose.yml)

### Bareos Components

* **Director**: Supervises all the backup, restore, verify and archive operations
* [**StorageDeamon**](https://github.com/shoifele/bareos-sd): Service to perform the storage and recovery to the physical backup media or volumes.
* [**FileDeamon**](https://github.com/djeshkov/bareos-fd): Service to perform backups.
* [**WebUI**](https://github.com/shoifele/bareos-ui): Communicate with the Director using a web browser
* **bconsol**: Communicate with the Director using a terminal
* [**Catalog**](https://github.com/sameersbn/docker-postgresql): A (postgres) Databases holding the Directors data

### Try it out 
'''
docker-compose up
'''
### to get ready to use backup system
### Bareos Director

* Image: `djeshkov/bareos-dir`
* Needs: `postgresql`
* Port: `9101`
* ENV-Vars: (For DB auto init/update)
    - `DB_HOST="postgres"`
    - `DB_NAME="bareos"`
    - `DB_USER="bareos"`
    - `DB_PASS="bareos"`
* Volume: `/etc/bareos`


```bash
# Postgres
docker run \
  --rm \
  --name bareos-postgres \
  -v /opt/bareos/postgres:/var/lib/postgresql \
  -e DB_USER=bareos \
  -e DB_PASS=bareos \
  sameersbn/postgresql:9.4-19

# Bareos Director
docker run \
    --rm \
    --name bareos-dir \
    --link bareos-postgres:postgres \
    --link bareos-sd \
    --env DB_PASS=bareos \
    --volume $PWD/bareos-conf:/etc/bareos \
    djeshkov/bareos-dir

# Config check
docker exec bareos-dir bareos-dir -t -c /etc/bareos/bareos-dir.conf

# bconsole
docker exec -ti bareos-dir bconsole

# Config reload
docker exec bareos-dir /bin/bash -c 'echo reload | bconsole'
```

#### TLS Transport Encryption

see [Bareos Manual](http://doc.bareos.org/master/html/bareos-manual-main-reference.html#x1-33500027)

```bash
## Generate Diffie-Hellman Parameter File
openssl dhparam -out dh1024.pem -5 1024

## Certified Authority
# Generate CA Key
openssl genrsa -out ca.key 4096
# Generate CA Cert
openssl req -x509 -new -nodes -extensions v3_ca -key ca.key -days 7300 -out ca.crt -sha512

## Generate the Server Cert
openssl genrsa -out bareos.key 4096
openssl req -new -key bareos.key -out bareos.csr -sha512
openssl x509 -req -in bareos.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out bareos.crt -days 7300 -sha512

### Generate a Cert for reach Client
openssl genrsa -out client1.key 4096
openssl req -new -key client1.key -out client1.csr -sha512
openssl x509 -req -in client1.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out client1.crt -days 7300 -sha512
```

#### Data Encryption

see [Bareos Manual](http://doc.bareos.org/master/html/bareos-manual-main-reference.html#x1-33900028)

```bash
## Generate a Master Key Pair
openssl genrsa -out master.key 2048
openssl req -new -key master.key -x509 -out master.crt

## Generate a File Daemon Key Pair for each FD
openssl genrsa -out storage01.key 2048
openssl req -new -key storage01.key -x509 -out storage01.crt
cat storage01.key storage01.crt > storage01.pem
```
