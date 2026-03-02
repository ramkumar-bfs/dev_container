#!/usr/bin/env bash
set -euo pipefail

# Enable extra repos for Lmod/EasyBuild packages.
if [ -f /etc/os-release ]; then
  . /etc/os-release
  if [ "${ID}" = "rocky" ]; then
    if [[ "${VERSION_ID}" == 8* ]]; then
      dnf -y config-manager --set-enabled powertools || true
    elif [[ "${VERSION_ID}" == 9* ]]; then
      dnf -y config-manager --set-enabled crb || true
    fi
  fi
fi

dnf -y install epel-release

# Install Lua, Lmod, and EasyBuild (latest from repos).
dnf -y --allowerasing install \
  lua \
  lua-devel \
  easybuild || true

# Lmod package name differs across repos.
if ! rpm -q lmod >/dev/null 2>&1 && ! rpm -q Lmod >/dev/null 2>&1; then
  dnf -y --allowerasing install Lmod || dnf -y --allowerasing install lmod || true
fi

if ! rpm -q lmod >/dev/null 2>&1 && ! rpm -q Lmod >/dev/null 2>&1; then
  echo "Lmod package not installed. Check that EPEL is enabled and available."
  exit 1
fi

# Fallback to pip if easybuild is not available in repos.
if ! command -v eb >/dev/null 2>&1; then
  python3 -m pip install --upgrade pip
  python3 -m pip install easybuild
fi

# Ensure Lmod init script is available on login shells.
if [ -d /usr/share/lmod/lmod/init ]; then
  cat > /etc/profile.d/lmod.sh <<'EOF'
if [ -f /usr/share/lmod/lmod/init/bash ]; then
  . /usr/share/lmod/lmod/init/bash
fi
EOF
  cat > /etc/profile.d/lmod.csh <<'EOF'
if ( -f /usr/share/lmod/lmod/init/csh ) then
  source /usr/share/lmod/lmod/init/csh
endif
EOF
fi
