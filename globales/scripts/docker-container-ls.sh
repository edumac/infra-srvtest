#!/bin/bash

echo "------------------------------------------------------------------------------------------"
echo "-- LISTA DE INSTALACIONES ACTIVAS "
echo "------------------------------------------------------------------------------------------"
# docker container ls --format '{{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}\t{{.Names}}'
docker container ls --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'
echo "------------------------------------------------------------------------------------------"
