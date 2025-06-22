# Étape 1 : deps
FROM node:18-alpine AS deps
WORKDIR /app

COPY nextjs/package.json nextjs/yarn.lock ./
RUN yarn install --frozen-lockfile --production

# Étape 2 : builder
FROM deps AS builder
WORKDIR /app

COPY nextjs ./
RUN yarn build

# Étape 3 : runtime
FROM node:18-alpine AS runner
WORKDIR /app

COPY --from=builder /app/.next     ./.next
COPY --from=builder /app/public     ./public
COPY --from=deps    /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

EXPOSE 3000
ENV NODE_ENV=production

CMD ["yarn","start"]
