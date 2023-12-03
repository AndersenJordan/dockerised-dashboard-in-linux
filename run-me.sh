#!/bin/bash
# Pull PostgreSQL image from Docker Hub
docker pull postgres:11.22-bullseye
# Create and run a Docker container named 'postgresContainer' using the Docker
# image for PostgreSQL. The container is assigned to port 5432 with a basic
# password (pass123).
docker run --name postgresContainer -d -p 5433:5432 -e POSTGRES_PASSWORD=pass123 postgres:11.22-bullseye
# pip install requirements
python -m pip install -r requirements.txt
# Run Python script to generate results for Tests and Viusalisations and notify
# user whether the script ran successfully
if python assessment-results.py; then
    echo "The Python script assessment-results.py was executed succesfully"
else
    echo "Python script assessment-results.py failed during execution"
fi
# Stop Docker container
docker stop postgresContainer
# Remove Docker container. This line makes the port available once the process
# is complete. If there are changes to be made, the removal of the
# postgresContainer container allows the user to run this bash script without a
# connection conflict.
docker rm postgresContainer