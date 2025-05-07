# Peer Connects

A walking application for community members to connect and track their walks.

## Overview

Peer Connects is a Flutter mobile application that helps users find walking buddies in their neighborhood, track their walks, and participate in community walking events. The app features a clean, modern UI with both light and dark themes.

## Features

- **User Authentication**: Secure login and registration with Firebase Authentication
- **Profile Management**: Create and update user profiles
- **Walk Tracking**: Record routes, distance, and time of walks
- **Community Connection**: Find walking buddies in your neighborhood
- **Walking Events**: Join and participate in community walking events
- **Walk History**: View past walks and statistics

## Technical Stack

- **Frontend**: Flutter with Material Design 3
- **State Management**: BLoC pattern with flutter_bloc
- **Backend**: Firebase (Authentication, Firestore, Cloud Functions)
- **Maps & Location**: Google Maps API, Geolocator
- **Local Storage**: Shared Preferences, Path Provider

## Architecture

The application follows a clean architecture approach with the following layers:

- **Presentation**: UI components, screens, and BLoC state management
- **Domain**: Business logic and use cases
- **Data**: Repositories and data sources (Firebase, local storage)

## Theme

The app uses a customized Material Design theme with:

- Dynamic color schemes for both light and dark modes
- Consistent typography and spacing
- Accessible color contrasts
- Custom button styles and input decorations

### Color Scheme

The app uses a green-based color palette:
- Primary: `#4CAF50`
- Secondary: `#2E7D32`
- Accent: `#8BC34A`

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Firebase account
- Android Studio / VS Code with Flutter plugins

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/peer_connects.git
   ```

2. Install dependencies:
   ```
   flutter pub get
   ```

3. Configure Firebase:
   - Create a new Firebase project
   - Add Android and iOS apps to your Firebase project
   - Download and add the configuration files
   - Enable Authentication and Firestore

4. Run the app:
   ```
   flutter run
   ```

## Project Structure

```
lib/
├── config/
│   └── theme.dart
├── features/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── walks/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── profile/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── community/
│       ├── data/
│       ├── domain/
│       └── presentation/
├── services/
└── main.dart
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.