#  Trình Phát Nhạc Offline

Ứng dụng trình phát nhạc offline được xây dựng bằng **Flutter**, cho phép người dùng phát nhạc trực tiếp từ thiết bị mà không cần kết nối internet.

##  Tính Năng Chính

-  **Phát nhạc offline** - Phát các bài hát đã lưu trên thiết bị
-  **Quản lý danh sách phát** - Tạo, chỉnh sửa và xóa danh sách nhạc
-  **Giao diện thân thiện** - Thiết kế đẹp mắt và dễ sử dụng
-  **Kiểm soát phát nhạc** - Play, pause, next, previous, tua nhanh
-  **Lưu trạng thái** - Tự động lưu vị trí phát nhạc
-  **Dịch vụ audio nền** - Tiếp tục phát nhạc khi ứng dụng ở chế độ nền
-  **Hỗ trợ yêu cầu cấp quyền** - Truy cập file nhạc trên thiết bị

##  Công Nghệ Sử Dụng

- **Flutter** - Framework phát triển ứng dụng đa nền tảng
- **Dart** - Ngôn ngữ lập trình
- **just_audio** - Thư viện phát audio
- **audio_service** - Dịch vụ audio nền
- **Provider** - Quản lý trạng thái
- **shared_preferences** - Lưu dữ liệu cục bộ

##  Hình Ảnh Minh Chứng

### Màn hình chính
<img width="521" height="973" alt="Screenshot 2026-05-15 231456" src="https://github.com/user-attachments/assets/da8ed8f9-2440-4d12-97da-9e060cb2c156" />

### Danh sách nhạc
<img width="575" height="276" alt="Screenshot 2026-05-16 004807" src="https://github.com/user-attachments/assets/e50f11d0-6586-415f-9d7b-bf070cc8062a" />

### Trình phát nhạc chi tiết
<img width="412" height="818" alt="Screenshot 2026-05-15 235028" src="https://github.com/user-attachments/assets/a8ab8d21-e387-491a-846d-4d0f8cb02aaa" />

### Danh sách phát
<img width="402" height="815" alt="Screenshot 2026-05-15 234735" src="https://github.com/user-attachments/assets/0cb4421b-ead9-47f7-9161-a7f2b7cd52a6" />

### Xuất danh sách phát ra pdf
<img width="482" height="848" alt="Screenshot 2026-05-16 003019" src="https://github.com/user-attachments/assets/56179ec0-c0a0-470c-8f9e-b8e7c5306925" />

### Edit danh sách phát
<img width="555" height="862" alt="Screenshot 2026-05-16 003253" src="https://github.com/user-attachments/assets/d5b15aa2-7d07-40e1-ae20-dc207aceafeb" />

### Xóa bài hát khỏi playlist
<img width="492" height="855" alt="Screenshot 2026-05-16 003011" src="https://github.com/user-attachments/assets/74b5c46b-3266-4d70-b3cf-391277cf81b8" />

### Đầy đủ back, next, pause bài hát, trộn bài, phát lại vòng lặp 1 playlist và phát lại 1 bài duy nhất
<img width="412" height="818" alt="Screenshot 2026-05-15 235028" src="https://github.com/user-attachments/assets/a77c5e35-7fa5-49eb-8104-5f2b6a3b8a52" />

### Xem thông tin bài hát
<img width="442" height="822" alt="Screenshot 2026-05-15 235002" src="https://github.com/user-attachments/assets/d4948185-1524-49f0-a2ed-c7890520b626" />

### Một số chức năng thêm share bài hát
<img width="467" height="787" alt="Screenshot 2026-05-15 234952" src="https://github.com/user-attachments/assets/878a842b-f797-4f0e-be82-735d5fed118e" />

<img width="450" height="830" alt="Screenshot 2026-05-15 234957" src="https://github.com/user-attachments/assets/f8af5c94-168c-460e-a9a6-4d3586077be3" />

### Màn hình trang Setting
<img width="383" height="800" alt="Screenshot 2026-05-15 234932" src="https://github.com/user-attachments/assets/40dd2547-8f53-4df3-9680-645417043262" />

### Chức năng sort theo Artist, ngày thêm, tilte bài hát, 
<img width="351" height="576" alt="Screenshot 2026-05-15 234910" src="https://github.com/user-attachments/assets/f361b817-c5a6-4325-9085-bd44f92c635d" />

<img width="345" height="688" alt="Screenshot 2026-05-15 234925" src="https://github.com/user-attachments/assets/fc4162f5-2ea6-4b85-b400-6c7264bb08eb" />

### Tạo playlist mới
<img width="433" height="807" alt="Screenshot 2026-05-15 234751" src="https://github.com/user-attachments/assets/d79381b8-e3b5-4b72-a406-dc5a070cd23b" />

### Tìm kiếm bài hát
<img width="467" height="843" alt="Screenshot 2026-05-15 234631" src="https://github.com/user-attachments/assets/ad36faef-eeaa-4d57-ac80-3389aaa65032" />
<img width="436" height="816" alt="Screenshot 2026-05-15 234637" src="https://github.com/user-attachments/assets/d50a8a06-b563-4d6c-aa10-03e09433b2ae" />

