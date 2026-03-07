````markdown
# nixos

NixOS system configuration for `cube`.

This repository is intended to live at:

```bash
/etc/nixos
```

## Purpose

This repo stores the machine’s active NixOS configuration and related local system files.

## Clone Location

Clone directly into `/etc/nixos`:

```bash
sudo git clone git@github.com:alexhraber/nixos.git /etc/nixos
```

If `/etc/nixos` already exists and contains files, move or back it up first.

## Apply Configuration

From inside the repo:

```bash
cd /etc/nixos
sudo nixos-rebuild switch
```

## Notes

- This repository is meant for this host’s real system configuration.
- Changes made here affect the live machine after rebuild.
- Commit carefully.
````
