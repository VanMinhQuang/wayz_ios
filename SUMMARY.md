# Wayz — App Summary

Wayz là ứng dụng iOS giúp người dùng **khám phá địa điểm để hangout**: quán ăn, cà phê, điểm check-in, không gian gặp gỡ bạn bè. Bên cạnh bản đồ, Wayz còn có chat và social network để bạn bè cùng chia sẻ những trải nghiệm địa điểm với nhau.

> Xem [README.md](./README.md) để biết cách setup dự án và kiến trúc code.

---

## 🎯 Giá trị cốt lõi

- **Khám phá địa điểm** thông minh dựa vào vị trí hiện tại của người dùng
- **Đóng góp cộng đồng** — user tự thêm địa điểm mới, đánh giá, review có ảnh
- **Kết nối bạn bè** — chat, story, follow, block như Facebook/Instagram
- **Nhắm đến người trẻ Việt Nam** — nội dung hoàn toàn tiếng Việt, UI thân thiện

---

## 📱 Cấu trúc app — 3 tab chính

### 🗺️ Tab 1 — Map

Bản đồ tương tác dựa trên MapLibre + tile MapVina.

| Chức năng | Chi tiết |
|---|---|
| Xem địa điểm | Marker theo loại (nhà hàng, cà phê, bar, park…), tap để xem card tóm tắt |
| Chi tiết địa điểm | Sheet toàn màn hình với ảnh, mô tả, giờ mở cửa, tags, tab About/Comments/Images |
| Bình luận + rating | User comment (kèm ảnh, emoji), reply threaded như Facebook, rate 5 sao |
| Thêm địa điểm mới | User tự tạo địa điểm mới ngay tại vị trí họ đang đứng — nhập tên, loại, mô tả, upload ảnh |
| Tìm kiếm | Search theo tên hoặc lọc theo bán kính quanh vị trí hiện tại |
| Chỉ đường | Turn-by-turn navigation kiểu Google Maps đến địa điểm đã chọn (MapVina Directions API) |
| Nearby | Nút "vị trí của tôi" — recentre camera + reload places quanh user |

### 💬 Tab 2 — Chat

Trải nghiệm nhắn tin + story giống Facebook Messenger / Instagram.

| Chức năng | Chi tiết |
|---|---|
| Danh sách hội thoại | Header, thanh tìm kiếm, danh sách chat kèm avatar, tin cuối, unread badge |
| Story tray | Hàng ngang phía trên — mỗi user 1 avatar có viền gradient nếu còn story |
| Story viewer | Toàn màn hình, swipe ngang giữa user (PageView), tap phải/trái để chuyển story, long-press pause |
| Story types | **Text** (gradient background + caption), **Image** (full-bleed), **Video** (AVPlayer + audio) |
| Story music | Nhạc nền tùy chọn cho story text/image (icon 🎵 hiển thị ở header khi có nhạc) |
| Chat 1-1 realtime | Push text/emoji (image, video trong tương lai) qua WebSocket, hiển thị bubble kiểu chat |
| Composer | TextField tự-grow, gửi bằng nút hoặc phím return |
| Message status | Sending → sent → delivered → read (roadmap) |

### 👤 Tab 3 — Profile

Trang cá nhân của user và cơ chế mạng xã hội.

| Chức năng | Chi tiết |
|---|---|
| Xem profile của tôi | Avatar, tên, email, thông tin cơ bản, gate qua `RequiresLogin` — chưa login thì hiện prompt |
| Xem profile người khác | Cùng layout, hiển thị thông tin công khai |
| Follow / Unfollow | Kết bạn theo mô hình 1 chiều — user có thể theo dõi bạn khác |
| Danh sách followers / following | Xem ai đang follow tôi, tôi đang follow ai |
| Block user | Chặn người dùng để họ không thể chat, nhìn thấy story, xem profile |
| Đăng nhập / Đăng ký | Từ prompt "Chưa đăng nhập" hoặc route `.login` |

---

## ✨ Tính năng cross-cutting

