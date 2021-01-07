FROM node:12

RUN apt-get update

RUN apt-get install stress

WORKDIR /usr/src/app

COPY . ./

RUN yarn

RUN yarn build

COPY . .

EXPOSE 3000

CMD [ "node", "dist/server.js" ]
