#!/bin/bash
# EC2 user data for Amazon Linux 2023.
# Intended to run during first boot. Never put credentials or secrets here.

set -Eeuo pipefail
exec > >(tee -a /var/log/user-data-apache-demo.log | logger -t user-data-apache-demo -s 2>/dev/console) 2>&1

echo "[INFO] Installing Apache"
dnf install -y httpd

echo "[INFO] Writing demo web page"
cat > /var/www/html/index.html <<'HTML'
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>AWS EC2 Apache Demo</title>
  <style>
    body { font-family: Arial, sans-serif; max-width: 760px; margin: 4rem auto; padding: 0 1.25rem; line-height: 1.6; color: #172033; }
    main { border: 1px solid #d9e0ea; border-radius: 12px; padding: 2rem; }
    h1 { color: #b45309; }
    code { background: #f1f5f9; padding: .15rem .35rem; border-radius: 4px; }
  </style>
</head>
<body>
  <main>
    <h1>AWS EC2 Apache Demo</h1>
    <p>This page is served by Apache HTTP Server on an Amazon Linux EC2 instance.</p>
    <p>Project: aws-cloud-projects/01-ec2-web-server</p>
    <p>Next steps: verify service health, review logs, and improve security.</p>
  </main>
</body>
</html>
HTML

chmod 0644 /var/www/html/index.html
restorecon -Rv /var/www/html 2>/dev/null || true

echo "[INFO] Enabling and starting Apache"
systemctl enable --now httpd
systemctl is-active --quiet httpd
curl --fail --silent --show-error http://localhost/ >/dev/null

echo "[SUCCESS] Apache installed and local HTTP check passed"
