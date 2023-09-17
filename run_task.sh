#!/bin/bash

TASK_NAME=$1

set -x

./bin/geolocation_service_importer eval "GeolocationServiceImporter.${TASK_NAME}()";
