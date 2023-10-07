FROM node:alpine
COPY package*.json .
WORKDIR /build/application
RUN npm install
COPY . .
RUN npm run build
CMD ["node", "./build/index.js"]
