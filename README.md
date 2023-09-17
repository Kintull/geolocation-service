# GeolocationService.Umbrella
Geolocation service. Gets access to geolocation using API by providing IP address. Import your geolocation dump from a CSV stored in S3 bucket. 

## How to run geolocation API in a docker locally (tested on MacOS 12.4, M1 chip)
* start database `docker-composer up -d db` (password: postgres)
* create database `geolocation_service`: `psql -h localhost -U postgres -c 'create database geolocation_service;'`
* import database schema `psql -h localhost -U postgres -d geolocation_service < ./apps/geolocation_service_importer/priv/import_repo/structure.sql` 
* build docker container `docker build -t geolocation_service:latest -f ./docker/Dockerfile .`
* start web application `docker-compose up -d web`
* Access geolocation API via http://localhost:4000/

## How to run importer
* Use S3 Bucket to upload your csv dump file, make it public, get URL
* Open docker-compose.yml, update CSV_URL variable with your URL
* Start importer `docker-composer up -d importer`



