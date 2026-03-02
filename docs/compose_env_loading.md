# How Compose loads .env

Docker Compose automatically reads a `.env` file from the directory where the compose file lives.

In this repo, we run Compose with:

```bash
docker compose -f compose/base.yml -f compose/rocky9.yml -f compose/dev.override.yml up
```

Since those files are in the `compose` folder, Compose will load:

```
compose/.env
```

## What it does
- Variables in `.env` are used for substitution like `${HOST_APPS}` in YAML.
- These are not automatically passed into the container unless you add them under `environment:`.

## Example
**compose/.env**
```env
HOST_APPS=C:\Users\Ramkumar.E\Documents\mount\apps
```

**compose/dev.override.yml**
```yaml
services:
  app:
    volumes:
      - "${HOST_APPS}:/apps"
```

## Common pitfalls
- Use absolute paths on Windows.
- Do not use `~` in Windows paths.
- If you run Compose from a different folder, `.env` must be in that folder or you must pass `--env-file`.
