FROM node:18-alpine as base

# Install pnpm globally
RUN npm install -g pnpm

FROM base as dependencies

WORKDIR /app

COPY package.json /app
COPY pnpm-*.yaml /app/
COPY tsconfig.json /app
COPY packages/shared/package.json packages/shared/package.json
COPY packages/backend/package.json packages/backend/package.json
RUN pnpm install --frozen-lockfile

FROM base as build

WORKDIR /app
COPY packages/backend/ /app/packages/backend/
COPY packages/shared/ /app/packages/shared/
COPY --from=dependencies /app /app

# Run pnpm build commands
RUN pnpm --filter shared build && \
    cd packages/shared && \
    pnpm run copy-media
RUN pnpm --filter backend build

RUN pnpm prune --prod

FROM base as deploy

WORKDIR /app
COPY --from=dependencies /app/node_modules /app/node_modules
COPY --from=build /app/packages/backend/dist /app/packages/backend/dist
COPY --from=build /app/packages/backend/node_modules /app/packages/backend/node_modules

CMD ["node", "packages/backend/dist/main.js"]