- **Onboarding lần đầu**: 3-page swipe onboarding (Chào mừng → Lợi ích → Chúc vui vẻ) trước khi vào MainTabView
- **Theme system**: `AppTheme` (colors, fonts, gradients) apply toàn app qua `@Environment(\.appTheme)`
- **Global session**: `AppSession` (@Observable) giữ `currentUser` — bất kỳ view nào cần biết trạng thái login đều đọc từ đây
- **`.requiresLogin()` modifier**: Reusable helper — bất kỳ screen nào cần login đều `.requiresLogin(title:, message:)` là xong
- **Screen status protocol**: `ScreenStatus` (idle / loading / loaded / failed) + `ScreenStatusRepresenting` cho VM extend riêng
- **Router centralized**: `AppRouter` (@Observable) quản lý `NavigationPath` + sheets + fullscreen covers. Type-safe qua `AppRoute` enum
- **DI qua Swinject**: ViewModel resolve với argument runtime (`chatId`, `authorId`, …) — không cần callback / factory manual

---

## 🧭 User flows điển hình

### Flow 1 — Tìm quán để hangout tối nay

```
Mở app → Map tab
  → Tap "vị trí của tôi" → camera recentre, load nearby places
  → Tap marker → SelectedPlaceCard hiện
  → Tap "Details" → xem ảnh, review, rating
  → Đã ưng → tap "Directions" → NavigationGuide dẫn đường
```

### Flow 2 — Chia sẻ story mới

```
Chat tab
  → Tap avatar "Tin của bạn" (có icon +)
  → Chọn ảnh/video hoặc tạo text với gradient
  → (Optional) chọn nhạc nền
  → Post → Story xuất hiện trong tray của bạn bè
```

### Flow 3 — Chat với bạn

```
Chat tab
  → Tap 1 chat trong list → ChatView
  → Nhập tin nhắn → gửi
  → Nhận reply realtime qua WebSocket
  → Back → về Chat tab (path clear đúng)
```

### Flow 4 — Thêm địa điểm mới

```
Map tab (đang ở địa điểm mới)
  → Nút "+ Add Place" (roadmap)
  → Form: tên, loại, mô tả, ảnh
  → Save → geo-anchored tại vị trí hiện tại
  → Xuất hiện cho user khác trong bán kính
```

### Flow 5 — Block user quấy rối

```
Profile của user → tap "…" → Block
  → User đó không thể: chat, xem story của bạn, xem profile bạn
```

---

## 🧱 Tech stack tóm tắt

| Layer | Tech |
|---|---|
| UI | SwiftUI (iOS 17+), NavigationStack, TabView `.page` |
| State | `@Observable` (Observation framework), `@State`, `@Environment` |
| Media | AVKit (`VideoPlayer`), AVFoundation (`AVAudioPlayer`, `AVAudioSession`) |
| Map | MapLibre Native + MapVina tiles / directions |
| Networking | Alamofire + custom `APIRouter` (URLRequestConvertible) |
| Realtime | URLSessionWebSocketTask (`RealtimeMessagingClient`) |
| Storage | Keychain (tokens), UserDefaults (`hasSeenOnboarding`) |
| DI | Swinject với argument-based resolve |
| Image loading | AsyncImage + custom `AppImage` component |
| Skeleton loading | SkeletonUI package |
| Architecture | Clean Architecture (Domain / Data / Presentation), MVVM ở tầng Presentation, **không có UseCase layer** — VM đọc thẳng Repository |

---

## 📌 Trạng thái hiện tại (dev)

- ✅ Map tab với places, comments, directions
- ✅ Chat list + chat 1-1 với mock data
- ✅ Story viewer đầy đủ (text/image/video/audio, PageView giữa users)
- ✅ Onboarding + auth screens (login/register có UI)
- ✅ Global `AppSession` + `.requiresLogin()` gating
- 🚧 Backend integration (thay mock → real API) đang tiến hành
- 🚧 Add place / add story flow chưa có UI
- 🚧 Follow / block user chưa có UI
- 🚧 Push notification (APNs) chưa integrate
