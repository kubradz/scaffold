# --- builder ---
FROM node:18-alpine AS builder
WORKDIR /app

# 1) copy manifest + Yarn 2
COPY package.json yarn.lock .yarnrc.yml ./
COPY .yarn ./.yarn

# 2) install deps
RUN yarn install --immutable

# 3) copy & build Next.js
COPY nextjs ./nextjs
RUN yarn workspace @se-2/nextjs build

# --- runtime ---
FROM node:18-alpine AS runner
WORKDIR /app

# 4) copier uniquement ce qui sert en prod
COPY --from=builder /app/.yarn ./.yarn
COPY --from=builder /app/yarn.lock ./
COPY --from=builder /app/package.json ./

COPY --from=builder /app/nextjs/.next ./nextjs/.next
COPY --from=builder /app/nextjs/public ./nextjs/public
COPY --from=builder /app/nextjs/package.json ./nextjs/package.json

# 5) installer en prod
RUN yarn install --immutable --production

WORKDIR /app/nextjs
EXPOSE 3000
CMD ["yarn","start"]
