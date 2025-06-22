# nextjs/Dockerfile

# Étape 1 : installer les dépendances
FROM node:18-alpine AS deps
WORKDIR /app

# On copie seulement package.json & yarn.lock du dossier nextjs
COPY nextjs/package.json nextjs/yarn.lock ./
RUN yarn install --frozen-lockfile --production

# Étape 2 : builder l’app Next.js
FROM deps AS builder
WORKDIR /app
# On récupère tout le code nextjs
COPY nextjs ./
RUN yarn build

# Étape 3 : runtime
FROM node:18-alpine AS runner
WORKDIR /app

# On récupère le build et les prod-deps
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=deps    /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

EXPOSE 3000
ENV NODE_ENV=production

# Le script "start" dans nextjs/package.json doit être "next start"
CMD ["yarn","start"]
