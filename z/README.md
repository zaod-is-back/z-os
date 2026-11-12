# Z OS v1 build source package

This folder contains the BlissOS-based source bundle for the Z OS project.

## Base image

The upstream base used for the build is the official BlissOS x86_64 FOSS image from SourceForge:

- Bliss-v16.9.7-x86_64-OFFICIAL-foss-20241011.iso
- Source: https://sourceforge.net/projects/blissos-x86/files/Official/BlissOS16/FOSS/Generic/

This is a valid bootable ISO intended for BIOS and UEFI systems.

## Included files

- `z.iso`: built ISO artifact copied into the repo under the requested path.
- `build_zos.sh`: reusable build script to fetch, unpack, patch, and rebuild the source ISO.
- `branding/build.prop`: example branded Android build.prop values for Z OS.

## Required brand values

The generated image is intended to reflect:

- Device name: Z OS
- Manufacturer: ZAOD
- Build brand: Z OS
- Based on BlissOS (open source)

## Notes

This repository intentionally keeps the build process reproducible and uses the Open Source BlissOS x86_64 project as the upstream base. The build script is designed for Codespaces/Ubuntu and uses `wget`, `7z`, `fsck.erofs`, `debugfs`, `mksquashfs`, and `xorriso` as requested in the brief.
