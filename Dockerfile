FROM node:24
WORKDIR /app

#COPY . .
COPY package*.json .


RUN npm install

RUN npm run build

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