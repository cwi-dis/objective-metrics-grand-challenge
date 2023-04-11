#!/bin/bash

if [ $# -ne 2 ]; then
  echo "USAGE: $0 dataset_dir model_dir"
  exit 1
fi

docker run -v ${1}:/app/dataset/ -v ${2}:/app/model/ --shm-size=512M grandchallenge python test.py 2>/dev/null

container_id=`docker ps -a -q |head -n1`
docker cp ${container_id}:/app/results.csv results.csv
docker rm $container_id
