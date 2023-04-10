# -*- coding: utf-8 -*-
"""
Created on Sun Apr  9 12:07:43 2023

@author: may88
"""

import pickle
import pandas as pd


def load_model(model_path):
    with open(model_path, "rb") as f:
        return pickle.load(f)


def predict(model, features):
    predictions = model.predict(features)
    return predictions
