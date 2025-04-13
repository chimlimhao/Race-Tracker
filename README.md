# Race Tracker

A Flutter application for tracking and managing race events with multiple segments, such as triathlons.

## Overview

Race Tracker allows race managers to:
- Create and manage races with multiple segments
- Track participant progress through each segment
- Record and view race results in real-time

## Features

- Race creation with customizable segments
- Participant management and registration
- Real-time race progress tracking
- Result compilation and viewing

## Setup Instructions

### Prerequisites

- Flutter SDK (version 3.0.0 or higher)
- Dart SDK (version 2.17.0 or higher)
- Android Studio / VS Code with Flutter extensions
- An emulator or physical device for testing

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/chimlimhao/Race-Tracker.git
   cd Race-Tracker
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Project Structure

```
lib/
  ├── data/               # Data layer (repositories, DTOs)
  ├── models/             # Domain models
  ├── ui/                 # UI components
  │   ├── providers/      # State management
  │   ├── screens/        # App screens
  │   ├── utils/          # UI utilities
  │   └── widgets/        # Reusable widgets
  └── main.dart           # Entry point
```

## Development Guidelines

### Branch Naming Convention
- Use `feature/RT-XXX-description` for feature branches
<!-- - Use `bugfix/RT-XXX-description` for bug fixes -->

### Commit Message Format
- Format: `RT-XXX: Description of the change`
- Example: `RT-001: Implemented Bottom Navigation Logic`

## Contribution

1. Create a new branch from main
2. Make your changes
3. Create a pull request to main
4. Wait for review and approval

## License

This project is licensed under the MIT License - see the LICENSE file for details.
