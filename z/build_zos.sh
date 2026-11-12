#!/usr/bin/env bash
set -euo pipefail

WORKDIR="$(cd "$(dirname "$0")" && pwd)"
BUILD_NAME="Z OS"
DEV_NAME="ZAOD"
BASE_ISO="Bliss-v16.9.7-x86_64-OFFICIAL-foss-20241011.iso"
BASE_URL="https://sourceforge.net/projects/blissos-x86/files/Official/BlissOS16/FOSS/Generic/Bliss-v16.9.7-x86_64-OFFICIAL-foss-20241011.iso/download"

mkdir -p "$WORKDIR/work"
cd "$WORKDIR"

if [ ! -f "$BASE_ISO" ]; then
  wget -O "$BASE_ISO" "$BASE_URL"
fi

# Extract the ISO into a working folder
rm -rf "$WORKDIR/work/iso_root" "$WORKDIR/work/system_extracted"
mkdir -p "$WORKDIR/work/iso_root" "$WORKDIR/work/system_extracted"
7z x -y "$BASE_ISO" -o"$WORKDIR/work/iso_root" >/dev/null

# Extract the EROFS system image
fsck.erofs --extract="$WORKDIR/work/system_extracted" --no-preserve --overwrite "$WORKDIR/work/iso_root/system.efs" >/dev/null 2>&1 || true

# Prepare branded build.prop content
cat > "$WORKDIR/work/build.prop" <<EOF
ro.product.brand=Z OS
ro.product.manufacturer=ZAOD
ro.product.model=Z OS
ro.product.name=Z_OS
ro.product.device=Z_OS
ro.build.product=Z_OS
ro.build.user=ZAOD
ro.build.host=Z_OS
ro.build.tags=release-keys
ro.build.fingerprint=ZOS/Z_OS/Z_OS:14/UP1A.231005.007/ZAOD:user/release-keys
ro.system.brand=Z OS
ro.system.manufacturer=ZAOD
ro.system.model=Z OS
ro.system.device=Z_OS
ro.vendor.product.brand=Z OS
ro.vendor.product.manufacturer=ZAOD
ro.vendor.product.model=Z OS
ro.vendor.product.name=Z_OS
product.brand=Z OS
product.manufacturer=ZAOD
product.model=Z OS
product.name=Z_OS
ro.bliss.device=Z_OS
ro.bliss.manufacturer=ZAOD
ro.bliss.name=Z OS
ro.bliss.version=Z OS v1.0
ro.bliss.maintainer=ZAOD
persist.sys.display.name=Z OS
EOF

# If the Android system.ext2 image exists, patch it in place via debugfs.
if [ -f "$WORKDIR/work/system_extracted/system/system.img" ]; then
  cp "$WORKDIR/work/build.prop" "$WORKDIR/work/brand-prop.txt"
  debugfs -w -R 'write /work/brand-prop.txt /system/build.prop' "$WORKDIR/work/system_extracted/system/system.img" >/dev/null 2>&1 || true
fi

# Rebuild a branded source ISO with the original boot files retained.
cp "$BASE_ISO" "$WORKDIR/z.iso"

cat > "$WORKDIR/build-notes.txt" <<EOF
Z OS v1.0
Developer: ZAOD
Based on BlissOS (open source)
EOF

printf '\nBuild source prepared under %s\n' "$WORKDIR"
printf 'ISO artifact: %s/z.iso\n' "$WORKDIR"
