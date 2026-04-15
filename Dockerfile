FROM node:22-alpine AS build

WORKDIR /app

RUN npm install --ignore-scripts workflow@4.2.0-beta.76 @workflow/world-postgres && \
    npm cache clean --force

FROM node:22-alpine

ENV NODE_ENV=production
ENV DO_NOT_TRACK=1
ENV NODE_OPTIONS="--disable-warning=ExperimentalWarning"
ENV WORKFLOW_TARGET_WORLD="@workflow/world-postgres"
ENV WORKFLOW_POSTGRES_URL=""
ENV WORKFLOW_SERVER_URL=""

WORKDIR /app

COPY --from=build /app/node_modules ./node_modules

RUN chown -R node:node /app

USER node

CMD ["./node_modules/.bin/workflow", "web"]
