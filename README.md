# Touch Assistant

**Free • Offline • No ads • No tracking**

Ứng dụng Assistive Touch cho Android giống iOS, hoàn toàn miễn phí và offline.

## Tải APK nhanh

Vào tab **[Releases](https://github.com/BachDaThan/Touch-Assistant/releases)** → tải file `.apk` mới nhất → cài và dùng.

Mỗi lần push code lên `main`, GitHub Actions sẽ **tự động build APK và tạo Release** mới.

## Tính năng

- Nút nổi tròn kéo thả được, tự snap về cạnh
- Menu nhanh:
  - Home
  - Back
  - Recents (ứng dụng gần đây)
  - Khóa màn hình
  - Chụp màn hình
  - Tăng / Giảm âm lượng
- Không gửi dữ liệu lên server
- Không quảng cáo, không phí ẩn
- Mã nguồn mở

## Quyền cần thiết

1. **Accessibility Service** – chỉ dùng để thực hiện lệnh Home / Back / Recents / Lock / Screenshot khi bạn bấm.
2. **Display over other apps** – để hiện nút nổi trên mọi màn hình.

App **không** đọc nội dung màn hình, không theo dõi thao tác, không kết nối mạng.

## Cách push bằng Termux

```bash
cd $HOME
git clone https://github.com/BachDaThan/Touch-Assistant.git
cd Touch-Assistant

# Copy code mới vào
# (unzip Touch-Assistant.zip rồi copy)

git add .
git commit -m "1.0.0: Touch Assistant offline"
git push origin main
```

Sau khi push → vào **Actions** đợi build xong → vào **Releases** tải APK.

## License

MIT
