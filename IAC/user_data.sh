#!/bin/bash
set -e

apt update -y
apt install -y docker.io 

systemctl start docker
systemctl enable docker
usermod -aG docker ubuntu
newgrp docker

sleep 20

cd /home/ubuntu

# creating a network
docker network create strapi-net || true

# Start PostgreSQL container
docker run -d \
  --name postgres \
  --network strapi-net \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_DB=postgres \
  -p 5432:5432 \
  -v /srv/pgdata:/var/lib/postgresql/data \
  postgres:15

# Wait for DB to be ready
sleep 20

docker pull manojgovind/sample-strappiapp:latest


docker run -d \
  --name strapi-app \
  --network strapi-net \
  -p 1337:1337 \
  -e DATABASE_CLIENT=postgres \
  -e DATABASE_HOST=postgres \
  -e DATABASE_PORT=5432 \
  -e DATABASE_NAME=postgres \
  -e DATABASE_USERNAME=postgres \
  -e DATABASE_PASSWORD=postgres \
  -e DATABASE_SSL=false \
  -e APP_KEYS=L5I6vf+NNnQIh0UGrTIFnA==,BTZAvKySoeTdpCMtyeZnJg==,JTbllD4Pnier6r3uXQqnmA==,QXL2Hl61igdl9XKFlpcyhw== \
  -e API_TOKEN_SALT=WqtqbTyJqy0iTW65LWmfdQ== \
  -e ADMIN_JWT_SECRET=/JQoGBGNLYFq+YPFSIRniw== \
   manojgovind/sample-strappiapp:latest
