FROM grandchallenge_toolboxes:r2022a

WORKDIR /app
USER root

RUN apt-get update
RUN apt-get install -y python3-pip

ADD requirements.txt .

RUN pip3 install -r requirements.txt

ADD Matlab_FeatureExtraction/script.m .
ADD Matlab_FeatureExtraction/feature_extraction.m .
ADD Matlab_FeatureExtraction/lib .

ADD prediction.py .
ADD test.py .
