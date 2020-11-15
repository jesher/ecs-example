FROM node:12

WORKDIR /usr/src/app

COPY . ./

RUN yarn

RUN yarn build

COPY . .

EXPOSE 3000
CMD [ "node", "dist/server.js" ]