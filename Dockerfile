FROM node:alpine
WORKDIR /build/application
COPY package*.json .
RUN npm install
COPY . .
RUN npm i
RUN npm run build
CMD ["node", "./build/index.js"]
