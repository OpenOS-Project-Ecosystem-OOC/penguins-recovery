# penguins-recovery integrations

External projects integrated into penguins-recovery builders, adapters, and scripts.

## Builders

| Builder | Upstream integrations | Output |
|---|---|---|
| `builders/debian` | debootstrap, live-build | Debian rescue ISO |
| `builders/arch` | mkarchiso | Arch rescue ISO |
| `builders/uki` | mkosi, systemd-ukify | Signed UKI EFI |
| `builders/uki-lite` | objcopy, EFI stub | Lightweight UKI EFI |
| `builders/verity-uki` | [brandsimon/verity-squash-root](https://github.com/brandsimon/verity-squash-root), [containerd/go-dmverity](https://github.com/containerd/go-dmverity) | dm-verity verified + Secure Boot signed UKI |
| `builders/lifeboat` | Alpine Linux | Single-file UEFI rescue EFI |
| `builders/rescatux` | live-build, rescapp | Rescatux ISO |

## Adapters

| Adapter | Upstream | Purpose |
|---|---|---|
| `adapters/adapter.sh` | — | Layer recovery tools onto penguins-eggs naked ISOs |
| `adapters/fuse-overlay/` | [containers/fuse-overlayfs](https://github.com/containers/fuse-overlayfs) | Rootless ISO adaptation (no root required) |

## Recovery Scripts

| Script | Upstream | Purpose |
|---|---|---|
| `common/scripts/chroot-rescue.sh` | — | Mount and chroot into installed Linux system |
| `common/scripts/btrfs-rescue.sh` | [kdave/btrfs-devel](https://github.com/kdave/btrfs-devel) | Btrfs subvolume-aware rescue, snapshot rollback |
| `common/scripts/erofs-rescue.sh` | [erofs/erofs-utils](https://github.com/erofs/erofs-utils) | EROFS image check, dump, extract, mount |
| `common/scripts/detect-disks.sh` | — | Detect and classify storage devices |
| `common/scripts/grub-restore.sh` | — | Restore GRUB bootloader |
| `common/scripts/password-reset.sh` | — | Reset user passwords via chroot |
| `common/scripts/uefi-repair.sh` | — | Repair UEFI boot entries |

---

## verity-uki builder

The `builders/verity-uki/` builder produces a recovery image with a full chain of trust:

```
UEFI firmware
  └─ verifies → recovery-verified.efi (signed UKI)
       └─ cmdline embeds root hash → dm-verity Merkle tree
            └─ verifies → recovery.squashfs (recovery rootfs)
```

An attacker who modifies `recovery.squashfs` on disk will cause boot to fail.

```bash
# Build without signing (testing)
make verity-uki

# Build with Secure Boot signing
make verity-uki SIGN=1 KEY=/etc/keys/db.key CERT=/etc/keys/db.crt

# Build from existing SquashFS
make verity-uki SQUASHFS=/path/to/recovery.squashfs SIGN=1 KEY=db.key CERT=db.crt
```

## Rootless adaptation (fuse-overlayfs)

Layer recovery tools onto a penguins-eggs naked ISO without root:

```bash
# Check overlay support
make adapt-rootless-check

# Adapt ISO rootlessly
make adapt-rootless INPUT=naked.iso OUTPUT=recovery.iso

# With UID/GID mapping (for rootless containers)
make adapt-rootless INPUT=naked.iso OUTPUT=recovery.iso UID_MAP=0:100000:65536 GID_MAP=0:100000:65536
```

## Btrfs rescue

Rescue Btrfs-rooted systems with subvolume awareness:

```bash
# Detect subvolume layout
make btrfs-rescue CMD=detect-layout PART=/dev/sda3

# Chroot into correct subvolume (auto-detects @, @root, etc.)
make btrfs-rescue CMD=chroot PART=/dev/sda3

# List snapshots (snapper/timeshift/eggs)
make btrfs-rescue CMD=list-snapshots PART=/dev/sda3

# Roll back to a snapshot
sudo ./common/scripts/btrfs-rescue.sh rollback /dev/sda3 @/.snapshots/5/snapshot
```

## EROFS rescue

Inspect and recover EROFS filesystem images:

```bash
# Check kernel support
make erofs-kernel-check

# Check image integrity
make erofs-check IMAGE=/path/to/system.erofs

# Dump superblock metadata
./common/scripts/erofs-rescue.sh dump /path/to/system.erofs

# Extract image contents
./common/scripts/erofs-rescue.sh extract /path/to/system.erofs /tmp/extracted
```
