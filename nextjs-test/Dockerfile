FROM node:alpine
ARG NEXT_PUBLIC_GITHUB_ID
RUN mkdir -p /usr/src

WORKDIR /usr/src

COPY . /usr/src

RUN npm install
ENV NEXT_PUBLIC_GITHUB_ID=${NEXT_PUBLIC_GITHUB_ID}
RUN npm run build
EXPOSE 3000
CMD npm run start