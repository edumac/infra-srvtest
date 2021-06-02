#!/bin/bash

contenedor_a_iniciar=$cliente"-"$puerto
echo "------------------------------------------------------------------------------------------"
echo "-- INICIANDO INSTALACION "$contenedor_a_iniciar
echo "------------------------------------------------------------------------------------------"
echo "docker stop" $contenedor_a_iniciar
docker run -p $puerto:8080 --rm -v /storage:/storage:rw,z --env mount_path="/storage" --env cliente_url="$cliente" --name $contenedor_a_iniciar dl-tomcat-base
echo "------------------------------------------------------------------------------------------"
