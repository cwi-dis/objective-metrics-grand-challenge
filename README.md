# 2023 Grand Challenge on Objective Quality Metrics for Volumetric Contents

This repository contains the files for building the container for the
Objective Quality Metrics Grand Challenge.

## Building the container

The container can be built as such:

    docker build -t grandchallenge .

After that the build container is available under the tag
`grandchallenge:latest`.

### Building the base image

Keep in mind that the image is based on the `mathworks/matlab:r2022a` image
with the `Computer Vision` and the `Statistics and Machine Learning` installed.
To create this image, run the following command:

    docker run --init -it -p 5902:5901 -p 6081:6080 --shm-size=512M mathworks/matlab:r2022a -vnc

Then, in a web browser, go to `http://localhost:6081` and install the required
toolboxes. With the container still running, tag a new image:

    docker commit --change 'ENTRYPOINT ["/bin/run.sh"]' [IMAGE_ID] grandchallenge_toolboxes:r2022a

Where `[IMAGE_ID]` is the container ID of the running Matlab container. After
that be base image can be built using the command at the beginning of this
section.

## Running the container

To run the container and obtain the results, run the following command:

    docker run -v [DATASET_DIR]:/app/dataset/ -v [MODEL_DIR]:/app/model/ grandchallenge python test.py

Where `[DATASET_DIR]` is the path to the directory containing the data set and
`[MODEL_DIR]` is the path to the directory containing the model.

After the container has finished running, the results can be extracted using
the following command:

    docker cp [IMAGE_ID]:/app/result.csv results.csv

Where `[IMAGE_ID]` is the ID of the container that computed the results.
