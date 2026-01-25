<<<<<<< HEAD
# h20_reminder
# LT_TBDD
# Link Figma: https://www.figma.com/design/x16VTQh7W0Byr0ApD81k7D/Untitled?node-id=0-1&m=dev&t=XSp96Zr051QZRb0v-1
Môn LT_Thiết bị di động Năm 3

Ứng dụng **nhắc nhở uống nước (H2O Reminder)** được phát triển bằng **Flutter**, hỗ trợ người dùng:
- Tính toán lượng nước khuyến nghị theo **cân nặng** và **mức độ hoạt động**
- Thiết lập **lịch nhắc uống nước** trong ngày
- Gửi **thông báo nhắc nhở** để duy trì thói quen uống nước
- Tích hợp **nhiệm vụ (missions)** và **game hóa (gamification)** với **EXP**, **nhân vật**, và **Shop** để tăng động lực sử dụng

---

## Features

### 1) Nhắc nhở uống nước (Reminder System)
- Tạo lịch nhắc uống nước theo thời gian trong ngày (ví dụ: mỗi 1 giờ hoặc khung giờ cụ thể)
- Tùy chỉnh tần suất nhắc nhở
- Gửi thông báo nhắc người dùng uống nước đúng giờ

### 2) Theo dõi lượng nước (Water Tracking)
- Ghi nhận lượng nước đã uống trong ngày
- Theo dõi tiến trình uống nước theo ngày
- Hướng tới hỗ trợ thống kê theo tuần/tháng (tùy theo phiên bản)

### 3) Tính toán mục tiêu nước theo cá nhân
Ứng dụng gợi ý mục tiêu uống nước (ml/ngày) dựa trên:
- Cân nặng người dùng
- Mức độ hoạt động (ít / vừa / nhiều)

### 4) Nhiệm vụ (Missions) & Game hóa (Gamification)
- Hệ thống nhiệm vụ giúp người dùng có động lực vào app thường xuyên
- Nhận thưởng / tăng EXP khi hoàn thành nhiệm vụ hoặc đạt mục tiêu uống nước
- Có **thanh kinh nghiệm (EXP bar)** để thể hiện tiến trình

### 5) Shop & Tùy biến nhân vật
- Shop giúp người dùng mua trang phục cho nhân vật
- Tạo cảm giác “sưu tầm” và tăng trải nghiệm game hóa

### 6) Đăng nhập và đăng kí cho người dùng
- Đăng nhập bằng email
- Đăng nhập bằng gmail hoặc facebook
  
### 7) Lưu trữ dữ liệu (Firebase + Local)
- Lưu dữ liệu trên **Firebase** để đồng bộ (nếu có đăng nhập/đồng bộ)
- Lưu dữ liệu **local** để dùng offline và tăng tốc độ tải dữ liệu

---
Yêu cầu phi chức năng (NFR):
Hoạt động hiệu quả, tiết kiệm pin.

Bảo mật dữ liệu local (có thể mã hóa).

Hỗ trợ offline.

Hỗ trợ đa ngôn ngữ (VN & EN) và accessibility.

## Tech Stack

- **Flutter / Dart**
- **Firebase**
  - Firestore / Realtime Database (tùy cách triển khai)
  - Firebase Storage (nếu có lưu asset người dùng)
  - Firebase Auth (nếu có đăng nhập)
- **Local Storage**
  - SharedPreferences / Hive / SQLite (tùy project triển khai)
- **Notifications**
  - Local Notification (nhắc uống nước theo lịch)
- Kiến trúc: MVVM (ViewModel + LiveData / StateFlow).

---

## Requirements

- Flutter SDK: >= 3.x
- Dart SDK: theo Flutter version
- Android Studio hoặc VS code
- Thiết bị Android/iOS hoặc Emulator/Simulator
- Firebase Project

---

## Installation & Run

### 1) Clone repository
```bash
git clone https://github.com/MP-1611/LT_TBDD.git
cd LT_TBDD

