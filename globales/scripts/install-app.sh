#!/bin/bash

# ------------------------------------------------------------------------------------------------------
# Instalación aplicaciones:
# Se elimina archivo de instalador anterior (si existe)
# Se descarga del ftp la version a actualizar
# Se setean permisos de ejecución.
# Se ejecuta instlaador en modo silencioso, apuntando a parametros de instalacion preexistentes
# Se cambia el owner de toda la carpeta tomcat (entre los archivos están los que se acaban de instalar)
# ------------------------------------------------------------------------------------------------------

echo "=============================================================================="
echo "== Comenzando instalación de aplicación " $v_sistema
echo "=============================================================================="
echo ""

# Parametros que vienen cargados desde Jenkins o desde aplicación invocante
echo "v_sistema              ="$v_sistema
echo "v_ejecutable_instalador="$v_ejecutable_instalador
echo "v_url_instalacion      ="$v_url_instalacion
echo "v_tipo_descarga        ="$v_tipo_descarga
echo "v_apps_a_recargar      ="$v_apps_a_recargar

# Estructura de ejemplo:
# /vol01
#    /globales
#       /instaladores
#          /GIA-WEB
#             GIAWeb_unix_6_19_00.sh
#             ...
#    /especificos
#       /cliente1.platformdemos.cloud
#          /instalaciones
#             /GIA-WEB
#                (archivos de instalacion)
#                ...
#          /configuraciones
#             /GIA-WEB
#                response.varfile

# Parametros que se cargan fijos:
v_carpeta_instaladores=$v_ruta_base/globales/instaladores
v_carpeta_configuraciones=$v_ruta_base/especificos/$v_url_instalacion/configuraciones

v_carpeta_instaladores_tmp=$v_ruta_tmp/instaladores
v_carpeta_instalador_sistema_tmp=$v_carpeta_instaladores_tmp/$v_sistema
v_carpeta_instalaciones_tmp=$v_ruta_tmp/instalaciones
v_carpeta_instalacion_sistema_tmp=$v_carpeta_instalaciones_tmp/$v_sistema
v_archivo_log_instalacion_tmp=$v_carpeta_instalacion_sistema_tmp/.install4j/installation.log

v_carpeta_instalador_sistema=$v_carpeta_instaladores/$v_sistema
v_carpeta_configuracion_sistema=$v_carpeta_configuraciones/$v_sistema
v_archivo_parametros_instalacion=$v_carpeta_configuracion_sistema/response.varfile

v_ftp_url=10.1.1.36
v_ftp_usuario=cliente
v_ftp_password=cli.1717
v_manager_usuario=datalogic
v_manager_password=dlc/1840
v_tomcat_puerto_local=8080
v_tomcat_usuario=tomcat
v_tomcat_grupo=tomcat
v_tomcat_carpeta=/usr/local/tomcat

# Rutina de chequeo de error, si la ultima operacion fallo, se aborta el proceso.
checkerror() {
   v_exitcode=$?
   if [ $v_exitcode != 0 ]
   then
      echo "[ERROR] Error al ejecutar ultima operacion (exitcode="$v_exitcode")"
      exit $v_exitcode
   fi
}

# Si es una beta, a la carpeta del ftp para la descarga se le agrega /beta
if [ "$v_tipo_descarga" == "Beta" ]
then
   v_ftp_carpeta_descarga=$v_sistema_ftp/betas
else
   v_ftp_carpeta_descarga=$v_sistema_ftp
fi

# Si la carpeta de descarga del instalador no existe, se creará (mkdir -p crea carpetas padres si no existen)
if [ ! -d "$v_carpeta_instalador_sistema" ]; then
  echo "=== Carpeta de instaladores no existe, creando carpeta: " $v_carpeta_instalador_sistema
  mkdir -p "$v_carpeta_instalador_sistema"
  checkerror
fi

# Si el archivo del instalador existe, se elimina. Siempre se descarga de nuevo y en la carpeta del subdominio para 
# permitir que se puedan ejecutar varias actualizaciones al mismo tiempo sin que se pisen las descargas.
# if [ -f "$v_carpeta_instalador_sistema/$v_ejecutable_instalador" ]; then
#   echo "=== Eliminando instalador anterior: " $v_carpeta_instalador_sistema/$v_ejecutable_instalador
#   rm -f $v_carpeta_instalador_sistema/$v_ejecutable_instalador
#   checkerror
# fi

# Descarga del ejecutable desde el ftp (-N para descargar solo si tamaño o timestamp cambiaron, esto hace que cada version solo se descargue una vez).
echo "=== Descargando instalador desde ftp (carpeta de descarga): ftp://"$v_ftp_url/$v_ftp_carpeta_descarga/$v_ejecutable_instalador
wget -nv -N ftp://$v_ftp_usuario:$v_ftp_password@$v_ftp_url/$v_ftp_carpeta_descarga/$v_ejecutable_instalador -P $v_carpeta_instalador_sistema
checkerror

