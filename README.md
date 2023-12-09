# micro-configserver

# Chapter 5: Spring Cloud Config Server

Esta aplicación se usa con la otra llamada "micro-ch2-licensing-service".

Ambas presentan su propio Dockerfile para generar su imagen.

Configuration Server nos permite obtener archivos de configuracion y usarlos en otras aplicaciones, en modo de
microservicios.

En application.yml veremos como se obtienen los archivos de GitHub, directamente de este mismo proyecto, es para testear pero se podria extraer de cualquier repositorio. Hay otro metodo local, pero eso dificulta la actualizacion. Yo ahora actualizo esos archivos y los tomará de allí, es decir, obtengo actualizacion dinámica, sin tocar las imagenes.

En la otra aplicación "micro-ch2...", tenemos tambien el archivo de docker-compose.yml. Ese nos permitirá orquestrar y armar una aplicación con múltiples containers. 

Puntos claves en ambas. En este misma aplicación, además del propio Dockerfile para generar la imagen, los archivos de configuracion que deben tener el mismo nombre que el servicio que las usará (en el ejemplo "licensing-service") y luego el perfil ("dev" o "default"). Luego para el cifrado, utilizamos un método simétrico. Generamos una clave guardada en un archivo .env, esa clave será inyectada en docker-compose.yml en el servicio de configserver. Con esa clave podremos cifrar valores en los archivos de configuracion. Para obtener el cifrado debemos pegarle a POST localhost:8071/encrypt /decrypt, y con eso obtenemos el código para usar. Si no usaramos Docker, la key la usamos en application.yml de configserver. Finalmente tiene su propio archivo de propiedades (application.yml), donde seteamos su nombre y que funcione con sistema de GitHub los archivos de configuracion.

DATO! En los archivos de configuracion y .properties donde ingresemos datos como la URL de la base de datos o la URL del config-server, en Docker NO SE USA LOCALHOST! Sino el nombre del container del servicio.

Luego en "micro-ch2..." seteamos en el archivo de propiedades la url del config-server, el perfil que usaremos (que determina el tipo de archivo de configuracion, en el ejemplo "dev"), y el nombre del servicio. Además, podremos extraer la información de esos archivos para usarlos en código como hacemos en ServiceConfig.java. Porque los usabamos para usar la info para conectarnos a la base de datos, pero sirve para usarla en código también. Sirve directamente porque se importa como si fuera un archivo properties más dentro del proyecto. 

Finalmente, tenemos el archivo de docker-compose.yml, donde armamos toda la orquesta de containers. Lo unico que necesita cerca es el archivo .env donde saca variables de entorno. 

COMANDOS:

Para generar una imagen: 

`mvn clean package` o  
`mvn package docker:build`

Para ejecutar y formar el compose:

`docker-compose up`

Podria tambien pasarle variables de entorno:

`KEY=123456 docker-compose up`

Para ingresar a la base de datos en el container (el codigo es el id del container, podria ser el nombre; luego nombre de usuario y nombre de base de datos):

`docker exec -it 49a3a054ttt psql -U peter spring_practice`

Luego, para actualizar el servicio de configuracion y que tome nuevos archivos de config podemos ejecutar:

`localhost:8080/actuator/refresh`

Para generar encriptados/desencriptar (le pegamos al servicio de configuracion):

`localhost:8081/encrypt`

# CONCLUSION

Con estos dos proyectos tenemos armado una orquesta de 3 containers, el servicio de licensing, la base de datos y el servidor de configuracion, conectados los 3 en Docker usando Docker Compose. Con archivos de configuracion extraidos dinamicamente de GitHub. Todo funcionando de la misma manera que con localhost. 