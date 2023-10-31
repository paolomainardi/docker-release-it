FROM node:lts-alpine

# Install some system dependencies.
RUN apk add --no-cache git bash

# Install release-it and other dependencies under /release-it.
WORKDIR /release-it
COPY package* .
RUN npm install

# Configure a custom entrypoint.
WORKDIR /usr/src/app
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]