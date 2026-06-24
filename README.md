# Streaming Meulaboh

> Web funneling project — ELKIFAH PRODUCTION

## Overview

**Domain:** streamingmeulaboh.com  
**VPS:** 43.128.81.13 (Ubuntu 24.04)  
**Deployment:** Docker + Coolify (Traefik)  
**Network:** `coolify` (external)  
**GitHub:** [syahuri/streamingmeulaboh.com](https://github.com/syahuri/streamingmeulaboh.com)

## Infrastructure Setup

### DNS (Cloudflare)

| Record | Type | Value | Proxied | Notes |
|--------|------|-------|---------|-------|
| streamingmeulaboh.com | A | 43.128.81.13 | No (DNS only) | Initial setup; enable proxy after SSL |
| www.streamingmeulaboh.com | CNAME | streamingmeulaboh.com | Yes | Pre-existing |

**Cloudflare Zone ID:** `178ce7adb173811d283ca9c17684655d`  
**Zone Status:** initializing → active

**DNS cleanup performed:**
- Removed old A record: `streamingmeulaboh.com → 46.202.138.127` (proxied, was shadowing new record)
- Removed old AAAA record: `streamingmeulaboh.com → 2a02:4780:6:1858:0:254c:529b:2` (proxied)
- Created new A record: `streamingmeulaboh.com → 43.128.81.13` (DNS only, for Let's Encrypt SSL provisioning)

### Directory Structure

```
/srv/clients/streamingmeulaboh/    # Project root on VPS
```

### Deployment Plan

1. **PRD pending** — Tuan Syahuri will send the Product Requirements Document
2. Once PRD received, determine tech stack (likely Next.js or static site)
3. Create `docker-compose.yml` per ELKIFAH standard
4. Deploy via Coolify or `docker compose up -d`
5. Connect container(s) to `coolify` network
6. Configure Traefik routing (file provider or Coolify labels)
7. Verify with `curl --resolve` before DNS propagation
8. Enable Cloudflare proxy (orange cloud) after SSL is working
9. Set Cloudflare SSL mode to "Full" to avoid Error 526

### Coolify Traefik Routing

The Coolify proxy runs on the `coolify` network. For external containers (non-Coolify managed), use the file provider:

```yaml
# /data/coolify/proxy/dynamic/streamingmeulaboh.yaml
http:
  routers:
    streamingmeulaboh-http:
      rule: "Host(`streamingmeulaboh.com`)"
      entryPoints: [http]
      service: streamingmeulaboh
      priority: 100
    streamingmeulaboh-https:
      rule: "Host(`streamingmeulaboh.com`)"
      entryPoints: [https]
      service: streamingmeulaboh
      tls:
        certResolver: letsencrypt
      priority: 100
  services:
    streamingmeulaboh:
      loadBalancer:
        servers:
          - url: "http://<CONTAINER_IP>:<PORT>"
```

## Status

- [x] Project directory created: `/srv/clients/streamingmeulaboh/`
- [x] DNS A record created: `streamingmeulaboh.com → 43.128.81.13`
- [x] DNS cleanup: removed old A and AAAA records pointing to previous host
- [x] Initial project structure (README, .gitignore)
- [x] PRD received — `PRD.md` (live streaming for wisuda, pernikahan, seminar, event di Aceh Barat & Barat Selatan)
- [x] Git initialized locally (branch: `main`, initial commit done)
- [ ] GitHub repo: `syahuri/streamingmeulaboh.com` — **BLOCKED** (gh token lacks `repo` scope, see Notes)
- [ ] Git push to GitHub — **BLOCKED** (repo doesn't exist yet)
- [ ] Application code (PRD available, ready for development)
- [ ] Docker deployment
- [ ] Traefik routing
- [ ] SSL certificate (Let's Encrypt via Traefik)
- [ ] Cloudflare proxy enable + SSL mode "Full"

## Notes

- **GitHub repo creation blocked:** The current `gh` CLI token has no OAuth scopes (fine-grained token). Tuan needs to either:
  1. Re-authenticate `gh` with a token that has `repo` scope: `gh auth login --scopes repo`
  2. Or create the repo manually on GitHub: https://github.com/new (name: `streamingmeulaboh.com`, public)
  3. Then run: `git init && git remote add origin https://github.com/syahuri/streamingmeulaboh.com.git && git push -u origin main`
- **Cloudflare zone status:** Zone was in `initializing` state during setup. DNS API calls succeeded regardless.
- **FTP subdomain:** `ftp.streamingmeulaboh.com` still points to `46.202.138.127` (proxied) — left untouched as it may be from previous hosting.

---
*Created by Ultron (Infrastructure Agent) — ELKIFAH PRODUCTION*  
*Date: 2026-06-25*
