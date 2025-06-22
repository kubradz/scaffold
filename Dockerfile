# Étape 1 : builder
FROM node:18-alpine AS builder
WORKDIR /app

# 1.1 On copie les package.json et package-lock.json de nextjs pour tirer parti du cache
COPY nextjs/package*.json ./

# 1.2 On installe toutes les dépendances
RUN npm install

# 1.3 On copie tout le reste du code et on build
COPY nextjs ./
RUN npm run build

# Étape 2 : image de production
FROM node:18-alpine AS runner
WORKDIR /app

# 2.1 Seules les dépendances de prod
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/.next    ./.next
COPY --from=builder /app/public   ./public
COPY --from=builder /app/package.json ./package.json

# Déclare le port que Next utilisera
EXPOSE 3000

# Lancement en mode production
ENV NODE_ENV=production
CMD ["npm", "run", "start"]
