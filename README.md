# ArkOS, made by AI and not complete, just for fun

A themed, black-and-white respin of Ubuntu with your logo, custom boot
splash, custom console Login/Register flow, and XFCE desktop.

## Why this is a build project, not a finished .iso

Building an actual bootable ISO requires `live-build` to download and
assemble ~1-2GB of real Ubuntu packages, then run `xorriso`/`isolinux`
to stamp out a hybrid ISO — a process that needs real disk space, time,
and internet access to Ubuntu's package servers. That has to happen on
an actual Linux machine (or a Linux VM) that you control, not inside
a chat. Everything else — the code, theming, boot art, and the custom
login/register system — is fully built and included here. Building the
.iso from it is one command.

## How to build it — no Linux needed (recommended for Windows users)

This project includes a GitHub Actions workflow that builds the .iso for
you on GitHub's own free Linux servers. You never touch a terminal.

1. Create a free account at https://github.com if you don't have one.
2. Create a new repository (Settings: any name, e.g. `arkos`, Private or
   Public, doesn't matter).
3. On the repo's page, use "Add file → Upload files" and drag in
   **everything from this unzipped folder** (keep the folder structure —
   the `.github`, `auto`, `config` folders all need to go to the repo root).
4. Commit the upload.
5. Go to the **Actions** tab of your repo. You'll see "Build ArkOS ISO" —
   click it, then click **Run workflow** (or it may start automatically
   after your commit).
6. Wait ~20-40 minutes. When it finishes (green checkmark), open that
   run and scroll to **Artifacts** — download `ArkOS-iso.zip`. Inside is
   `ArkOS.iso`.
7. Boot that .iso in VirtualBox / VMware / QEMU like any other Linux ISO.

## Alternative: build it yourself on a Linux machine/VM

1. Get a Debian/Ubuntu machine or VM.
2. Unzip this project, `cd` into it.
3. Run:
   ```
   sudo ./build.sh
   ```
4. Wait for it to finish (~20-60 min depending on your connection).
   You'll get `ArkOS.iso` in this folder.
5. Boot that .iso in VirtualBox / VMware / QEMU like any other Linux ISO.

## What happens when it boots

- Plymouth shows a black screen with your logo while the system starts.
- It drops straight to a text console (no graphical login manager) and
  auto-runs the ArkOS menu:
  ```
  ============================================
                  A R K O S
  ============================================
    1) Login
    2) Register
    3) Shutdown
  ============================================
  ```
- **Register** creates a username + password (stored, hashed, in
  `/etc/arkos/users.db`) and a home directory.
- **Login** checks those credentials, then launches the XFCE desktop
  (`startxfce4`) styled in black/white with your logo as wallpaper.
- Logging out of XFCE returns you to the same menu.
- From any terminal inside ArkOS, typing `sudo boot` re-opens the same
  menu on demand.

## Customizing everything

This is a standard Debian `live-build` project — everything is a plain
file you can edit before running `build.sh` again:

| Want to change...            | Edit this                                                                 |
|-------------------------------|----------------------------------------------------------------------------|
| Installed packages            | `config/package-lists/arkos.list.chroot`                                  |
| Boot splash / logo             | `usr/share/plymouth/themes/arkos/` and `usr/share/backgrounds/arkos/`     |
| GRUB colors / timeout          | `config/includes.chroot/etc/default/grub`                                 |
| The Login/Register menu text/logic | `config/includes.chroot/usr/local/bin/arkos-login`                    |
| Desktop wallpaper / theme      | `config/includes.chroot/etc/skel/.config/xfce4/xfconf/...`                |
| MOTD banner                    | `config/includes.chroot/etc/motd`                                        |
| Distro name / ISO label        | `auto/config` (`--iso-application`, `--iso-volume`)                       |
| User account setup / sudoers   | `config/hooks/live/0100-arkos-setup.hook.chroot`                          |

After editing anything, just re-run `sudo ./build.sh`.

## Notes & honesty about limitations

- ArkOS accounts (Login/Register) are a themed layer on top of Linux,
  not full separate Unix users with their own permissions — good for a
  personal VM, not for a hardened multi-user server.
- `sudo boot` works because `boot` is a real script installed to
  `/usr/local/bin/boot` — it's not a real kernel boot command, just a
  convenient alias that reopens the ArkOS menu.
- Base OS is Ubuntu 22.04 (jammy) under the hood — ArkOS is a reskin/
  respin, which is how essentially all custom Linux distros are made.
