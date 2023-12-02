#!/bin/bash
# Pull PostgreSQL image from Docker Hub
docker pull postgres:11.22-bullseye
# Create and run a Docker container named 'postgresContainer' using the Docker
# image for PostgreSQL. The container is assigned to port 5432 with a basic
# password (pass123).
docker run -d --name postgresContainer -p 5433:5432 -e POSTGRES_PASSWORD=pass123 postgres:11.22-bullseye
# pip install requirements
python -m pip install -r requirements.txt
# Run Python script to generate results for Tests and Viusalisations
python assessment-results.py
# Stop Docker container
docker stop postgresContainer