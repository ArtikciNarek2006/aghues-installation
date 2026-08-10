# Aghues installation guide for Debian 13

## Fast run script
```bash
curl -fsSL https://raw.githubusercontent.com/ArtikciNarek2006/aghues-installation/refs/heads/main/autoinstall.sh | bash
```
> curl needed `sudo apt update && sudo apt install -y curl`

## Manual step by step guide

- Download Aghues from [Nairi Education Page](https://ggg.nairi.education/#a2396e89-f4c5-4827-adb2-92cf73de45c1-341f0dc8-cf7f-4c32-9819-69e68adb44e4)
- Open terminal in download directory and run following commands as user (**NOT root**)
  > _It will delete old Aghues in ~/Applications folder_
```bash
mkdir -p ~/Applications
rm -rf ~/Applications/aghues_1.4.4
tar -xvf ./'Բեռնել «Աղուէս»-ը Linux ՕՀ-ի համար.gz' -C ~/Applications/aghues_1.4.4
```
- Install needed system packages
```bash
sudo apt update && sudo apt install -y wget curl \
  build-essential cmake pkg-config libdbus-1-dev uuid-dev uuid-runtime \
  libx11-dev libxext-dev libxrender-dev libgl1-mesa-dev \
  libglu1-mesa-dev libgl1-mesa-dri libegl1-mesa-dev libglx-mesa0 \
  libopengl0 libfreetype-dev libffi-dev libaudio-dev libpulse-dev \
  libcairo2-dev libpango1.0-dev libglib2.0-dev libasound2-dev \
  dialog whiptail libiconv-hook-dev libiconv-hook1 libsocket++1 \
  libsocket++-dev libcrossguid-dev libcrossguid0 xclip xsel \
  libnsl-dev libnsl2
```
> **NOTE**: libnsl2 isn't available on debian 14
- Now build and Install (Running aghues install.sh)
```bash
cd /Applications/aghues_1.4.4/aghues
CFLAGS="-O2 -Wno-error=int-conversion -Wno-error=implicit-function-declaration -fpermissive" ./install.sh
```

## Manual Uninstalation guide
- Run following
```bash
cd ~/Applications/aghues_1.4.4/aghues
CFLAGS="-O2 -Wno-error=int-conversion -Wno-error=implicit-function-declaration -fpermissive" ./install.sh -m
```
> - It will open install menu
> - Read and continue from there the uninstaltion
- After uninstalling remove Applications folder leftover `rm -rf ~/Applications/aghues_1.4.4`
