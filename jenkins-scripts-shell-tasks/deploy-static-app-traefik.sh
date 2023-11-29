#!/bin/bash

IMAGE_NAME="YOUR_IMAGE_NAME"
DOMAIN="your-domain.com"

docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} .

container_id=$(docker ps -q --filter name=${IMAGE_NAME})

if [ -n "$container_id" ]; then
  docker stop "$container_id"
  docker rm "$container_id"
  echo "Detenido y eliminado el contenedor $container_id"
else
  echo "No se encontró un contenedor con el nombre '${IMAGE_NAME}'."
fi

docker run -d \
	-l "traefik.enable=true" \
    -l "traefik.http.routers.${IMAGE_NAME}.rule=Host(\`${DOMAIN}\`)" \
    -l "traefik.http.routers.${IMAGE_NAME}.service=${IMAGE_NAME}" \
    -l "traefik.http.routers.${IMAGE_NAME}.tls=true" \
    -l "traefik.http.routers.${IMAGE_NAME}.tls.certResolver=letsEncrypt" \
    -l "traefik.http.routers.${IMAGE_NAME}.entryPoints=https" \
    -l "traefik.http.services.${IMAGE_NAME}.loadbalancer.server.port=80" \
    -l "traefik.docker.network=traefik-net" \
    --name ${IMAGE_NAME} \
    --network traefik-net \
    ${IMAGE_NAME}:${BUILD_NUMBER}