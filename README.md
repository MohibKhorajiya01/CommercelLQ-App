# CommerceLQ — Offline-First E-Commerce Learning Platform

**CommerceLQ** is a production-ready, offline-first mobile application built with Flutter. It serves as a comprehensive e-commerce learning platform designed to help users explore structured business courses, follow step-by-step roadmaps, track learning progress, and bookmark important lessons—all seamlessly without requiring an internet connection.

<div align="center">
  <img src="assets/images/app_icon.png" width="150" alt="CommerceLQ Logo">
</div>

## ✨ Key Features
- **Offline-First Architecture**: Powered by SQLite, ensuring 100% functionality without network dependence.
- **Clean Architecture**: Separation of concerns using Domain, Data, and Presentation layers.
- **Reactive State Management**: Implementation of Riverpod for robust, scalable state handling.
- **Advanced Navigation**: Type-safe routing using GoRouter with custom smooth page transitions.
- **Persistent Data**: Local storage for user progress, streak tracking, and bookmarks.
- **Dynamic UI/UX**: Premium, modern aesthetics with glassmorphism touches and fluid animations (using `flutter_animate`).

## 🛠️ Technology Stack
- **Framework**: Flutter (Dart)
- **State Management**: Riverpod (`flutter_riverpod`)
- **Local Database**: SQLite (`sqflite`, `path_provider`)
- **Routing**: GoRouter
- **Animations**: `flutter_animate`
- **Native Integrations**: `share_plus`, `url_launcher`, `shared_preferences`

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (stable channel)
- Android Studio / Xcode

### Installation
1. Clone the repository
```bash
git clone https://github.com/YOUR_USERNAME/CommerceLQ.git
```
2. Fetch dependencies
```bash
flutter pub get
```
3. Run the application
```bash
flutter run
```

## 📱 Screenshots
<p align="center">
  <img src="CommerceLQ%20Screenshots/SplashScreen.png" width="220" alt="Splash Screen">
  <img src="CommerceLQ%20Screenshots/HomePage.png" width="220" alt="Home Page">
  <img src="CommerceLQ%20Screenshots/SelectBusness.png" width="220" alt="Select Business">
  <img src="CommerceLQ%20Screenshots/busnessLesson1.png" width="220" alt="Roadmap">
</p>
<p align="center">
  <img src="CommerceLQ%20Screenshots/Learn1.png" width="220" alt="Learning Step 1">
  <img src="CommerceLQ%20Screenshots/Learn2.png" width="220" alt="Learning Step 2">
  <img src="CommerceLQ%20Screenshots/Search.png" width="220" alt="Search">
  <img src="CommerceLQ%20Screenshots/Bookmark.png" width="220" alt="Bookmarks">
</p>
<p align="center">
  <img src="CommerceLQ%20Screenshots/Profile.png" width="220" alt="Profile">
</p>

## 🤝 Contributing
Feel free to fork this project and submit pull requests. For major changes, please open an issue first to discuss what you would like to change.

## 📄 License
This project is open source and available under the [MIT License](LICENSE).
