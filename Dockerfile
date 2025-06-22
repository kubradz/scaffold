FROM node:18-alpine
WORKDIR /app

# 1. Installe les dépendances du front
COPY packages/react-app/package*.json ./packages/react-app/
RUN cd packages/react-app && npm install

# 2. Copie et build le front
COPY packages/react-app ./packages/react-app
RUN cd packages/react-app && npm run build

# 3. Expose et lance le front
WORKDIR /app/packages/react-app
EXPOSE 3000
CMD ["npm","start"]
