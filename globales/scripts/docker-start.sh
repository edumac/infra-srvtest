#!/bin/bash

echo "------------------------------------------------------------------------------------------"
echo "-- INICIANDO INSTALACION "
echo "------------------------------------------------------------------------------------------"
echo " Cliente..: "$cliente
echo " Puerto...: "$puerto
echo " Parametros: "
echo $parametros_instalacion
echo $parametros_instalacion > /storage/infra-srvtest/parametros_instalacion.txt
echo "------------------------------------------------------------------------------------------"
echo ""

echo "------------------------------------------------------------------------------------------"
echo "-- CONSUMO DE RECURSOS DE LAS INSTALACIONES ACTIVAS "
echo "------------------------------------------------------------------------------------------"
docker stats --no-stream
echo "------------------------------------------------------------------------------------------"
