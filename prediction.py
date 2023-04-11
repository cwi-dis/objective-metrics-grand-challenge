import pickle
import pandas as pd


def load_model(model_path):
    with open(model_path, "rb") as f:
        return pickle.load(f)


def predict(model, features):
    return model.predict(features)
