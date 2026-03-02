#!/usr/bin/env bash
set -euo pipefail

# Create a non-root user and enable password-based SSH.
if ! id -u pipeline >/dev/null 2>&1; then
	useradd -m -s /bin/bash pipeline
	echo "pipeline:bfs@12345678" | chpasswd
	usermod -aG wheel pipeline
fi

if [ -f /etc/ssh/sshd_config ]; then
	sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
	sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
	sed -i 's/^#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
	sed -i 's/^PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
	mkdir -p /run/sshd
fi
