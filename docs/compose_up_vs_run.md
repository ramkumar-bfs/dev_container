# Compose: up vs run

## docker compose up
Use this for long-running containers.

- Starts services as defined in the compose files.
- Keeps them running until you stop them.
- Creates a named container like `project-app-1`.

Example:
```bash
docker compose -f compose/base.yml -f compose/rocky9.yml -f compose/dev.override.yml up
```

Stop and remove containers:
```bash
docker compose -f compose/base.yml -f compose/rocky9.yml -f compose/dev.override.yml down
```

## docker compose run --rm app
Use this for a one-off container (temporary).

- Runs a single container for the `app` service.
- `--rm` deletes it after you exit.
- Good for quick shell sessions or short tasks.

Example:
```bash
docker compose -f compose/base.yml -f compose/rocky9.yml -f compose/dev.override.yml run --rm app
```
