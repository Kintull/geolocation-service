#!/bin/bash

TASK_NAME=$1

set -x

/app/geolocation_service_importer/bin/geolocation_service_importer eval "GeolocationServiceImporter.${TASK_NAME}()";
