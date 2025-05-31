# GasTrack

GasTrack is a playful and insightful Flutter app designed to help users track daily health-related activities, including meals, drinks, and digestive events (like farts, poops, and pees). The app leverages Firebase for authentication and data storage, and provides data visualization and AI-powered health insights.

## Features

- **User Authentication**: Sign in with email/password or Google account (via Firebase Auth).
- **Activity Logging**: Record events such as:
  - Fart (with sound and smell details)
  - Poop (with consistency)
  - Pee (with color)
  - Meal (with meal type)
  - Drink (water intake)
- **History View**: Browse, filter, and delete your past records.
- **Advanced Charts**: Visualize your activity data over time with customizable, colorblind-friendly charts.
- **AI Insights**: Get weekly summaries and health advice powered by GPT, based on your logged data.
- **Multi-Platform**: Runs on Android, iOS, Web, Windows, macOS, and Linux.

## Screenshots
<!-- Add screenshots here if available -->

## Getting Started

1. **Clone the repository:**
   ```bash
   git clone <repo-url>
   cd gas_track
   ```
2. **Install dependencies:**
   ```bash
   flutter pub get
   ```
3. **Set up Firebase:**
   - Create a Firebase project and add your app (Android/iOS/Web/etc.).
   - Download the configuration files and place them as required (see `firebase_options.dart`).
   - Enable Email/Password and Google authentication in Firebase Console.
4. **Run the app:**
   ```bash
   flutter run
   ```

## Main Dependencies
- [Flutter](https://flutter.dev/)
- [Firebase Core, Auth, Firestore](https://firebase.flutter.dev/)
- [fl_chart](https://pub.dev/packages/fl_chart)
- [intl](https://pub.dev/packages/intl)
- [google_sign_in](https://pub.dev/packages/google_sign_in)

## Project Structure
- `lib/main.dart` — App entry point, authentication, and navigation
- `lib/advanced_fart_chart_page.dart` — Advanced data visualization
- `lib/fart_history_page.dart` — History and record management
- `lib/fart_insight_page.dart` — AI-powered insights and summaries

## Contributing
Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

## License
[MIT](LICENSE)
