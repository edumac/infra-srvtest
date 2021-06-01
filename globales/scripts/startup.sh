#!/bin/bash

# VARIABLES
# ruta_tomcat=(viene cargada desde script llamador run-start.sh)
# ruta_base=(viene cargada desde script llamador run-start.sh)

# CONFIGURACION DE TOMCAT
# En este script (setenv.sh) se pueden cargar configuraciones especificas del tomcat que se ejecutara en esta 
# instalacion, por ejemplo limite de memoria.
echo "=== Aplicando configuracion de Tomcat..."
$v_ruta_base/especificos/$v_url_instalacion/configuraciones/tomcat/setenv.sh

# EJECUCIÓN DE INSTALADORES
# En este script se especifican los sistemas que se instalaran en esta instalacion, incluyendo version del sistema a instalar
echo "=== Iniciando ejecucion instaldores configurados para el cliente $v_url_instalacion..."
$v_ruta_base/especificos/$v_url_instalacion/install.sh

# INICIO DE TOMCAT
# Luego de la configuracion de tomcat y la instalacion de las aplicaciones, se inicia el tomcat.
echo "=== Iniciando Tomcat..."
$v_ruta_tomcat/bin/catalina.sh run