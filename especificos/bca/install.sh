#!/bin/bash

# ------------------------------------------------------------------------------------------------------
# Instalación aplicaciones:
# Cada aplicación a instalar, configura las variables que corresponden a su aplicación y ejecuta el 
# script de instalacion de aplicación que es común a todas.
#
# ATENCION: 
# - La variable $cliente_url debe ser configurada en environment del deployment del cliente en openshift 
#   con la url del cliente que contiene la configuración particular del mismo (ej: cliente1.datalogic.cloud)
# - La variable $mount_path debe ser configurada en environment del deployment del cliente en openshift con el 
#   path al volumen persistente (mountPath del yaml) ej: /vol01
# ------------------------------------------------------------------------------------------------------

#v_url_instalacion=(viene de script llamador)
#v_ruta_base=(viene de script llamador)

export v_ruta_tmp=/tmp/ibmcloud

# ------------------------------------------------------------------------------------------------------
# Instalación DLPortal
# ------------------------------------------------------------------------------------------------------
#export v_sistema=dlportal
#export v_sistema_ftp=DL-Portal
#export v_ejecutable_instalador=DLPortal_unix_SQLServer_6_2_1.sh
#export v_tipo_descarga="Version"
#
#$v_ruta_base/globales/scripts/install-app.sh

# ------------------------------------------------------------------------------------------------------
# Instalación GIA-WEB
# ------------------------------------------------------------------------------------------------------
export v_sistema=giaweb
export v_sistema_ftp=GIA-WEB
export v_ejecutable_instalador=GIAWeb_unix_6_19_00.sh
export v_tipo_descarga="Beta"

$v_ruta_base/globales/scripts/install-app.sh

# ------------------------------------------------------------------------------------------------------
# Instalación GFE
# ------------------------------------------------------------------------------------------------------
#export v_sistema=gfe
#export v_sistema_ftp=GFE
#export v_ejecutable_instalador=GFE_unix_2_35_00.sh
#export v_tipo_descarga="Beta"
#
#$v_ruta_base/globales/scripts/install-app.sh

