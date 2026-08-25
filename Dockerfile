FROM node:24
WORKDIR /app

# Copia los archivos de definición de dependencias
COPY package*.json ./

# Instala las dependencias del proyecto
RUN npm install

# Copia los archivos de configuración requeridos para la compilación de NestJS
COPY tsconfig*.json ./
COPY nest-cli.json ./

# Copia el código fuente del proyecto
COPY src ./src

# Compila el proyecto generando el directorio 'dist'
RUN npm run build

# Comando de inicio de la aplicación en producción
CMD ["node", "dist/main.js"]

#COPY package*.json .
#COPY src src
#COPY tsconfig*.json .

#RUN npm install

#RUN npm run build

#FROM node:24-alpine AS run

#WORKDIR /app

#COPY package*.json .

#COPY --from=build /app/dist /app/dist

#RUN npm install --only=production

#CMD ["node", "dist/main.js"]