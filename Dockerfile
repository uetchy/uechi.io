FROM node:15 as build

# https://github.com/jgm/pandoc/releases
RUN curl -LO https://github.com/jgm/pandoc/releases/download/2.14.0.1/pandoc-2.14.0.1-1-amd64.deb
RUN dpkg -i pandoc-2.14.0.1-1-amd64.deb

WORKDIR /app
COPY package.json /app
RUN yarn install
COPY themes /app/themes
COPY source /app/source
COPY _config.yml /app/
RUN yarn build

FROM nginx:stable-alpine as runtime

COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=build /app/public /var/www/html/