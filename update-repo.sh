#!/bin/bash

# Refrescar fuentes desde repo (ojo, se pierden cambios locales)
git reset --hard

git pull

# Permisos de ejecución en los scripts
chmod --recursive +x *.sh

