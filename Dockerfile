FROM node:16 AS build

ARG TABIX_VER

RUN curl -L https://github.com/tabixio/tabix/archive/${TABIX_VER}.tar.gz -o tabix.tar.gz && \
    tar zxvf tabix.tar.gz && \
    mv tabix-${TABIX_VER}/ tabix/

WORKDIR /tabix

RUN echo 'nodeLinker: node-modules' > .yarnrc.yml
RUN yarn set version 3.1.1
RUN yarn install
RUN yarn build

FROM nginx AS target

COPY --from=build /tabix/dist/* /usr/share/nginx/html/