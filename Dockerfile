FROM node:20

WORKDIR /app

COPY . .

RUN npm install

EXPOSE 8080
#Disabled to make it work.
#ENV WEBPACK_DEV_SERVER_PROXY_TARGET=http://h1.velaconference.business
CMD ["make", "dev"]
