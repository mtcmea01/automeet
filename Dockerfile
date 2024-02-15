FROM node:20

WORKDIR /app

COPY . .

RUN npm install

EXPOSE 8080
ENV WEBPACK_DEV_SERVER_PROXY_TARGET=http://h1.velaconference.business
CMD ["make", "dev"]
