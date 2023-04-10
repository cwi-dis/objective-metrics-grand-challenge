# -*- coding: utf-8 -*-
"""
Created on Mon Apr 10 11:41:07 2023

@author: may88
"""

import subprocess
import sys
import scipy.io as sio
import numpy as np
import pandas as pd

import prediction

model_path = '/app/model/PreTrainedModel.pkl'

# Define the paths to the reference and distorted datasets
ref_data_path = '/DataSet/ref/'
dis_data_path = '/DataSet/dis/'

# Call the MATLAB script using the subprocess module
subprocess.call(["matlab", "-r", "script"])

# Load the extracted features
feature_data = sio.loadmat("/app/mat/objective_scores/lcpointpca_feature.mat")
features = np.array(feature_data["lcpointpca"])

feature_name = [item[0][0] for item in feature_data['predictors_name']]
test_data = pd.DataFrame(
    features,
    index=[item[0][0][:-4] for item in feature_data['stimulus']],
    columns=feature_name
)

# Load the pretrained model
model = prediction.load_model(model_path)

# Perform inference using the extracted features and the pretrained model
results = prediction.predict(features, model)
results.to_csv("result.csv", index=True)
