FROM node
WORKDIR /app
COPY package.json .
ARG NODE_ENV
ARG PORT=3000
RUN if [ "$NODE_ENV" = "development" ]; \
        then npm install; \
        else npm install --only=production; \
        fi

COPY . .
CMD ["node", "index.js"]
EXPOSE $PORT
