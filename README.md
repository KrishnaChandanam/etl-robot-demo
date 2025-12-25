# ETL Robot Demo

A minimal Robot Framework suite that validates a CSV-based ETL output. It checks row counts, data quality, business rules, date formatting, and duplicate records in a target CSV file.

## Run With Docker
- Build image: `docker build -t etl-robot-demo .`
- Run tests (outputs to `results/`): `docker run --rm -v "$PWD":/work -w /work etl-robot-demo`

Artifacts are written under `results/` (HTML reports and XMLs). The container runs `robot --outputdir /work/results tests/etl_validation.robot` by default.

## Jenkins Pipeline (Azure VM)
- Prerequisites: Jenkins agent has Docker installed and the `jenkins` user is allowed to run Docker without sudo.
- Pipeline: this repo includes [Jenkinsfile](Jenkinsfile) that:
	- Builds the Docker image
	- Runs Robot tests in a container, writing to `results/`
	- Archives `results/*` and publishes JUnit from `results/xunit.xml`

### Quick setup on Ubuntu-based Azure VM
```bash
sudo apt-get update
sudo apt-get install -y docker.io
sudo usermod -aG docker jenkins
sudo systemctl restart docker
sudo systemctl restart jenkins
```

Then create a Jenkins Pipeline job pointing to this repository (Pipeline script from SCM). Build the job; reports will appear in Jenkins under “Artifacts” and “Test Result”.

## Project Structure
- Tests: [tests/etl_validation.robot](tests/etl_validation.robot)
- Keywords: [libraries/csv_etl_keywords.py](libraries/csv_etl_keywords.py)
- Data: [data/orders_source.csv](data/orders_source.csv), [data/orders_target.csv](data/orders_target.csv)
- Docker: [Dockerfile](Dockerfile), [.dockerignore](.dockerignore)
- CI: [Jenkinsfile](Jenkinsfile)
