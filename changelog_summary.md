## New Docker Image Release Available

**Version**: v1.12.4-ls117
**Release Date**: 2026-03-21T23:04:10Z
**Release URL**: https://github.com/linuxserver/docker-obsidian/releases/tag/v1.12.4-ls117

### Release Notes

**CI Report:**

https://ci-tests.linuxserver.io/linuxserver/obsidian/v1.12.4-ls117/index.html

**LinuxServer Changes:**


* update wrappers to pass ozone when wayland is detected by @thelamer in https://github.com/linuxserver/docker-obsidian/pull/39


**Full Changelog**: https://github.com/linuxserver/docker-obsidian/compare/v1.12.4-ls116...v1.12.4-ls117

**Remote Changes:**

https://obsidian.md/changelog/2026-02-27-desktop-v1.12.4/

The windows installer has been updated with a signed version of Obsidian.com to reduce chances of false positive from antivirus software.

The windows installer has been updated again to roll back Electron to 39.6.0 due to a bug with 39.7.0 causing a window closure to close all other windows.
