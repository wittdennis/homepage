# build environment
FROM node:18-alpine3.17 AS build
RUN corepack enable
WORKDIR /app
COPY package.json .
COPY pnpm-lock.yaml .
RUN pnpm install --ignore-scripts
COPY . .
RUN pnpm build

FROM nginx:1.24.0-alpine3.17-slim
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
ENTRYPOINT [ "nginx", "-g", "daemon off;" ]