# Si la carpeta de descarga temporal (dentro de docker) del instalador no existe, se creará (mkdir -p crea carpetas padres si no existen)
if [ ! -d "$v_carpeta_instalador_sistema_tmp" ]; then
  echo "=== Carpeta de instaladores temporal no existe, creando carpeta: " $v_carpeta_instalador_sistema_tmp
  mkdir -p "$v_carpeta_instalador_sistema_tmp"
  checkerror
fi

# Se copia el instalador para adentro del docker, para ejecutar sin problemas de filesystem.
echo "=== Copiando instalador a contendor: " $v_carpeta_instalador_sistema a $v_carpeta_instalador_sistema_tmp
cp -R "$v_carpeta_instalador_sistema"/* "$v_carpeta_instalador_sistema_tmp"
checkerror

# Permiso de ejecución en archivo ejecutable del instalador.
echo "=== Seteando permisos de ejecución en: " $v_carpeta_instalador_sistema_tmp/$v_ejecutable_instalador
chmod 777 $v_carpeta_instalador_sistema_tmp/$v_ejecutable_instalador
checkerror

# Ejecución del instalador, se pasa carpeta de configuración, -q para desatendido, -console para que muestre errores si los hay.
echo "=== Ejecutando instalador"
echo "=== * Archivo de parámetros....: " $v_archivo_parametros_instalacion
echo "=== * Carpeta de instalacion...: " $v_carpeta_instalacion_sistema_tmp
$v_carpeta_instalador_sistema_tmp/$v_ejecutable_instalador -q -console -varfile $v_archivo_parametros_instalacion -dir $v_carpeta_instalacion_sistema_tmp
checkerror

# Se elimina instalador temporal.
echo "=== Eliminando carpeta temporal de instalador de contendor: " $v_carpeta_instalador_sistema_tmp
rm -r "$v_carpeta_instalador_sistema_tmp"
checkerror

# Controlar que el log de la instalacion no contiene ningun error.
if grep "\[ERROR\]" "$v_archivo_log_instalacion_tmp"; then
  echo "=== [ERROR] Se detectaron errores en el archivo de log de la instalacion"
  echo "    Archivo: $v_archivo_log_instalacion_tmp"
  echo "    Revise el log de la instalacion para conocer mas detalles, y vuelva a ejecutar el proceso de instalacion."
  exit 1
else
  echo "=== [OK] Instalacion finalizada OK. "
fi

# Se elimina carpeta de instalacion temporal (si no hubo error).
echo "=== Eliminando carpeta temporal de instalación del sistema de contendor: " $v_carpeta_instalacion_sistema_tmp
rm -r "$v_carpeta_instalacion_sistema_tmp"
checkerror

# Cambio de owner de carpetas debajo de tomcat porque quedaron con root luego de la ejecución del instalador.
# echo "=== Cambiando owner para ejecución de tomcat en archivos instalados en carpeta " $v_tomcat_carpeta
# chown -R $v_tomcat_usuario:$v_tomcat_grupo $v_tomcat_carpeta
# checkerror

# ------------------------------------------------------------------------------------------------------
# Recarga de la aplicacion 
# En lugar de bajar el tomcat completo, se procede a recargar la aplicación que se acaba de actualizar.
# para esto se invoca por crul el comando de recargar
# Atenci贸n: para poder hacer esto el usuario datalogic debe tener rol manager-script en tomcat-users.xml
#           en /opt/tomcat/conf/Catalina/gfepy.test.datalogic-software.com/manager.xml debe agregarse 
#           127.0.0.1 a las ip aceptadas.
# Si no se desea recargar individualmente la aplicacion, se puede bajar el tomcat completo con:
# systemctl stop tomcat
# systemctl start tomcat

# echo "=== Recargando aplicaciones... " 
# IFS=',' read -r -a v_array_apps_a_recargar <<< "$v_apps_a_recargar"
# for v_app in "${v_array_apps_a_recargar[@]}"
# do
#    echo "=== Recargando http://"$v_url_instalacion:$v_tomcat_puerto_local/$v_app
#    echo "    Ejecutando: " http://$v_url_instalacion:$v_tomcat_puerto_local/manager/text/reload?path=/$v_app
#    curl --user $v_manager_usuario:$v_manager_password http://$v_url_instalacion:$v_tomcat_puerto_local/manager/text/reload?path=/$v_app
#    checkerror
# done

# Se elimina instalador utilizado en el proceso.
# if [ -f "$v_carpeta_instalador_sistema/$v_ejecutable_instalador" ]; then
#   echo "=== Eliminando instalador utilizado: " $v_carpeta_instalador_sistema/$v_ejecutable_instalador
#   rm -f $v_carpeta_instalador_sistema/$v_ejecutable_instalador
#   checkerror
# fi

echo "=============================================================================="
echo "== Finalizada instalación de aplicación " $v_sistema
echo "=============================================================================="
echo ""
echo ""