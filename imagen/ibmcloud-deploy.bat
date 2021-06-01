ibmcloud login

ibmcloud cr namespaces

:: conectar docker con IBM Cloud
ibmcloud cr login

:: ver imagenes locales
docker images

:: tagear imagen para subir (previamente se debe hacer docker build con este nombre y version)
docker tag dl-tomcat-base us.icr.io/datalogic-demo/dl-tomcat-base:1.0 

:: subir imagen a IBM
docker push us.icr.io/datalogic-demo/dl-tomcat-base:1.0

:: ATENCION:
:: Luego de subir la imagen al container regstry de IBM, se 
:: deberá crear el "deployment" en la consola de IBM con el 
:: contenido del archivo yaml (en Developer/opcion +Add/yaml)
:: se debe crear primero el deploy y luego el servicio, por lo que
:: hay que agregar dos yaml diferentes.

:: Ver imagenes subidas al cr de ibmcloud
ibmcloud cr images

:: Eliminar imagen del (container registry) cr de ibmcloud
ibmcloud cr image-rm us.icr.io/datalogic-demo/dl-tomcat-base:1.1
