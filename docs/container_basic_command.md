# Container basic commands

## Run a container (interactive shell)
```bash
docker run --rm -it --name rocky8-test rocky8-dev:latest /bin/bash
```

## Check inside the container
```bash
python3 --version
id
```

## Run container with SSH enabled
```bash
docker run --rm -it -p 2222:22 --name rocky8-test rocky8-dev:latest /bin/bash -lc "sshd; sleep infinity"
```

## SSH into the container
```bash
ssh pipeline@localhost -p 2222
```

## List running containers
```bash
docker ps
```

## List all containers (including stopped)
```bash
docker ps -a
```

## Stop a running container
```bash
docker stop rocky8-test
```

## Remove a container
```bash
docker rm rocky8-test
```

## List images
```bash
docker images
```

## Remove an image
```bash
docker rmi rocky8-dev:latest
```
