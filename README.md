# 🧠 Quiz Master

A Flutter-based quiz application with a clean UI, dark/light theme toggle, and smooth navigation.

## Features

- 🎯 Multiple-choice quiz questions
- 🌙 Dark / Light theme toggle (persisted via `shared_preferences`)
- 📊 Results screen with score summary
- 🗺️ Declarative routing with `go_router`

## Project Structure

```
lib/
├── controllers/   # Business logic & state (e.g. ThemeController)
├── data/          # Static quiz data
├── models/        # Data models
├── router/        # App routing (go_router)
├── services/      # Helper services
├── views/         # Screens (Home, Quiz, Result)
├── widgets/       # Reusable UI components
└── main.dart      # App entry point
```

## Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) ≥ 3.0.0

### Run the app

```bash
flutter pub get
flutter run
```

## Dependencies

| Package | Purpose |
|---|---|
| `go_router` | Declarative navigation |
| `shared_preferences` | Persist theme preference |
| `cupertino_icons` | iOS-style icons |

## License

This project is for educational purposes.
