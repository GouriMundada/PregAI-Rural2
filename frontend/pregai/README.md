# PregAI — Maternal Care Assistant (Frontend UI Only)

A Flutter/Dart, Material 3 frontend for **PregAI**, a maternal healthcare
concept app. This project contains **UI only** — no backend, database,
authentication, cloud services, or ML model. All data is static/dummy,
defined in `lib/data/dummy_data.dart`, so the UI can be wired up to a real
backend later without any redesign.

## Getting started

1. Install the [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable channel).
2. From the project root:
   ```bash
   flutter pub get
   flutter run
   ```
3. Designed primarily for a **Pixel 7** emulator, but responsive across
   Android screen sizes.

## Project structure

```
lib/
├── main.dart                     # App entry point, theme, named routes
├── theme/
│   └── app_theme.dart            # Colors, spacing, ThemeData (red/pink/white)
├── models/
│   └── patient.dart              # Patient + RiskLevel data model
├── data/
│   └── dummy_data.dart           # Static/dummy data used across screens
├── widgets/                      # Reusable UI building blocks
│   ├── app_button.dart
│   ├── app_text_field.dart
│   ├── action_card.dart
│   ├── patient_card.dart         # includes RiskBadge
│   ├── section_header.dart
│   └── bottom_navigation.dart
└── screens/
    ├── splash_screen.dart
    ├── home_screen.dart
    ├── patient_registration_screen.dart
    ├── anc_entry_screen.dart
    ├── patient_records_screen.dart
    ├── patient_details_screen.dart
    ├── risk_assessment_screen.dart
    ├── risk_result_screen.dart
    ├── health_guidance_screen.dart
    ├── reports_screen.dart
    ├── sync_screen.dart
    └── settings_screen.dart
```

## Navigation

- The five bottom-navigation tabs (**Home, Patients, Risk, Guidance,
  Settings**) are named routes (`/home`, `/patient-records`,
  `/risk-assessment`, `/health-guidance`, `/settings`) and switch via
  `pushReplacementNamed`, so the tab bar stays persistent and the back
  stack doesn't pile up.
- Drill-down screens (Patient Registration, ANC Entry, Patient Details,
  Risk Result, Reports, Data Sync) are pushed with `MaterialPageRoute`
  so they get a normal back arrow and can take arguments (e.g. a
  selected `Patient`).

## Design system

- Palette: Primary `#E91E63`, Secondary `#FF4081`, Accent Red `#D81B60`,
  Light Pink `#FFF0F5`, Very Light Pink `#FFF7FA`, plus status colors
  (success/warning/danger). All defined once in `AppColors`
  (`lib/theme/app_theme.dart`) — never hard-coded per screen.
- 16–24px rounded corners, soft shadows, generous spacing, large touch
  targets — tuned for readability in a rural healthcare / low-connectivity
  context.

## Frontend-only by design

No Firebase, REST APIs, SQLite/Hive, ML models, or network calls are
implemented. "Save", "Sync", and "Analyze Risk" actions simulate their
real-world behavior (loading state → success feedback) purely on the
client, using `Future.delayed`. Every screen that would eventually need
live data reads from `DummyData` so a future backend integration is a
drop-in replacement.
