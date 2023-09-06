# build environment
FROM denniswitt/nx:16.7.4-node-18.17.1-bookworm AS build
WORKDIR /app
COPY . .
RUN pnpm install --ignore-scripts
RUN pnpm build

FROM nginx:1.25.2-alpine3.18-slim
COPY --from=build /app/dist/packages/main /usr/share/nginx/html
EXPOSE 80
ENTRYPOINT [ "nginx", "-g", "daemon off;" ]