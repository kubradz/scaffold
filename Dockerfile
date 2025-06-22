# --- Builder stage ---
FROM node:18-alpine AS builder
WORKDIR /app

# 1) Manifest + Yarn v2
COPY package.json yarn.lock .yarnrc.yml ./
COPY .yarn ./.yarn

# 2) Install deps (monorepo)
RUN yarn install --immutable

# 3) Copy & build Next.js
COPY nextjs ./nextjs
RUN yarn workspace @se-2/nextjs build

# --- Runner stage ---
FROM node:18-alpine AS runner
WORKDIR /app

# 4) Copy only ce qui sert pour la prod
COPY --from=builder /app/.yarn ./.yarn
COPY --from=builder /app/yarn.lock ./
COPY --from=builder /app/package.json ./

COPY --from=builder /app/nextjs/.next ./nextjs/.next
COPY --from=builder /app/nextjs/public ./nextjs/public
COPY --from=builder /app/nextjs/package.json ./nextjs/package.json

# 5) Install prod-only
RUN yarn install --immutable --production

WORKDIR /app/nextjs
EXPOSE 3000
CMD ["yarn", "start"]
