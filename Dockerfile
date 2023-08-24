# build environment
FROM node:18-alpine3.17 AS build
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
ENV PNPM_HOME /usr/bin/
RUN corepack enable && pnpm install -g nx@latest
WORKDIR /app
COPY . .
RUN pnpm install --ignore-scripts
RUN pnpm build

FROM nginx:1.25.2-alpine3.18-slim
COPY --from=build /app/dist/packages/main /usr/share/nginx/html
EXPOSE 80
ENTRYPOINT [ "nginx", "-g", "daemon off;" ]