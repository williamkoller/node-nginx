FROM node:23.8-slim AS build

WORKDIR /app

COPY package*.json ./

RUN npm ci --omit=dev

COPY . .

FROM node:23.8-slim

WORKDIR /app

COPY --from=build /app /app

ENV PORT=3000

EXPOSE 3000

CMD ["node", "src/app.js"]
