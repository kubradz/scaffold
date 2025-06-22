# Dockerfile (à la racine du repo)
FROM node:18-alpine

WORKDIR /app

# 1. Copie uniquement les package.json (pour profiter du cache Docker)
COPY nextjs/package*.json ./

# Installe les dépendances
RUN npm install

# 2. Copie tout le code du front et build
COPY nextjs ./
RUN npm run build

# 3. Expose et lance le front
EXPOSE 3000
CMD ["npm", "start"]
