.PHONY: help bootloaders debian arch uki uki-lite verity-uki lifeboat rescatux rescapp adapt adapt-rootless erofs-check btrfs-rescue clean

help: ## Show available targets
	@grep -E '^[a-zA-Z_-]+:.*##' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*## "}; {printf "  %-20s %s\n", $$1, $$2}'

# === Standalone Builders ===

bootloaders: ## Package system bootloaders into bootloaders.tar.gz
	cd bootloaders && bash create-bootloaders

bootloaders-src: ## Clone and build bootloaders from source
	cd bootloaders && bash build-from-source.sh

bootloaders-all: bootloaders-src bootloaders ## Build source bootloaders then package everything

debian: ## Build Debian-based rescue ISO (requires root, debootstrap)
	cd builders/debian && sudo ./make

arch: ## Build Arch-based rescue ISO (requires mkarchiso)
	cd builders/arch && sudo mkarchiso -v -w /tmp/archiso-work -o out .

uki: ## Build UKI rescue EFI image (requires mkosi, systemd-ukify)
	cd builders/uki && mkosi build

uki-lite: ## Build lightweight rescue UKI from host kernel (requires binutils, EFI stub)
	cd builders/uki-lite && sudo ./build.sh --output rescue.efi

verity-uki: ## Build dm-verity verified, Secure Boot-signed recovery UKI
	@# Usage: make verity-uki [SIGN=1] [KEY=path/to/db.key] [CERT=path/to/db.crt]
	@# Usage: make verity-uki SQUASHFS=path/to/recovery.squashfs
	cd builders/verity-uki && sudo ./build.sh \
		$(if $(SQUASHFS),--squashfs "$(SQUASHFS)") \
		$(if $(SIGN),--key "$(KEY)" --cert "$(CERT)",--no-sign) \
		$(if $(OUTPUT),--output "$(OUTPUT)")

verity-uki-check-deps: ## Check dependencies for verity-uki builder
	@echo "Checking verity-uki dependencies..."
	@for tool in mksquashfs veritysetup objcopy sbsign; do \
		if command -v $$tool >/dev/null 2>&1; then \
			echo "  ✓ $$tool"; \
		else \
			echo "  ✗ $$tool (missing)"; \
		fi; \
	done
	@echo ""
	@echo "Install missing: apt install squashfs-tools cryptsetup-bin binutils sbsigntool"

lifeboat: ## Build Alpine-based single-file UEFI rescue EFI (requires gcc, make, wget, fakeroot)
	cd builders/lifeboat && $(MAKE) build

rescatux: ## Build Rescatux ISO (requires live-build, root)
	cd builders/rescatux && sudo ./make-rescatux.sh

rescapp: ## Install rescapp (requires Python3, PyQt5, kdialog)
	cd tools/rescapp && sudo make install

# === Adapter (layer recovery onto penguins-eggs naked ISOs) ===

adapt: ## Layer recovery onto naked ISO. Usage: make adapt INPUT=<iso> [OUTPUT=<iso>] [RESCAPP=1] [SECUREBOOT=1] [GUI=minimal|touch|full]
	@if [ -z "$(INPUT)" ]; then echo "Usage: make adapt INPUT=path/to/naked.iso [OUTPUT=recovery.iso] [RESCAPP=1] [SECUREBOOT=1] [GUI=minimal|touch|full]"; exit 1; fi
	sudo ./adapters/adapter.sh --input "$(INPUT)" \
		$(if $(OUTPUT),--output "$(OUTPUT)") \
		$(if $(RESCAPP),--with-rescapp) \
		$(if $(SECUREBOOT),--secureboot) \
		$(if $(GUI),--gui "$(GUI)")

adapt-rootless: ## Layer recovery onto naked ISO without root (uses fuse-overlayfs). Usage: make adapt-rootless INPUT=<iso> OUTPUT=<iso>
	@if [ -z "$(INPUT)" ] || [ -z "$(OUTPUT)" ]; then \
		echo "Usage: make adapt-rootless INPUT=path/to/naked.iso OUTPUT=recovery.iso"; exit 1; fi
	./adapters/fuse-overlay/fuse-overlay-adapter.sh \
		--input "$(INPUT)" \
		--output "$(OUTPUT)" \
		$(if $(UID_MAP),--uid-map "$(UID_MAP)") \
		$(if $(GID_MAP),--gid-map "$(GID_MAP)")

adapt-rootless-check: ## Check fuse-overlayfs availability for rootless adaptation
	./adapters/fuse-overlay/fuse-overlay-adapter.sh --check

# === Recovery Scripts ===

btrfs-rescue: ## Run Btrfs-aware rescue operations. Usage: make btrfs-rescue CMD=chroot PART=/dev/sda3
	@if [ -z "$(CMD)" ] || [ -z "$(PART)" ]; then \
		echo "Usage: make btrfs-rescue CMD=<command> PART=<partition>"; \
		echo "Commands: chroot list-subvols list-snapshots rollback check scrub-status detect-layout"; \
		exit 1; fi
	sudo ./common/scripts/btrfs-rescue.sh "$(CMD)" "$(PART)" $(if $(SNAP),"$(SNAP)")

erofs-check: ## Check an EROFS image. Usage: make erofs-check IMAGE=path/to/image.erofs
	@if [ -z "$(IMAGE)" ]; then echo "Usage: make erofs-check IMAGE=path/to/image.erofs"; exit 1; fi
	./common/scripts/erofs-rescue.sh check "$(IMAGE)"

erofs-kernel-check: ## Check if running kernel supports EROFS
	./common/scripts/erofs-rescue.sh kernel-check

# === Cleanup ===

clean: ## Remove build artifacts
	rm -rf bootloaders/bootloaders bootloaders/bootloaders.tar.gz
	rm -rf bootloaders/src bootloaders/out
	rm -rf builders/debian/rootdir builders/debian/*.iso
	rm -rf builders/arch/work builders/arch/out
	rm -rf builders/uki/mkosi.builddir builders/uki/mkosi.cache
	rm -f builders/uki-lite/rescue.efi
	rm -f builders/verity-uki/recovery-verified.efi
	rm -f builders/verity-uki/recovery.squashfs
	rm -f builders/verity-uki/recovery.squashfs.verity
	rm -f builders/verity-uki/root-hash.txt builders/verity-uki/salt.txt
	rm -rf builders/lifeboat/build/alpine-minirootfs* builders/lifeboat/build/linux*
	rm -f builders/lifeboat/build/config.initramfs_root
	rm -f builders/lifeboat/dist/LifeboatLinux.efi
	rm -rf builders/rescatux/rescatux-release
	rm -rf recovery-manager/target
	rm -rf /tmp/penguins-recovery-work
	rm -rf /tmp/verity-uki-work
	rm -rf /tmp/fuse-overlay-work
	rm -rf /tmp/btrfs-rescue
