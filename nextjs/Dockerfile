# 1) Builder
FROM node:18-alpine AS builder
WORKDIR /app

# 1.1 / Core du mono-repo
COPY package.json yarn.lock .yarnrc.yml ./
COPY .yarn ./.yarn

# 1.2 / Only Next.js workspace
COPY nextjs/package.json nextjs/yarn.lock ./nextjs/
RUN yarn install --immutable

COPY nextjs ./nextjs
RUN yarn workspace nextjs build

# 2) Runner
FROM node:18-alpine AS runner
WORKDIR /app

# 2.1 / Copy only what we need
COPY --from=builder /app/.yarn ./.yarn
COPY --from=builder /app/yarn.lock ./yarn.lock
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/nextjs/.next ./nextjs/.next
COPY --from=builder /app/nextjs/public ./nextjs/public
COPY --from=builder /app/nextjs/package.json ./nextjs/package.json

# 2.2 / Prod deps (si vous voulez, sinon elles sont déjà dans node_modules de builder)
RUN yarn install --immutable --production

WORKDIR /app/nextjs
EXPOSE 3000
CMD ["yarn", "start"]
