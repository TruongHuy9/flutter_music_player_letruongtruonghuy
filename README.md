# 🎵 Trình Phát Nhạc Offline

Ứng dụng trình phát nhạc offline được xây dựng bằng **Flutter**, cho phép người dùng phát nhạc trực tiếp từ thiết bị mà không cần kết nối internet.

## ✨ Tính Năng Chính

- ✅ **Phát nhạc offline** - Phát các bài hát đã lưu trên thiết bị
- ✅ **Quản lý danh sách phát** - Tạo, chỉnh sửa và xóa danh sách nhạc
- ✅ **Giao diện thân thiện** - Thiết kế đẹp mắt và dễ sử dụng
- ✅ **Kiểm soát phát nhạc** - Play, pause, next, previous, tua nhanh
- ✅ **Lưu trạng thái** - Tự động lưu vị trí phát nhạc
- ✅ **Dịch vụ audio nền** - Tiếp tục phát nhạc khi ứng dụng ở chế độ nền
- ✅ **Hỗ trợ yêu cầu cấp quyền** - Truy cập file nhạc trên thiết bị

## 🛠️ Công Nghệ Sử Dụng

- **Flutter** - Framework phát triển ứng dụng đa nền tảng
- **Dart** - Ngôn ngữ lập trình
- **just_audio** - Thư viện phát audio
- **audio_service** - Dịch vụ audio nền
- **Provider** - Quản lý trạng thái
- **shared_preferences** - Lưu dữ liệu cục bộ

## 📱 Hình Ảnh Minh Chứng

### Màn hình chính
![Màn hình chính](./screenshort/[THÊM_ẢNH_SCREEN_1_TẠI_ĐÂY])

### Danh sách nhạc
![Danh sách nhạc](./screenshort/[THÊM_ẢNH_SCREEN_2_TẠI_ĐÂY])

### Trình phát nhạc chi tiết
![Trình phát chi tiết](./screenshort/[THÊM_ẢNH_SCREEN_3_TẠI_ĐÂY])

### Danh sách phát
![Danh sách phát](./screenshort/[THÊM_ẢNH_SCREEN_4_TẠI_ĐÂY])

## 🚀 Cách Cài Đặt

### Yêu cầu
- Flutter SDK: >=3.10.3
- Android SDK (để chạy trên Android)
- iOS SDK (để chạy trên iOS)

### Bước 1: Clone dự án
```bash
git clone [LINK_REPOSITORY]
cd offline_music_player
```

### Bước 2: Cài đặt dependencies
```bash
flutter pub get
```

### Bước 3: Chạy ứng dụng
```bash
# Trên Android
flutter run -d android

# Trên iOS
flutter run -d ios

# Trên tất cả thiết bị
flutter run
```

## 📂 Cấu Trúc Dự Án

```
offline_music_player/
├── lib/
│   ├── main.dart              # Điểm vào của ứng dụng
│   ├── assets/               # Tài nguyên ứng dụng (nhạc, hình ảnh)
│   ├── models/               # Mô hình dữ liệu
│   ├── screens/              # Các màn hình UI
│   ├── services/             # Dịch vụ (audio, storage, ...)
│   ├── providers/            # State management (Provider)
│   └── widgets/              # Các component tái sử dụng
├── test/                     # Unit tests
├── android/                  # Cấu hình Android
├── build/                    # Output build
├── pubspec.yaml              # Cấu hình dự án Flutter
└── README.md                 # File này
```

## 🎮 Hướng Dẫn Sử Dụng

1. **Mở ứng dụng** - Khởi chạy ứng dụng trên thiết bị
2. **Cấp quyền** - Cho phép ứng dụng truy cập file nhạc trên thiết bị
3. **Quét nhạc** - Ứng dụng sẽ tự động quét các file MP3 trên thiết bị
4. **Chọn bài hát** - Nhấn vào bài hát để phát hoặc thêm vào danh sách phát
5. **Điều khiển** - Sử dụng các nút play/pause, tua nhanh, next/previous
6. **Tạo danh sách** - Tạo danh sách phát theo ý thích

## 🔧 Cấu Hình Build

### Android
Chỉnh sửa file `android/app/build.gradle` nếu cần:
```gradle
android {
    compileSdkVersion 34
    // ...
}
```

### iOS
Chỉnh sửa file `ios/Podfile` nếu cần

## 📝 Dependencies Chính

| Thư viện | Phiên bản | Mục đích |
|---------|---------|---------|
| just_audio | 0.9.36 | Phát audio |
| audio_service | 0.18.12 | Dịch vụ audio nền |
| provider | 6.1.1 | State management |
| shared_preferences | 2.2.2 | Lưu dữ liệu cục bộ |
| permission_handler | 11.1.0 | Quản lý quyền truy cập |
| file_picker | 8.0.0 | Chọn file |

## 🐛 Ghi Chú & Khắc Phục Sự Cố

### Vấn đề: Ứng dụng không tìm thấy file nhạc
- **Giải pháp**: Kiểm tra quyền truy cập file trong cài đặt ứng dụng

### Vấn đề: Audio dừng khi ứng dụng tắt màn hình
- **Giải pháp**: Dịch vụ audio nền đã được tích hợp, hãy kiểm tra cài đặt pin trong điện thoại

### Vấn đề: Lỗi build Android
- **Giải pháp**: 
  ```bash
  flutter clean
  flutter pub get
  flutter run
  ```

## 👨‍💻 Tác Giả

- **Họ Tên**: [THÊM TÊN CỦA BẠN]
- **MSSV**: [THÊM MSSV]
- **Email**: [THÊM EMAIL]
- **Lớp**: [THÊM LỚP]

## 📚 Tài Liệu Tham Khảo

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- [Just Audio Package](https://pub.dev/packages/just_audio)
- [Audio Service Package](https://pub.dev/packages/audio_service)

## 📄 Giấy Phép

Dự án này được cấp phép dưới giấy phép MIT. Xem file `LICENSE` để biết thêm chi tiết.

## 🙏 Lời Cảm Ơn

Cảm ơn các tác giả của các thư viện mã nguồn mở được sử dụng trong dự án này.

---

**Ghi chú**: Hãy thay thế các placeholder trong file này bằng thông tin thực tế của bạn trước khi push lên Git!
