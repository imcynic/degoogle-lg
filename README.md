# degoogle-lg

Block telemetry, ACR (automatic content recognition), and ads on LG webOS TVs.

LG smart TVs phone home constantly — collecting what you watch via ACR, serving ads on the home screen, and reporting usage data to LG and third parties like Alphonso. This blocklist sinkholes all of it at the DNS level by overriding `/etc/hosts` on the TV itself. No Pi-hole or router config needed.

Requires root access via [RootMyTV](https://rootmy.tv) or equivalent.

## What gets blocked

| Category | Domains | What it stops |
|----------|---------|---------------|
| ACR | `aic-gfts.lge.com`, `aic-ngfts.lge.com`, `aicr.lge.com` | Content fingerprinting that identifies what's on screen |
| Ads | `us.info.lgsmartad.com`, `ad.lgappstv.com`, `lgads.tv`, `lgad.cjpowercast.com`, + more | Home screen ads and ad tracking |
| Telemetry | `eum-col.lge.com`, `rdx.lge.com`, `rdx2.lge.com`, `snu.lge.com`, + more | Usage data, diagnostics, beacons |
| Third-party | `alphonso.tv` | Alphonso ACR (third-party content recognition) |

30+ domains total. See [`hosts`](hosts) for the full list.

## Install

```sh
git clone https://github.com/imcynic/degoogle-lg.git
cd degoogle-lg
./install.sh <tv-ip>
```

The script:
1. Copies the hosts blocklist to `/media/developer/custom_hosts` on the TV
2. Bind-mounts it over `/etc/hosts`
3. Creates a boot script at `/var/lib/webosbrew/init.d/` so it survives reboots

## Manual install

If you prefer to do it yourself:

```sh
scp hosts root@<tv-ip>:/media/developer/custom_hosts
ssh root@<tv-ip> 'mount --bind /media/developer/custom_hosts /etc/hosts'
```

For persistence, create `/var/lib/webosbrew/init.d/50-block-telemetry`:
```sh
#!/bin/sh
mount --bind /media/developer/custom_hosts /etc/hosts
```

## Adding domains

Edit `hosts` and re-run `./install.sh`, or edit `/media/developer/custom_hosts` on the TV directly. Format is one `0.0.0.0 domain` per line.

## What this doesn't do

- Doesn't block LG account login (that still works if you want it)
- Doesn't block app store or firmware updates
- Doesn't modify any system binaries

## See also

- [splitview](https://github.com/imcynic/splitview) — unlock multi-view / PiP on LG TVs without an LG account
- [RootMyTV](https://rootmy.tv) — root exploit for LG webOS TVs

## Status

Tested on LG OLED (webOS 24). The blocked domains are common across webOS models and generations. Not affiliated with LG.
