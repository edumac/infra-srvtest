#!/bin/bash

# ATENCION: 
# - La variable $cliente_url debe ser configurada en environment del deployment del cliente en openshift 
#   con la url del cliente que contiene la configuración particular del mismo (ej: cliente1.datalogic.cloud)
# - La variable $mount_path debe ser configurada en environment del deployment del cliente en openshift con el 
#   path al volumen persistente (mountPath del yaml) ej: /vol01

# Estas variables se usaran en los scripts invocados (por eso se usa export).
export v_git_repo_url="https://github.com/edumac/ibmcloud.git"
export v_ruta_base=$mount_path/ibmcloud
export v_url_instalacion=$cliente_url
export v_ruta_tomcat=/usr/local/tomcat

# Variables locales
error_detectado=""

echo "=== Iniciando ejecucion de contenedor..."

echo "=== Veriicando variables de entorno para la ejecucion..."
# Validacion de variable de entorno mount_path
if [ -z "$mount_path" ]
then 
   error_detectado="=== [ERROR] la variable de entorno 'mount_path' no ha sido configurada en el deploy, debe definirla en environment del deploy con la ruta donde esta montado el filesystem persistido (ej: /vol01)"
else 
   # Si no existe la carpeta del mount_path...
   if [ ! -d "$mount_path" ]
   then 
      error_detectado="=== [ERROR] la variable de entorno 'mount_path' ha sido configurada con una ruta inexistente: " $mount_path
   else
      # La carpeta del volumen persistido existe, por lo tanto se procede con la 
      # inicializacion o actualizacion el repositorio de la configuracion desde repo git...
      echo "=== Actualizando repositorio de configuraciones..."
      echo "=== Git repo URL...: " $v_git_repo_url
      echo "=== Carpeta local..: " $v_ruta_base
      if [ ! -d "$v_ruta_base" ] ; then
         git clone $v_git_repo_url $v_ruta_base
      else
         cd "$v_ruta_base"
         # Refrescar fuentes desde repo (ojo, se pierden cambios locales)
         git reset --hard
         git pull
         # Permisos de ejecución en los scripts
         chmod --recursive +x *.sh
      fi
   fi
fi

# Validacion de variable de entorno cliente_url
if [ -z "$cliente_url" ]
then 
   error_detectado="=== [ERROR] la variable de entorno 'cliente_url' no ha sido configurada en el deploy, debe definirla en environment del deploy con la URL del cliente del despliegue actual (ej: cliente1.datalogic.cloud)"
else 
   # Si no existe la carpeta del mount_path...
   if [ ! -d "$v_ruta_base/especificos/$cliente_url" ]
   then 
      error_detectado="=== [ERROR] la carpeta de configuracion especifica de este cliente no existe: $v_ruta_base/especificos/$cliente_url"
   fi
fi

# Si no hubieron errores, se muestran los parametros y continua el proceso.
# Si se detectaron errores, se cancela el strartup
if [ -z "$error_detectado" ]
then 
   echo "=== Path volumen persistido (variable 'mount_path').....: " $mount_path
   echo "=== URL especifica de cliente (variable 'cliente_url')..: " $cliente_url
else
   echo error_detectado
   echo "=== No se puede iniciar la instancia debido a errores previos."
   exit 1
fi 

# Comienza ejecucion de scrip de instalacion...
echo "=== Comienza ejecucion de scrip de instalacion: " $v_ruta_base"/globales/scripts/startup.sh"
$v_ruta_base/globales/scripts/startup.sh
