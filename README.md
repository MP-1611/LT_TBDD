# LT_TBDD
# Link Figma: https://www.figma.com/design/x16VTQh7W0Byr0ApD81k7D/Untitled?node-id=0-1&m=dev&t=XSp96Zr051QZRb0v-1
Môn LT_Thiết bị di động Năm 3
Ứng dụng "Tên ứng dụng" giúp người dùng:
Đặt lịch nhắc uống nước theo thời gian trong ngày (ví dụ: mỗi 1 giờ / giờ cụ thể / theo giỏ thời gian).

Theo dõi lượng nước đã uống trong ngày, tuần, tháng.

Đưa ra mục tiêu cá nhân (ml/ngày) và gợi ý nhắc dựa trên trọng lượng, hoạt động.

Báo cáo/biểu đồ tiến độ; lịch sử; nhắc thông minh (skip khi đang ngủ, chế độ không làm phiền).

Lưu offline, đồng bộ (tuỳ chọn) và có cài đặt tuỳ biến (âm, rung, notification action “Uống ngay” + “Nhắc sau”).

Mục tiêu và yêu cầu:
Áp dụng kiến thức Android hiện đại (Kotlin, MVVM, Room, WorkManager, LiveData/StateFlow, Material Design).

Triển khai notification, background tasks, persistence, accessibility, unit/UI tests.

Yêu cầu chức năng (FR):
Đăng ký 1 tài khoản cơ bản (tuỳ chọn) hoặc dùng offline.

Thiết lập mục tiêu nước (ml/ngày).

Tạo lịch nhắc (các mẫu: khoảng cố định, giờ cụ thể, theo profile).

Tương tác notification có action “Đã uống” và “Nhắc sau`.

Lưu ghi nhận uống nước; hiển thị biểu đồ, thống kê.

Cài đặt: âm, rung, giới hạn giờ nhắc (ban đêm), nhắc thông minh.

Yêu cầu phi chức năng (NFR):
Hoạt động hiệu quả, tiết kiệm pin.

Bảo mật dữ liệu local (có thể mã hóa).

Hỗ trợ offline.

Hỗ trợ đa ngôn ngữ (VN & EN) và accessibility.

Kiến trúc & tech stack:
Ngôn ngữ: Kotlin

Kiến trúc: MVVM (ViewModel + LiveData / StateFlow).

Persistence: Room (local DB)

Background tasks / scheduling: WorkManager (PeriodicWork) + optional AlarmManager setExactAndAllowWhileIdle cho exact alarms.

DI: Hilt hoặc Koin

Network (nếu sync): Retrofit + Moshi/Gson

UI: Jetpack Compose (hoặc XML nếu bạn chưa biết Compose)

Chart: MPAndroidChart hoặc ComposeCharts

Testing: JUnit, Espresso, Robolectric

Build: Gradle (Kotlin DSL)

Minimum SDK: 21+ (tùy yêu cầu) — đề xuất 23+

