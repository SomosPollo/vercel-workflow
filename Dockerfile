FROM node:22-alpine AS build

ARG WORKFLOW_VERSION=4.2.0-beta.76
ARG WORKFLOW_TARGET_WORLD=@workflow/world-postgres

WORKDIR /app

RUN npm install --ignore-scripts workflow@${WORKFLOW_VERSION} ${WORKFLOW_TARGET_WORLD} && \
    npm cache clean --force

FROM node:22-alpine

LABEL org.opencontainers.image.source="https://github.com/SomosPollo/vercel-workflow"
LABEL org.opencontainers.image.description="Vercel Workflow image with pre-installed world"
LABEL org.opencontainers.image.licenses="MIT"

ARG WORKFLOW_TARGET_WORLD=@workflow/world-postgres

ENV NODE_ENV=production
ENV DO_NOT_TRACK=1
ENV NODE_OPTIONS="--disable-warning=ExperimentalWarning"
ENV WORKFLOW_TARGET_WORLD="${WORKFLOW_TARGET_WORLD}"
ENV WORKFLOW_POSTGRES_URL=""
ENV WORKFLOW_SERVER_URL=""

WORKDIR /app

COPY --from=build /app/node_modules ./node_modules

RUN chown -R node:node /app

USER node

CMD ["./node_modules/.bin/workflow", "web"]
