# -*- coding: utf-8 -*-
"""
Created on Sun Apr  9 12:07:43 2023

@author: may88
"""

import pickle
import numpy as np
import pandas as pd
from scipy import stats
import scipy.io
import csv
import sklearn
from sklearn.ensemble import RandomForestRegressor
import joblib


def load_model(model_path):
    with open(model_path, "rb") as f:
        return pickle.load(f)


def predict(model, feature):
    predictions = model.predict(feature.values)
    val_score = pd.DataFrame(
        predictions,
        index=feature.index,
        columns=["predictions"]
    )

    return val_score
