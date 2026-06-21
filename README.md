# wayz_ios

> **Stack**: SwiftUI · Clean Architecture + MVVM · Alamofire · Swinject · NavigationStack  
> **Platform**: iOS 17+ · Swift 5.9+ · Xcode 15+

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [First-Time Setup](#first-time-setup)
   - [Step 1 — Add SPM Packages in Xcode](#step-1--add-spm-packages-in-xcode)
   - [Step 2 — Add Source Files to the Target](#step-2--add-source-files-to-the-target)
   - [Step 3 — Resolve & Build](#step-3--resolve--build)
3. [Running the App](#running-the-app)
4. [Project Structure](#project-structure)
5. [Architecture Quick Reference](#architecture-quick-reference)
6. [Adding a New Feature](#adding-a-new-feature)
7. [Environment Configuration](#environment-configuration)
8. [Naming Conventions](#naming-conventions)
9. [Recommended Swift Packages](#recommended-swift-packages)
10. [Package Discovery Websites](#package-discovery-websites)

---

## Prerequisites

Install the required tools via [Homebrew](https://brew.sh):

```bash
# Install Xcode Command Line Tools (if not already installed)
xcode-select --install

# Optional: install xcbeautify for nicer build output
brew install xcbeautify

# Optional: install SwiftLint
brew install swiftlint
```

> **Note**: Alamofire and Swinject are managed by **Swift Package Manager (SPM)** built into Xcode — no Homebrew or CocoaPods needed.

---

## First-Time Setup

### Step 1 — Add SPM Packages in Xcode

> ⚠️ This is a one-time, manual step. Xcode's SPM integration does not have a CLI equivalent for `.xcodeproj` projects.

1. Open **`wayz_ios.xcodeproj`** in Xcode.
2. Go to **File → Add Package Dependencies…**
3. Add each package below by pasting the URL into the search bar and clicking **Add Package**:

| # | Package | Repository URL | Version Rule | Product to Link | Purpose |
|---|---|---|---|---|---|
| 1 | **Alamofire** | `https://github.com/Alamofire/Alamofire.git` | Up to Next Major: `5.9.0` | `Alamofire` | HTTP networking — wraps URLSession with request/response pipeline, interceptors, and JSON decoding |
| 2 | **Swinject** | `https://github.com/Swinject/Swinject.git` | Up to Next Major: `2.8.0` | `Swinject` | Dependency Injection container — registers and resolves services across all layers |

4. When prompted, in the **"Add to Target"** column make sure both products are checked for the **`wayz_ios`** target (not the test targets unless needed).

> **Tip — how to add a package step-by-step:**
> 1. Copy the repository URL from the table above.
> 2. In Xcode: **File → Add Package Dependencies…** → paste the URL → press **Return**.
> 3. Set the **Dependency Rule** to the version rule shown in the table.
> 4. Click **Add Package**, then on the next screen tick the product name shown in the "Product to Link" column and click **Add Package** again.

---

### Step 2 — Add Source Files to the Target

The new source folders (`App/`, `Core/`, `Domain/`, `Data/`, `Presentation/`) exist on disk but need to be registered in Xcode:

1. In Xcode's Project Navigator, right-click the **`wayz_ios`** group (the blue folder).
2. Choose **Add Files to "wayz_ios"…**
3. Navigate into the `wayz_ios/` source directory.
4. Select all new folders:
   - `App/`
   - `Core/`
   - `Domain/`
   - `Data/`
   - `Presentation/`
5. Make sure these options are checked:
   - ✅ **Create groups** (not folder references)
   - ✅ **Add to target: wayz_ios**
6. Click **Add**.

---

### Step 3 — Resolve & Build

After steps 1–2, run these commands to verify everything resolves:

```bash
# Navigate to the project root
cd /Users/macbook/Development/Projects/Personal/wayz_ios/wayz_ios

# Resolve all package dependencies (requires packages declared in Xcode first)
xcodebuild -resolvePackageDependencies \
  -project wayz_ios.xcodeproj \
  -scheme wayz_ios

# Optional: build for the simulator to verify no compile errors
xcodebuild build \
  -project wayz_ios.xcodeproj \
  -scheme wayz_ios \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  | xcbeautify        # remove '| xcbeautify' if not installed
```

> If the build succeeds with no errors, setup is complete. ✅

---

## Running the App

Open the project in Xcode and press **⌘R**, or use the CLI:

```bash
# Run on a specific simulator
xcodebuild \
  -project wayz_ios.xcodeproj \
  -scheme wayz_ios \
  -destination 'platform=iOS Simulator,name=iPhone 15,OS=latest' \
  build-for-testing
```

---

## Project Structure

```
wayz_ios/
├── App/
│   ├── wayz_iosApp.swift          # @main — bootstraps DI + Router
│   ├── AppAssembler.swift         # Root Swinject assembler
│   ├── AppNavigationStack.swift   # Root NavigationStack + route destinations
│   └── AppEnvironment.swift       # Base URL per build scheme
│
├── Core/
│   ├── DI/
│   │   ├── DIContainer.swift      # Global container accessor
│   │   └── Assemblers/
│   │       ├── NetworkAssembler.swift
│   │       ├── RepositoryAssembler.swift
│   │       └── UseCaseAssembler.swift
│   ├── Network/
│   │   ├── APIClient.swift        # Alamofire session wrapper
│   │   ├── APIRouter.swift        # All API endpoints (URLRequestConvertible)
│   │   ├── RequestInterceptor.swift  # Token inject + 401 refresh
│   │   └── NetworkError.swift     # Typed error enum
│   ├── Router/
│   │   ├── AppRoute.swift         # All screen destinations
│   │   └── AppRouter.swift        # NavigationPath manager
│   ├── Services/
│   │   └── KeychainService.swift  # Access/refresh token storage
│   └── Extensions/
│       ├── View+Extensions.swift
│       └── Publisher+Extensions.swift
│
├── Domain/                        # ⚠️ No framework imports allowed here
│   ├── Entities/
│   │   ├── User.swift
│   │   └── AuthToken.swift
│   ├── Repositories/
│   │   └── UserRepositoryProtocol.swift
│   └── UseCases/
│       ├── GetUserUseCase.swift
│       └── LoginUseCase.swift
│
├── Data/
│   ├── DTOs/
│   │   ├── UserDTO.swift
│   │   └── TokenDTO.swift
│   ├── Mappers/
│   │   └── UserMapper.swift       # DTO → Entity (pure functions)
│   ├── DataSources/
│   │   ├── Remote/UserRemoteDataSource.swift
│   │   └── Local/UserLocalDataSource.swift
│   └── Repositories/
│       └── UserRepository.swift   # Implements UserRepositoryProtocol
│
└── Presentation/
    ├── Scenes/
    │   ├── Home/      (HomeView + HomeViewModel)
    │   ├── Auth/      (LoginView + LoginViewModel)
    │   └── Profile/   (ProfileView + ProfileViewModel)
    └── Components/
        ├── LoadingView.swift
        └── ErrorView.swift
```

---

## Architecture Quick Reference

```
SwiftUI View
    │  reads state from / calls intents on
    ▼
ViewModel (@Observable)
    │  calls
    ▼
UseCase (Domain)
    │  calls
    ▼
RepositoryProtocol (Domain)   ←── implemented by ──►  Repository (Data)
                                                            │  calls
                                                            ▼
                                                    RemoteDataSource
                                                            │  via
                                                            ▼
                                                       APIClient (Alamofire)
```

**Dependency Rule**: outer layers depend on inner layers. The Domain layer must never import SwiftUI, Alamofire, or Swinject.

---

## Adding a New Feature

Use this checklist for every new screen/domain (example: `Order`):

```
Domain
  [ ] Domain/Entities/Order.swift
  [ ] Domain/Repositories/OrderRepositoryProtocol.swift
  [ ] Domain/UseCases/GetOrdersUseCase.swift

Data
  [ ] Data/DTOs/OrderDTO.swift
  [ ] Data/Mappers/OrderMapper.swift
  [ ] Data/DataSources/Remote/OrderRemoteDataSource.swift
  [ ] Data/Repositories/OrderRepository.swift

Core — wire it up
  [ ] Core/Network/APIRouter.swift          → add .getOrders, .createOrder cases
  [ ] Core/Router/AppRoute.swift            → add .orders case
  [ ] Core/DI/Assemblers/RepositoryAssembler.swift  → register OrderRepository
  [ ] Core/DI/Assemblers/UseCaseAssembler.swift     → register GetOrdersUseCase + OrdersViewModel

Presentation
  [ ] Presentation/Scenes/Orders/OrdersViewModel.swift
  [ ] Presentation/Scenes/Orders/OrdersView.swift
  [ ] App/AppNavigationStack.swift          → add .orders destination
```

---

## Environment Configuration

Base URLs are driven by **Swift Active Compilation Conditions** (no `.env` files needed):

| Scheme | Flag | URL used |
|---|---|---|
| Debug | *(none)* | `https://dev-api.wayz.com/v1` |
| Staging | `-D STAGING` | `https://staging-api.wayz.com/v1` |
| Release | *(none / not DEBUG)* | `https://api.wayz.com/v1` |

To add the `STAGING` flag:  
**Xcode → Project → Build Settings → Swift Compiler - Custom Flags → Active Compilation Conditions** → add `STAGING` for the Staging scheme.

---

## Naming Conventions

| Type | Convention | Example |
|---|---|---|
| View | `<Name>View` | `ProfileView` |
| ViewModel | `<Name>ViewModel` | `ProfileViewModel` |
| Use Case | `<Verb><Noun>UseCase` | `GetUserUseCase` |
| Repository Protocol | `<Name>RepositoryProtocol` | `UserRepositoryProtocol` |
| Repository Impl | `<Name>Repository` | `UserRepository` |
| DTO | `<Name>DTO` | `UserDTO` |
| Mapper | `<Name>Mapper` | `UserMapper` |
| Assembler | `<Name>Assembler` | `RepositoryAssembler` |
| Route case | camelCase | `.profile(userId:)` |
| API Router case | camelCase verb+noun | `.getUser(id:)` |

---

## Recommended Swift Packages

Danh sách các package chất lượng cao, được cộng đồng iOS kiểm chứng, phân theo mục đích sử dụng. Tất cả đều hỗ trợ **Swift Package Manager (SPM)**.

### 🎨 UI Components & Extensions

| Package | GitHub URL | Version | Mô tả |
|---|---|---|---|
| **SwiftUIX** | `https://github.com/SwiftUIX/SwiftUIX.git` | Latest | Bộ mở rộng SwiftUI — cung cấp các component mà Apple chưa có (alerts, context menus, pickers nâng cao…) |
| **SwiftUI-Introspect** | `https://github.com/siteline/SwiftUI-Introspect.git` | `≥ 1.1.0` | Truy cập UIKit/AppKit object ẩn dưới SwiftUI để tuỳ chỉnh sâu (UIScrollView, UITextField…) |
| **SkeletonUI** | `https://github.com/CSolanaM/SkeletonUI.git` | Latest | Skeleton loading placeholder — cải thiện UX khi đang tải dữ liệu |
| **Popovers** | `https://github.com/aheze/Popovers.git` | Latest | Popover, tooltip, bubble nhìn cực đẹp và dễ dùng trong SwiftUI |

### 🎬 Animations & Transitions

| Package | GitHub URL | Version | Mô tả |
|---|---|---|---|
| **Lottie** | `https://github.com/airbnb/lottie-ios.git` | `≥ 4.4.0` | Render animation JSON (After Effects) cực mượt — dùng cho onboarding, loading, empty state |
| **Pow** | `https://github.com/movingparts/Pow.git` | Latest | Physics-based transitions & magic effects đẹp — built-in cho SwiftUI |
| **ConfettiSwiftUI** | `https://github.com/simibac/ConfettiSwiftUI.git` | Latest | Hiệu ứng confetti cho màn hình celebration/reward |

### 🌐 Networking & Image

| Package | GitHub URL | Version | Mô tả |
|---|---|---|---|
| **Alamofire** ✅ | `https://github.com/Alamofire/Alamofire.git` | `≥ 5.9.0` | HTTP client mạnh — interceptors, retry, JSON decoding *(đã cài trong dự án)* |
| **Kingfisher** | `https://github.com/onevcat/Kingfisher.git` | `≥ 7.0.0` | Tải & cache ảnh từ URL bất đồng bộ — hỗ trợ SwiftUI `.setImage()` modifier |
| **Nuke** | `https://github.com/kean/Nuke.git` | `≥ 12.0.0` | Image loading pipeline hiệu năng cao — thay thế Kingfisher nếu cần xử lý custom pipeline |

### 🔐 Storage & Security

| Package | GitHub URL | Version | Mô tả |
|---|---|---|---|
| **KeychainSwift** | `https://github.com/evgenyneu/keychain-swift.git` | `≥ 21.0.0` | Lưu token/password vào Keychain với API đơn giản, type-safe |
| **Defaults** | `https://github.com/sindresorhus/Defaults.git` | `≥ 8.0.0` | `UserDefaults` wrapper type-safe — hỗ trợ `Codable`, `@Observable`, SwiftUI binding |

### 🏭 Dependency Injection & Factory

| Package | GitHub URL | Version | Mô tả |
|---|---|---|---|
| **Swinject** ✅ | `https://github.com/Swinject/Swinject.git` | `≥ 2.8.0` | DI container mạnh — đang dùng trong dự án |
| **Factory** | `https://github.com/hmlongco/Factory.git` | `≥ 2.3.0` | DI theo factory pattern — API hiện đại, zero-config, rất phù hợp SwiftUI/async |
| **Resolver** | `https://github.com/hmlongco/Resolver.git` | `≥ 1.5.0` | Lightweight DI bằng annotation — phù hợp project vừa và nhỏ |

### 🧪 Testing

| Package | GitHub URL | Version | Mô tả |
|---|---|---|---|
| **Quick + Nimble** | `https://github.com/Quick/Quick.git` + `https://github.com/Quick/Nimble.git` | Latest | BDD-style testing framework + assertion matchers đọc như văn xuôi |
| **ViewInspector** | `https://github.com/nalexn/ViewInspector.git` | `≥ 0.9.0` | Unit test SwiftUI View trực tiếp — inspect view hierarchy, trigger actions |

### 🪵 Logging & Debugging

| Package | GitHub URL | Version | Mô tả |
|---|---|---|---|
| **Pulse** | `https://github.com/kean/Pulse.git` | `≥ 4.0.0` | Inspect toàn bộ network request/response và logs ngay trên thiết bị thật |
| **CocoaLumberjack** | `https://github.com/CocoaLumberjack/CocoaLumberjack.git` | `≥ 3.8.0` | Logger hiệu năng cao — ghi log ra file, filter theo level |

### 🛠 Developer Tools (CLI / Build-time)

> Các tool dưới đây cài qua **Homebrew** hoặc **Mint**, không thêm vào SPM packages.

| Tool | Cài đặt | Mô tả |
|---|---|---|
| **SwiftLint** | `brew install swiftlint` | Bắt lỗi code style & anti-patterns ngay lúc build |
| **SwiftFormat** | `brew install swiftformat` | Tự động format code — hỗ trợ custom rules |
| **SwiftGen** | `brew install swiftgen` | Generate type-safe code cho Assets, Strings, Colors, Fonts |
| **Sourcery** | `brew install sourcery` | Metaprogramming — auto-generate boilerplate (Equatable, Mockable, DI…) |
| **Mint** | `brew install mint` | Lock version cho các CLI tool (SwiftLint, SwiftFormat…) theo team |

---

## Package Discovery Websites

> 💡 Tương đương [fluttergems.dev](https://fluttergems.dev) bên Flutter — dùng các trang này để tìm, so sánh, và đánh giá Swift packages trước khi thêm vào dự án.

| # | Website | URL | Mô tả |
|---|---|---|---|
| 1 | **Swift Package Index** ⭐ | https://swiftpackageindex.com | Trang tổng hợp chính thức — search theo tên, xem compatibility (iOS version, Swift version), doc, metrics. *Tương đương pub.dev bên Flutter* |
| 2 | **Swift LibHunt** | https://swift.libhunt.com | So sánh packages theo category (Networking, UI, Testing…), xem popularity rank và xu hướng |
| 3 | **Awesome iOS** (GitHub) | https://github.com/vsouza/awesome-ios | Danh sách curated cực lớn — phân loại rõ ràng, được cộng đồng duy trì thường xuyên |
| 4 | **Awesome Swift** (GitHub) | https://github.com/matteocrippa/awesome-swift | Tập trung vào Swift language packages — tools, utilities, server-side Swift |
| 5 | **iOS Cookies** | https://ioscookies.com | Bộ sưu tập các thư viện iOS đẹp — focus vào UI, animations, UX enhancements |
| 6 | **Cocoa Controls** | https://cocoacontrols.com | Gallery UI controls với demo trực quan — dễ tìm component theo visual |
| 7 | **Swift Toolbox** | https://www.swifttoolbox.io | Categorized Swift packages — filter theo platform, license, star count |

### Tiêu chí chọn package

Trước khi thêm bất kỳ package nào, hãy kiểm tra:

- ✅ **Stars & Activity**: Ít nhất 500 ⭐, commit trong vòng 6 tháng gần nhất
- ✅ **Swift version**: Compatible với Swift 5.9+ (iOS 17+)
- ✅ **SPM support**: Package có `Package.swift` ở root
- ✅ **License**: MIT hoặc Apache 2.0 (tránh GPL cho app thương mại)
- ✅ **Dependencies**: Tránh package kéo theo quá nhiều transitive dependencies
- ⚠️ **Native first**: Kiểm tra xem Apple đã có API native chưa trước khi dùng package (Swift Charts, Observation, TipKit…)
