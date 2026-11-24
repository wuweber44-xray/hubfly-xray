# Hubfly Xray image

VLESS + WebSocket (plaintext inside the container) for Hubfly Space free Shared
containers. Hubfly edge terminates TLS; clients use VLESS + WS + TLS on
`*.hubfly.app:443`.

## Image source — read this first

The `deploy/` code in the `hubfly-xray-ws-tls-skill` repo (free-dam-man) **was NOT
used**: it failed an execution-risk / safety check when read, the same class of
block as the Zoho AppSail deploy code. Nothing from that repo's `deploy/` was
copied, built, or reproduced here.

This image is adapted from Wu's own existing `xray-render` package
(`~/workspace/xray-render/`, same Alpine multi-stage shape: copy the xray
binary out of the official `ghcr.io/xtls/xray-core` image, which has no shell).
The only change is the entrypoint: it reads Hubfly's `WSPATH` env var
(falling back to `WS_PATH`).

## Container env (set in Hubfly console when creating the container)

| Key | Value (fresh, Hubfly-only — see `.env.hubfly`, never commit it) |
|---|---|
| `UUID` | `69a6a104-dd35-4a2b-ab55-b210394e1049` |
| `PORT` | `8080` |
| `WSPATH` | `/930a60ae670d65a32da5efd6` |

## Build

GitHub Actions (`.github/workflows/build-push-ttl.yml`) builds multi-arch
(`linux/amd64,linux/arm64`) with buildx and pushes anonymously to ttl.sh on
every push to `main`, or on manual `workflow_dispatch`.

- Image: `ttl.sh/hubfly-xray-ws:24h` — expires ~24h after push.
- A running container is unaffected by expiry; **before deleting and
  recreating a container, re-run the workflow for a fresh tag**.
- No registry login is needed (ttl.sh anonymous push); the workflow needs no
  secrets.

## Client URL (once Hubfly gives the subdomain `<host>`)

```text
vless://<UUID>@<host>:443?encryption=none&security=tls&type=ws&host=<host>&path=%2F930a60ae670d65a32da5efd6&sni=<host>#Hubfly
```

## Hubfly notes

- One project = one region (`usa-central` / `eu-central` / `eu-north`).
- Free Shared: 360 runtime hours/month, account-wide; idle ~15 min → sleep.
- Free tier has no host TCP ports — only the HTTPS subdomain works.
- Verify with a real client: SOCKS → `https://www.gstatic.com/generate_204`
  should return 204. Panel "Online" alone is not acceptance.
