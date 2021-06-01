#!/bin/bash

# Configuración de parametros de Tomcat para la instalacion actual (permite regular memoria y parametros especificos del cliente)
export JAVA_OPTS="$JAVA_OPTS -Xms128m -Xmx2048m -server -XX:+UseParallelGC -Dfile.encoding=UTF8 -Duser.timezone=GMT-3"


