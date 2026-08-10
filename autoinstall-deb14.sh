#!/bin/bash

set -e

RED='\e[0;31m'
GRE='\e[0;32m'
YEL='\e[0;33m'
YELI='\e[0;93m'
CYAN='\e[0;36m'
RES='\e[0m'

INSTALL_DIR="${HOME}/Applications"
AGH_ROOT="${INSTALL_DIR}/aghues_1.4.4"

if [ "$EUID" -eq 0 ]; then
  echo -e "${RED}Error: Run as regular user or without sudo.${RES}"
  exit 1
fi

echo "Installing dependency packages..."

DEPS=(
  wget curl build-essential cmake pkg-config libdbus-1-dev uuid-dev 
  uuid-runtime libx11-dev libxext-dev libxrender-dev libgl1-mesa-dev 
  libglu1-mesa-dev libgl1-mesa-dri libegl1-mesa-dev libglx-mesa0 
  libopengl0 libfreetype-dev libffi-dev libaudio-dev libpulse-dev 
  libcairo2-dev libpango1.0-dev libglib2.0-dev libasound2-dev 
  dialog whiptail libiconv-hook-dev libiconv-hook1 libsocket++1 
  libsocket++-dev libcrossguid-dev libcrossguid0 xclip xsel 
  libnsl-dev
)

if sudo -n true 2>/dev/null || [ -t 0 ]; then
  # Terminal or cached sudo session
  sudo apt update && sudo apt install -y "${DEPS[@]}"
elif command -v pkexec >/dev/null 2>&1; then
  # Graphical prompt fallback
  pkexec sh -c "apt update && apt install -y ${DEPS[*]}"
else
  echo -e "${RED}ERROR: Neither sudo nor pkexec available.${RES}"
  exit 1
fi

echo -e "${GRE}Installed dependencies successfully.${RES}\n"

echo -e "${CYAN}Downloading aghues... ${RES}"
TMP_DIR=$(mktemp -d)

if ! wget 'https://ggg.nairi.education/db/get?id=1ed8dc57-f49c-4b5e-acbe-7196c98f421f-93cb734c-09b2-42bb-99c7-b68cefd5bd71' -O "${TMP_DIR}/aghues.gz"; then
  echo -e "${RED}ERROR: Downloading failed. Please check connection.${RES}"
  rm -rf "${TMP_DIR}"
  exit 1
fi
echo -e "${GRE}Download Complete.${RES}"

# Ensure installation target folder exists
mkdir -p "${INSTALL_DIR}"

echo "Extracting into ${AGH_ROOT}..."
if ! tar -xf "${TMP_DIR}/aghues.gz" -C "${INSTALL_DIR}/"; then 
  echo -e "${RED}ERROR: Extraction failed.${RES}"
  rm -rf "${TMP_DIR}" "${AGH_ROOT}"
  exit 1
fi
rm -rf "${TMP_DIR}"
echo -e "${GRE}Extracted successfully.${RES}"

echo "Build/Install ..."
if [ -d "${AGH_ROOT}/aghues" ]; then
  cd "${AGH_ROOT}/aghues"
  if ! CFLAGS="-O2 -Wno-error=int-conversion -Wno-error=implicit-function-declaration -fpermissive" ./install.sh; then
    echo -e "${RED}ERROR: Build failed.${RES}"
    rm -rf "${AGH_ROOT}"
    exit 1
  fi
  echo -e "${GRE}Build finished successfully!${RES}"
else
  echo -e "${RED}ERROR: Directory ${AGH_ROOT}/aghues not found after extraction.${RES}"
  exit 1
fi
