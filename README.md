# 生活追踪 LifeTracker

生活追踪（LifeTracker）是一款用 Flutter 开发的多平台健康生活记录应用，支持记录饮食、喝水、放屁、拉屎、尿尿等日常事件，并通过 Firebase 云端存储和 AI 提供健康分析。支持多语言（含中文）。

LifeTracker is a cross-platform health tracking app built with Flutter. It helps users log daily events (meals, drinks, farts, poops, pees), stores data in Firebase, and provides AI-powered health insights. Multi-language supported (including Chinese).

## 主要功能 Features
- 用户认证（邮箱/Google 登录）
- 记录饮食、喝水、放屁、拉屎、尿尿等事件
- 历史记录浏览、筛选与删除
- 数据可视化（fl_chart 图表，色盲友好）
- AI 健康分析与建议（GPT 驱动）
- 多平台支持：Android、iOS、Web、Windows、macOS、Linux
- 多语言支持（中/英/日/韩/法/德/西/荷）

## 安装与运行 Getting Started
1. 克隆仓库 Clone the repo:
   ```bash
   git clone <repo-url>
   cd gas_track
   ```
2. 安装依赖 Install dependencies:
   ```bash
   flutter pub get
   ```
3. 配置 Firebase（需在 Firebase 控制台创建项目，下载配置文件，参考 `firebase_options.dart`）
   Set up Firebase (create project, download config files, see `firebase_options.dart`)
4. 运行 Run the app:
   ```bash
   flutter run
   ```

## 主要依赖 Main Dependencies
- [Flutter](https://flutter.dev/)
- [Firebase Core, Auth, Firestore](https://firebase.flutter.dev/)
- [fl_chart](https://pub.dev/packages/fl_chart)
- [intl](https://pub.dev/packages/intl)
- [google_sign_in](https://pub.dev/packages/google_sign_in)
- [provider](https://pub.dev/packages/provider)

## 目录结构 Project Structure
- `lib/main.dart` — 应用入口、认证与导航 App entry, auth, navigation
- `lib/advanced_event_chart_page.dart` — 数据可视化 Data visualization
- `lib/event_history_page.dart` — 历史记录 History management
- `lib/event_insight_page.dart` — AI 健康分析 AI insights
- `lib/l10n/` — 多语言本地化 Localization

## 贡献 Contributing
欢迎 PR，重大更改请先提 issue 讨论。
Pull requests are welcome! For major changes, please open an issue first.

## 许可证 License
[MIT](LICENSE)
