# Hướng dẫn ký APK (để cài đè được)

## 1. Thêm GitHub Secrets

Vào repo → **Settings** → **Secrets and variables** → **Actions** → **New repository secret**

Thêm 4 secrets sau:

| Tên Secret            | Giá trị                                      |
|-----------------------|----------------------------------------------|
| `KEYSTORE_BASE64`     | Nội dung file `upload-keystore.b64` (1 dòng) |
| `KEYSTORE_PASSWORD`   | `TouchAssist2026!`                           |
| `KEY_PASSWORD`        | `TouchAssist2026!`                           |
| `KEY_ALIAS`           | `touchassistant`                             |

## 2. Lấy KEYSTORE_BASE64

Trên máy (hoặc Termux):

```bash
# File keystore mình đã tạo sẵn (giữ bí mật!)
base64 -w 0 upload-keystore.jks
# Copy toàn bộ chuỗi dài dán vào secret KEYSTORE_BASE64
```

## 3. Sau khi thêm secrets

Push code lên `main` → Actions tự build + **ký** APK → Release có file đã ký.

## Bảo mật

- **Không** commit file `.jks` / `key.properties` lên Git
- Chỉ lưu trong GitHub Secrets
- Đổi mật khẩu nếu lộ
