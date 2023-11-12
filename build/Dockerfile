FROM node:lts-alpine

# Install some system dependencies.
RUN apk add --no-cache git bash jq curl

# Install release-it and other dependencies under /release-it.
WORKDIR /release-it
COPY package* .
RUN npm install

# Copy templates.
COPY templates /templates

# Configure a custom entrypoint.
WORKDIR /usr/src/app

# Configure entrypoint.
ENV PATH=/release-it/node_modules/.bin:${PATH}
COPY build/docker-entrypoint.sh /usr/local/bin/
COPY build/plugins.d /usr/local/bin/
RUN ln -s /usr/local/bin/docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]