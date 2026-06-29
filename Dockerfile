FROM node:22-slim AS build
WORKDIR /app
COPY pnpm-lock.yaml package.json pnpm-workspace.yaml ./
RUN corepack enable && CI=true pnpm install --frozen-lockfile
COPY . .
RUN CI=true pnpm exec tsx scripts/toggle-proxy.ts && CI=true pnpm exec astro build

FROM nginx:alpine
COPY --from=build /app/dist/client/ /usr/share/nginx/html
EXPOSE 80
