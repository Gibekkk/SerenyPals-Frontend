# SerenyPals-Frontend
---
Backend Repo:
https://github.com/Gibekkk/SerenyPals-Backend

ADR Repo:
https://github.com/Gibekkk/SerenyPals-ADR

---
<h1 align="center">SERENYPALS-FRONTEND</h1>
<p align="center"><em>Empowering Mental Wellness Through Beautiful Mobile Experiences</em></p>

<div align="center">
<img alt="last-commit" src="https://img.shields.io/github/last-commit/Gibekkk/SerenyPals-Frontend?style=flat&logo=git&logoColor=white&color=0080ff">
<img alt="repo-top-language" src="https://img.shields.io/github/languages/top/Gibekkk/SerenyPals-Frontend?style=flat&color=0080ff">
<img alt="repo-language-count" src="https://img.shields.io/github/languages/count/Gibekkk/SerenyPals-Frontend?style=flat&color=0080ff">
</div>

<p align="center"><em>Built with Flutter and integrated technologies:</em></p>
<div align="center">
<img alt="Flutter" src="https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white">
<img alt="Dart" src="https://img.shields.io/badge/Dart-0175C2?style=flat&logo=dart&logoColor=white">
<img alt="Firebase" src="https://img.shields.io/badge/Firebase-FFCA28?style=flat&logo=firebase&logoColor=black">
<img alt="Provider" src="https://img.shields.io/badge/Provider-4285F4?style=flat">
<img alt="Bloc" src="https://img.shields.io/badge/Bloc-5849BE?style=flat">
</div>

<br>
<hr>

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Running the App](#running-the-app)

<hr>

## Overview
SerenyPals-Frontend is a Flutter-based mobile application designed to provide a seamless mental wellness experience. Built with modern Flutter practices and architecture, it connects to the SerenyPals-Backend to deliver features like:

- Community forums for peer support
- Mental health journaling with mood tracking
- Therapist booking and video consultation
- Daily wellness tips and resources
- Secure authentication and user profiles

The application follows clean architecture principles and utilizes state management solutions like Provider or BLoC for maintainable and testable code.

<hr>

## Features
- 🧠 **Mental Wellness Tracking:** Mood diaries with analytics and insights
- 👥 **Community Support:** Forums and chat functionality
- 📅 **Appointment Management:** Therapist booking and scheduling
- 🔒 **Secure Authentication:** Firebase Auth integration
- 📱 **Responsive UI:** Beautiful and adaptive interfaces for all devices
- 🌐 **API Integration:** Seamless connection with SerenyPals-Backend
- 🔄 **State Management:** Efficient data flow with Provider/BLoC
- 🌓 **Dark/Light Mode:** User preference support

<hr>

## Getting Started

### Prerequisites
- **Flutter SDK:** [Install Flutter](https://flutter.dev/docs/get-started/install)
- **Dart:** Comes with Flutter installation
- **IDE:** Android Studio, VS Code, or IntelliJ IDEA
- **Android/iOS Emulator** or physical device

### Installation
1. **Clone the repository:**
   ```sh
   git clone https://github.com/Gibekkk/SerenyPals-Frontend
2. **Navigate to the project directory:**
   ```sh
   cd SerenyPals-Frontend
3. **Install dependencies:**
   ```sh
   flutter pub get
4. **Setup Firebase:**
   - Create a Firebase project
   - Add Android/iOS apps to Firebase console
   - Download configuration files:
     - google-services.json for Android
     - GoogleService-Info.plist for iOS
   - Place these files in the appropriate directories

## Running the App
1. Run in debug mode:
   ```sh
   flutter run
2. Build release versions:
   - Android:
     ```sh
     flutter build apk --release
   - iOS:
     ```sh
     flutter build ios --release
