# Compose layouts

## Rocky 8
```bash
docker compose -f compose/base.yml -f compose/rocky8.yml -f compose/dev.override.yml up
```

## Rocky 9
```bash
docker compose -f compose/base.yml -f compose/rocky9.yml -f compose/dev.override.yml up
```

## Run once (auto-remove)
```bash
docker compose -f compose/base.yml -f compose/rocky9.yml -f compose/dev.override.yml run --rm app
```

## Stop
```bash
docker compose -f compose/base.yml -f compose/rocky9.yml -f compose/dev.override.yml down
```

## Notes
- Use `dev.override.yml` for local mounts and commands.
- You can add environment variables via a `.env` file in the `compose` folder.
- Current mount paths are defined in [compose/.env](compose/.env).
- `app` is the service name used with `docker compose run`.
- See [docs/compose_up_vs_run.md](docs/compose_up_vs_run.md) for a quick comparison of `up` vs `run`.
- See [docs/when_to_use_up_or_run.md](docs/when_to_use_up_or_run.md) for guidance on when to use each.
- See [docs/compose_env_loading.md](docs/compose_env_loading.md) for how `.env` is loaded.
