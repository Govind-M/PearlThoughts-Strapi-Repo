FROM node:20.18.1-alpine AS builder

WORKDIR /usr/src/app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy the full project
COPY . .

RUN npm install

FROM node:20.18.1-alpine

WORKDIR /usr/src/app
COPY package*.json ./

RUN npm install --omit=dev 

COPY --from=builder /usr/src/app ./

EXPOSE 1337

CMD [ "npm", "start" ]
