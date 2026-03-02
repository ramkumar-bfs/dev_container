# Setting up Windows Terminal profile for Rocky 8

## Auto-start a container
Add a profile like this in Windows Terminal settings:

```json
{
  "name": "Rocky-8-dev-docker",
  "commandline": "docker run --rm -it rocky8-dev:latest /bin/bash",
  "startingDirectory": "%USERPROFILE%"
}
```

## Auto-start a container (unique name per tab)
Use this variant to avoid name conflicts when multiple tabs are opened:

```json
{
  "name": "Rocky-8-dev-docker (Unique)",
  "commandline": "powershell -NoLogo -Command \"docker run --rm -it --name ('rocky8-' + (Get-Random)) rocky8-dev:latest /bin/bash\"",
  "startingDirectory": "%USERPROFILE%"
}
```

## Step-by-step
1) Open Windows Terminal settings (Ctrl + ,).
2) Go to Profiles.
3) Add a new profile and paste one of the JSON snippets above.
4) Save and open a new tab with that profile.

## What each field means
- `name`: Display name shown in the profile list.
- `commandline`: Command that runs when the tab opens.
- `startingDirectory`: Folder the tab opens in on your Windows host.

## Notes
- Each new tab creates a new container with a unique name.
- Closing the tab stops the container because it runs in the foreground.
- Remove `--rm` if you want the container to persist after the tab closes.
 - Add mounts by inserting `-v "C:\\path\\to\\apps:/apps"` and `-v ".:/work"` into the commandline.