### Xin quyền truy cập
<img width="388" height="760" alt="Screenshot 2026-05-14 200720" src="https://github.com/user-attachments/assets/6973920b-9846-4fa0-b8e4-a21c3600ab5e" />

##  Cách Cài Đặt

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
lib/                                    # Mã nguồn chính
│   ├── main.dart                          # Điểm vào của ứng dụng
│   │
│   ├── assets/                            # Tài nguyên ứng dụng
│   │   ├── audio/
│   │   │   └── sample_songs/              # Các bài hát mẫu (MP3)
│   │   └── images/                        # Hình ảnh ứng dụng
│   │
│   ├── models/                            # Mô hình dữ liệu
│   │   ├── song_model.dart                # Mô hình bài hát
│   │   ├── playlist_model.dart            # Mô hình danh sách phát
│   │   └── playback_state_model.dart      # Mô hình trạng thái phát nhạc
│   │
│   ├── screens/                           # Các màn hình UI
│   │   ├── home_screen.dart               # Màn hình chính
│   │   ├── all_songs_screen.dart          # Màn hình danh sách tất cả bài hát
│   │   ├── now_playing_screen.dart        # Màn hình phát nhạc (phiên bản 1)
│   │   ├── now_playing_screen_new.dart    # Màn hình phát nhạc (phiên bản mới)
│   │   ├── playlist_screen.dart           # Màn hình danh sách danh sách phát
│   │   ├── playlist_detail_screen.dart    # Màn hình chi tiết danh sách phát
│   │   ├── search_screen.dart             # Màn hình tìm kiếm bài hát
│   │   └── settings_screen.dart           # Màn hình cài đặt
│   │
│   ├── services/                          # Dịch vụ logic
│   │   ├── audio_player_service.dart      # Dịch vụ phát audio
│   │   ├── playlist_service.dart          # Dịch vụ quản lý danh sách phát
│   │   ├── storage_service.dart           # Dịch vụ lưu trữ dữ liệu
│   │   ├── permission_service.dart        # Dịch vụ quản lý quyền truy cập
│   │   ├── notification_service.dart      # Dịch vụ thông báo
│   │   └── app_lifecycle_manager.dart     # Dịch vụ quản lý vòng đời ứng dụng
│   │
│   ├── providers/                         # State Management (Provider)
│   │   ├── audio_provider.dart            # Provider cho audio player
│   │   ├── playlist_provider.dart         # Provider cho danh sách phát
│   │   └── theme_provider.dart            # Provider cho chủ đề ứng dụng
│   │
│   ├── utils/                             # Công cụ tiện ích
│   │   ├── constants.dart                 # Các hằng số (màu sắc, kích thước, ...)
│   │   ├── duration_formatter.dart        # Công cụ định dạng thời gian
│   │   └── color_extractor.dart           # Công cụ trích xuất màu từ ảnh
│   │
│   └── widgets/                           # Các component tái sử dụng
│       ├── song_tile.dart                 # Component hiển thị một bài hát
│       ├── playlist_card.dart             # Component hiển thị danh sách phát
│       ├── player_controls.dart           # Component điều khiển phát nhạc
│       ├── progress_bar.dart              # Component thanh tiến độ
│       ├── mini_player.dart               # Component trình phát mini
│       └── album_art.dart                 # Component hiển thị ảnh bìa album               # File này
```

##  Hướng Dẫn Sử Dụng

1. **Mở ứng dụng** - Khởi chạy ứng dụng trên thiết bị
2. **Cấp quyền** - Cho phép ứng dụng truy cập file nhạc trên thiết bị
3. **Quét nhạc** - Ứng dụng sẽ tự động quét các file MP3 trên thiết bị
4. **Chọn bài hát** - Nhấn vào bài hát để phát hoặc thêm vào danh sách phát
5. **Điều khiển** - Sử dụng các nút play/pause, tua nhanh, next/previous
6. **Tạo danh sách** - Tạo danh sách phát theo ý thích

##  Cấu Hình Build

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

##  Dependencies Chính

| Thư viện | Phiên bản | Mục đích |
|---------|---------|---------|
| just_audio | 0.9.36 | Phát audio |
| audio_service | 0.18.12 | Dịch vụ audio nền |
| provider | 6.1.1 | State management |
| shared_preferences | 2.2.2 | Lưu dữ liệu cục bộ |
| permission_handler | 11.1.0 | Quản lý quyền truy cập |
| file_picker | 8.0.0 | Chọn file |

##  Ghi Chú & Khắc Phục Sự Cố

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


## Tài Liệu Tham Khảo

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- [Just Audio Package](https://pub.dev/packages/just_audio)
- [Audio Service Package](https://pub.dev/packages/audio_service)

##  Lời Cảm Ơn

Cảm ơn các tác giả của các thư viện mã nguồn mở được sử dụng trong dự án này.

---

**Ghi chú**: Hãy thay thế các placeholder trong file này bằng thông tin thực tế của bạn trước khi push lên Git!
