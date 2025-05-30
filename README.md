# experiment-last-merge

This repository is a replication package for an experiment comparing **LASTMerge**—a generic structured merge tool—with existing state-of-the-art merge tools.

## Running the Experiment

1. **Configuration**  
    Create a `.env.local` file to configure the experiment. You can use the provided `.env` file as a template.

2. **GitHub Personal Access Token (PAT)**  
    You must create a GitHub PAT to run the experiment. This is required for pushing results to the analysis repository and for running test execution analysis.

3. **Running with Docker**  
    The experiment is packaged as a Docker image. To run the experiment using the pre-built image, execute:
    ```bash
    bash start-experiment-remote-image.sh
    ```
    If you wish to modify the image and build it locally, use:
    ```bash
    bash start-experiment.sh
    ```

4. **Customizing Evaluation**  
    You can customize the projects and commits used in the evaluation by editing the `input/commits.csv` and `input/projects.csv` files.

5. **Analysis Scripts**  
    All scripts for analyzing results are located in the `analysis` folder. Most analyses are performed using Jupyter notebooks and auxiliary Python functions.
