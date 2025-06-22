# --- 1) Installation des dépendances (Yarn Berry / v3) ---
FROM node:18-alpine AS deps
WORKDIR /app

# On copie le manifest root et le dossier .yarn
COPY package.json yarn.lock .yarnrc.yml ./
COPY .yarn ./.yarn

# On installe en mode prod
RUN yarn install --immutable --production

# --- 2) Build de l’app NextJS ---
FROM deps AS builder
WORKDIR /app/nextjs

# On copie tout le code NextJS
COPY nextjs/ ./

# On build
RUN yarn build

# --- 3) Image de production ---
FROM node:18-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production

# On récupère le résultat du build
COPY --from=builder /app/nextjs/.next       ./.next
COPY --from=builder /app/nextjs/public      ./public
COPY --from=builder /app/nextjs/package.json ./package.json

# On récupère les node_modules déjà installés
COPY --from=deps /app/node_modules ./node_modules

EXPOSE 3000

CMD ["yarn","start"]
