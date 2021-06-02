#!/bin/bash

contenedor_a_detener=$cliente+"-"+$puerto
echo "------------------------------------------------------------------------------------------"
echo "-- DETENIENDO INSTALACION "$contenedor_a_detener
echo "------------------------------------------------------------------------------------------"
echo "docker stop" $contenedor_a_detener
docker stop $contenedor_a_detener
echo "------------------------------------------------------------------------------------------"
