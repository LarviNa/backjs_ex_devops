# Backend JS - Servicio de Usuarios (Contenedores & CI/CD)

Servicio de gestión de usuarios en Node.js/Express con MySQL para la **Evaluación Final Transversal (EFT)** de la asignatura **Introducción a Herramientas Devops**.

---

## Contenerización (Docker)

La contenerización del microservicio está optimizada siguiendo buenas prácticas de seguridad e infraestructura:

1. **Imagen Minimalista**: Basado en la imagen oficial `node:20-alpine`.
2. **Hardening (Seguridad)**: Ejecutado con un usuario no root (`USER node`) para mitigar vulnerabilidades de elevación de privilegios en el contenedor.
3. **Caché de Capas**: Copia los descriptores `package*.json` antes del código fuente para acelerar la construcción de imágenes cuando no hay cambios de dependencias.

### Construcción Local de la Imagen
```bash
docker build -t backend-users:latest .
```

### Ejecutar Contenedor
```bash
docker run -d -p 8081:8081 \
  -e DB_HOST=host.docker.internal \
  -e DB_PORT=3306 \
  -e DB_USER=root \
  -e DB_PASSWORD=rootpassword \
  -e DB_NAME=eval_db \
  backend-users:latest
```

---

## GitHub Actions - Pipeline CI/CD

El pipeline automatizado en GitHub Actions valida y despliega el microservicio siguiendo este flujo:

1. **Linter & Syntax Check**: Realiza comprobación estática de sintaxis ejecutando `node --check server.js`.
2. **Docker Build & Push**: Construye y sube la imagen Docker con versión única (`sha`) y la etiqueta `latest` a tu Docker Hub.
3. **AWS ECS Deploy**: Actualiza de forma segura la definición de tareas (Task Definition) y redespliega en AWS ECS Fargate.

### Configuración de Secretos en GitHub

* `DOCKERHUB_USERNAME`: Tu usuario de Docker Hub.
* `DOCKERHUB_TOKEN`: Tu personal access token de Docker Hub.
* `AWS_ACCESS_KEY_ID`: Credenciales de acceso de AWS IAM con permisos en ECS.
* `AWS_SECRET_ACCESS_KEY`: Clave secreta de acceso de AWS IAM.
