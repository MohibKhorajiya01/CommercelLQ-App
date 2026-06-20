<div align="center">

# 📚 CommerceLQ

### Offline-First E-Commerce Learning Platform — Built with Flutter

*A production-ready, offline-first mobile application that helps users explore structured business courses, follow step-by-step roadmaps, track learning progress, and bookmark important lessons — all without requiring an internet connection.*

<br/>

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Riverpod](https://img.shields.io/badge/Riverpod-1B1B1F?style=for-the-badge&logo=flutter&logoColor=white)
![SQLite](https://img.shields.io/badge/SQLite-07405E?style=for-the-badge&logo=sqlite&logoColor=white)
![GoRouter](https://img.shields.io/badge/GoRouter-4285F4?style=for-the-badge&logo=flutter&logoColor=white)

![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-blue?style=flat-square)
![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-orange?style=flat-square)
![Status](https://img.shields.io/badge/Status-Active-brightgreen?style=flat-square)

</div>

---

## 📖 Overview

**CommerceLQ** is a comprehensive e-commerce learning platform designed for learners who want structured, distraction-free access to business education — even without an internet connection. With a fully offline-first architecture, premium UI, and smooth animations, it delivers a native, app-store-quality learning experience.

---

## ✨ Key Features

- **📴 Offline-First Architecture** — Powered by SQLite, ensuring 100% functionality without network dependence.
- **🏗️ Clean Architecture** — Clear separation of concerns using Domain, Data, and Presentation layers.
- **⚡ Reactive State Management** — Implementation of Riverpod for robust, scalable state handling.
- **🧭 Advanced Navigation** — Type-safe routing using GoRouter with custom, smooth page transitions.
- **💾 Persistent Data** — Local storage for user progress, streak tracking, and bookmarks.
- **🎨 Dynamic UI/UX** — Premium, modern aesthetics with glassmorphism touches and fluid animations (using `flutter_animate`).

---

## 🛠️ Technology Stack

| Layer                    | Technology                                          |
|----------------------------|------------------------------------------------------|
| Framework                 | Flutter (Dart)                                      |
| State Management          | Riverpod (`flutter_riverpod`)                       |
| Local Database            | SQLite (`sqflite`, `path_provider`)                 |
| Routing                   | GoRouter                                            |
| Animations                | `flutter_animate`                                   |
| Native Integrations       | `share_plus`, `url_launcher`, `shared_preferences`  |

---

## 📂 Project Structure

```
lib/
├── core/                                # Application-wide shared configurations
│   ├── constants/                       # Colors, Strings, TextStyles
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   └── app_text_styles.dart
│   ├── database/                        # Local SQLite database logic
│   │   ├── database_helper.dart
│   │   └── database_seeder.dart
│   ├── router/                          # GoRouter navigation paths & transitions
│   │   └── app_router.dart
│   ├── theme/                           # Global UI theme mapping
│   │   └── app_theme.dart
│   └── widgets/                         # Reusable UI components
│       ├── bookmark_button.dart
│       ├── custom_badge.dart
│       ├── difficulty_dot.dart
│       └── progress_card.dart
│
├── features/                            # Feature-driven modules (Clean Architecture)
│   ├── bookmarks/
│   │   └── presentation/                # UI and Riverpod providers for bookmarks
│   ├── categories/
│   │   ├── domain/models/category.dart  # Data models
│   │   └── presentation/                # UI and providers
│   ├── course_detail/
│   │   ├── domain/models/course.dart
│   │   └── presentation/
│   ├── home/
│   │   └── presentation/
│   ├── lesson/
│   │   ├── domain/models/lesson.dart
│   │   └── presentation/
│   ├── profile/
│   │   └── presentation/
│   ├── search/
│   │   └── presentation/
│   └── splash/
│       └── presentation/
│           └── splash_screen.dart
│
└── main.dart                            # Application entry point
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (stable channel)
- Android Studio / Xcode

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/CommerceLQ.git
   cd CommerceLQ
   ```

2. **Fetch dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

---

## 📱 Screenshots

<p align="center">
  <img src="CommerceLQ Screenshots/SplashScreen.png" width="220" alt="Splash Screen">
  <img src="CommerceLQ Screenshots/HomePage.png" width="220" alt="Home Page">
  <img src="CommerceLQ Screenshots/SelectBusness.png" width="220" alt="Select Business">
  <img src="CommerceLQ Screenshots/busnessLesson1.png" width="220" alt="Roadmap">
</p>
<p align="center">
  <img src="CommerceLQ Screenshots/Learn1.png" width="220" alt="Learning Step 1">
  <img src="CommerceLQ Screenshots/Learn2.png" width="220" alt="Learning Step 2">
  <img src="CommerceLQ Screenshots/Search.png" width="220" alt="Search">
  <img src="CommerceLQ Screenshots/Bookmark.png" width="220" alt="Bookmarks">
</p>
<p align="center">
  <img src="CommerceLQ Screenshots/Profile.png" width="220" alt="Profile">
</p>

> 💡 **Note:** Screenshots are loaded from the `CommerceLQ Screenshots/` folder in this repository. Ensure the folder is committed at the repo root for images to render correctly on GitHub.

---

<div align="center">

### 💜 Built with passion using Flutter

**CommerceLQ** — *Learn business, anytime, anywhere — even offline.*

</div>
