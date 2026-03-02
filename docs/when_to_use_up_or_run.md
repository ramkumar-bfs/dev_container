# When to use up or run

## Use `docker compose up` when
- You want a container to stay running.
- You are doing long work sessions.
- You have multiple services that should start together.

## Use `docker compose run --rm app` when
- You want a temporary container that is removed automatically.
- You only need a short shell session.
- You want changes inside the container to be discarded on exit.

## Quick summary
- `up` = persistent, managed services.
- `run --rm` = temporary, one-off container.
