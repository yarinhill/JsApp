#  Express & Nginx & Mongo & Redis

## 1.

Install Docker & Docker-compose on the server

## 2.

Make Sure to export the following environment variables on the server

```
MONGO_USER=${MONGO_USER}
MONGO_PASSWORD=${MONGO_PASSWORD}
SESSION_SECRET=${SESSION_SECRET}
MONGO_INITDB_ROOT_USERNAME=${MONGO_INITDB_ROOT_USERNAME}
MONGO_INITDB_ROOT_PASSWORD=${MONGO_INITDB_ROOT_PASSWORD}
```

## 3.

Run all services with: 

```
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```
For Docker-Swarm
```
docker swarm init
```
```
docker stack deploy -c docker-compose.yml -c docker-compose.prod.swarm.yml myapp
```

## 4.

API Options:


GET API
```
http://<SERVER_IP>/api/v1
```

POST SIGNUP
```
http://<SERVER_IP>/api/v1/users/signup
```
```
{
    "username":"username",
    "password": "password"
}
```


POST LOGIN
```
http://<SERVER_IP>/api/v1/users/login
```
```
{
    "username":"username",
    "password": "password"
}
```


POST BLOG POST
```
http://<SERVER_IP>/api/v1/posts
```
```
{
    "header":"this is the header",
    "body": "this is the body"
}
```
