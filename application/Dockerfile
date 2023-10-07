FROM node:alpine
COPY package*.json .
WORKDIR /build/application
RUN npm install
COPY . .
RUN npm i
RUN npm run build
EXPOSE 3000
CMD ["node", "./build/index.js"]
