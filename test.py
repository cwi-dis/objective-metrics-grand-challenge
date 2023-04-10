# -*- coding: utf-8 -*-
"""
Created on Mon Apr 10 11:41:07 2023

@author: may88
"""

import subprocess
import scipy.io as sio
import numpy as np
import pandas as pd

import prediction

# Call the MATLAB script using the subprocess module
subprocess.call(["matlab", "-r", "script"])

# Load the extracted features
feature_data = sio.loadmat("lcpointpca_feature.mat")
features = np.array(feature_data["lcpointpca"])

feature_name = [item[0][0] for item in feature_data["predictors_name"]]
# Load the pretrained model
model = prediction.load_model("model/PreTrainedModel.pkl")

# Perform inference using the extracted features and the pretrained model
results = prediction.predict(model, features)

result_data = pd.DataFrame(
    results,
    columns=["predictions"],
    index=[item[0][0][:-4] for item in feature_data["stimulus"]],
)

result_data.to_csv("result.csv", index=True)
