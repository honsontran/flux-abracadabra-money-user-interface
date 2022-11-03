FROM node:14-slim

WORKDIR /app
COPY . /app

RUN apt -y update && apt install -y python cmake g++

RUN npx browserslist@latest --update-db
RUN npm i --legacy-peer-deps
RUN npm install
RUN npm run build
RUN npm run lint

RUN npm install -g serve
CMD serve dist
EXPOSE 3000