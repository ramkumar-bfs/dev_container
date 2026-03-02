# Docker notes (short)

## What we covered
- Dockerfile builds an image; Compose runs containers.
- Use a Dockerfile when you need to install packages or bake files into an image.
- Use Compose when you only need to pick an image, mount folders, set env vars, and run a command.
- Mounts happen at runtime (docker run or Compose), not inside a Dockerfile.
- A container can only run binaries built for its OS (Linux container needs Linux binaries).

## Your Rocky 8 + portable Python plan
- Use `rockylinux:8` as the image.
- Mount your portable Python folder into the container (for example, `/apps`).
- Mount your project into `/work`.
- Set `PATH` and `LD_LIBRARY_PATH` to point to your portable Python.
- Run a startup shell command that sources your setup script and runs the app.

## Current image setup
- Shared scripts:
  - `docker/common/system_update.sh` installs system updates and dev packages.
  - `docker/common/user_setup.sh` creates the `pipeline` user and enables SSH.
- Rocky images:
  - `docker/rocky8/Dockerfile` and `docker/rocky9/Dockerfile` run those scripts and delete them afterward.
- Default working directory is `/home/pipeline`.
- SSH is enabled on port 22.

## Example Compose skeleton
```yaml
services:
  app:
    image: rockylinux:8
    volumes:
      - "C:\\path\\to\\apps:/apps"
      - ".:/work"
    working_dir: /work
    environment:
      - PATH=/apps/bin:$PATH
      - LD_LIBRARY_PATH=/apps/lib
    command: ["/bin/bash", "-lc", "source /apps/setup.sh; /apps/bin/python main.py"]
```

## Build the Rocky 8 image
From the repo root:

```bash
docker build -f docker/rocky8/Dockerfile -t rocky8-dev:latest docker
```

What it does:
- Uses the Rocky 8 Dockerfile.
- Uses the `docker/` folder as build context so the shared scripts can be copied.
- Tags the image as `rocky8-dev:latest`.

## Build the Rocky 9 image
From the repo root:

```bash
docker build -f docker/rocky9/Dockerfile -t rocky9-dev:latest docker
```

What it does:
- Uses the Rocky 9 Dockerfile.
- Uses the `docker/` folder as build context so the shared scripts can be copied.
- Tags the image as `rocky9-dev:latest`.

## Run the container (docker run)
Run Rocky 8 with an interactive shell:

```bash
docker run --rm -it --name rocky8-dev rocky8-dev:latest /bin/bash
```

Run Rocky 8 with host mounts and your portable Python:

```bash
docker run --rm -it \
  -v "C:\\path\\to\\apps:/apps" \
  -v "%cd%:/work" \
  -w /work \
  -e PATH=/apps/bin:$PATH \
  -e LD_LIBRARY_PATH=/apps/lib \
  rocky8-dev:latest \
  /bin/bash -lc "source /apps/setup.sh; /apps/bin/python main.py"
```

## Run the container (docker compose)
Basic service example:

```yaml
services:
  app:
    image: rocky8-dev:latest
    volumes:
      - "C:\\path\\to\\apps:/apps"
      - ".:/work"
    working_dir: /work
    environment:
      - PATH=/apps/bin:$PATH
      - LD_LIBRARY_PATH=/apps/lib
    command: ["/bin/bash", "-lc", "source /apps/setup.sh; /apps/bin/python main.py"]
```

Start it:

```bash
docker compose up
```

## Tips
- If the Python binary fails, check:
  - The binary is Linux-built (not Windows).
  - Required shared libs exist in `/apps/lib` or system locations.
  - `LD_LIBRARY_PATH` is set.
- If paths contain spaces on Windows, keep the host path in quotes.
- Use `docker compose up --build` only when you build images; otherwise `docker compose up` is enough.
- See `docs/container_basic_command.md` for basic container commands.

## Troubleshooting
- **`/apps/bin/python: No such file or directory`**
  - Check the mount path and the exact Python binary path.
- **`error while loading shared libraries`**
  - Ensure `LD_LIBRARY_PATH` includes your portable Python libs (for example, `/apps/lib`).
- **SSH not reachable**
  - Make sure you publish port 22 (`-p 2222:22`) and start `sshd`.
- **Permission denied on mounted files**
  - Try running as root or match UID/GID with `user: "1000:1000"` in Compose.

## More docs
- See [docs/compose_up_vs_run.md](docs/compose_up_vs_run.md) for a quick comparison of `up` vs `run`.
- See [docs/when_to_use_up_or_run.md](docs/when_to_use_up_or_run.md) for guidance on when to use each.
