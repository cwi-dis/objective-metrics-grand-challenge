import numpy as np
import pandas as pd
import pickle
import scipy.io as sio
import subprocess


def load_model(model_path):
    with open(model_path, "rb") as f:
        # Unpickle model found at path
        return pickle.load(f)


def main():
    # Call the MATLAB script using the subprocess module
    subprocess.call(["matlab", "-r", "script"])

    # Load the extracted features
    feature_data = sio.loadmat("./mat/objective_scores/lcpointpca_features.mat")
    features = np.array(feature_data["lcpointpca"])

    # Load the pretrained model
    model = load_model("./model/Model_Track3.pkl")

    # Perform inference using the extracted features and the pretrained model
    results = model.predict(features)

    # Create dataframe with prediction value for each input
    result_data = pd.DataFrame(
        results,
        columns=["predictions"],
        index=[item[0][0][:-4] for item in feature_data["stimuli"]],
    )

    # Store dataframe as CSV
    result_data.to_csv("results.csv", index=True)


if __name__ == "__main__":
    main()
