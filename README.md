# GeolocationService.Umbrella

## How to install and run:
* Copy ./docker/.env.example to ./docker/.env 
* Replace variables with your local values

## How to run importer
* populate production database `geolocation_service` using sql dump from ./geolocation_service_importer/priv/import_repo/structure.sql
* Use S3 Bucket to upload your csv dump file and specify it as `export CSV_URL=<URL>` before executing the script
* Execute script `/app/run_import_task.sh import_geolocation_csv_dump` inside docker container

