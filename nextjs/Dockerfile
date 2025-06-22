# --- 1) builder stage ---
FROM node:18-alpine AS builder
WORKDIR /app

# 1.1 on copie le manifeste du monorepo et yarn v2
COPY package.json yarn.lock .yarnrc.yml ./
COPY .yarn ./.yarn

# 1.2 on installe juste Next.js (pour les deps)
RUN yarn install --immutable

# 1.3 on copie et build Next.js
COPY nextjs ./nextjs
RUN yarn workspace @se-2/nextjs build

# --- 2) production stage ---
FROM node:18-alpine AS runner
WORKDIR /app

# 2.1 on récupère uniquement ce dont on a besoin pour servir Next.js
COPY --from=builder /app/.yarn ./.yarn
COPY --from=builder /app/yarn.lock ./
COPY --from=builder /app/package.json ./
COPY --from=builder /app/nextjs/.next ./nextjs/.next
COPY --from=builder /app/nextjs/public ./nextjs/public
COPY --from=builder /app/nextjs/package.json ./nextjs/package.json

# 2.2 on installe en prod
RUN yarn install --immutable --production

WORKDIR /app/nextjs
EXPOSE 3000
CMD ["yarn", "start"]
