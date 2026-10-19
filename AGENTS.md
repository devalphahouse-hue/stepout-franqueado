# Repository Guidelines

## Project Structure & Module Organization

This repository contains the Stepout franchise Flutter/FlutterFlow app. Screens live in `lib/pages/`, authentication in `lib/auth/`, and integrations in `lib/backend/`. Keep custom actions, widgets, and helpers in `lib/custom_code/`. Assets belong in `assets/`, tests in `test/`, and platform configuration in `android/`, `ios/`, and `web/`.

Shared Asaas functions, migrations, and server regression tests live in `supabase/`. These functions also serve stepout-aluno. Treat this repository as their canonical source.

## Build, Test, and Development Commands

Run commands at the repository root:

- `flutter pub get`: resolve dependencies.
- `flutter run -d chrome`: run the web application.
- `flutter analyze`: check source against `analysis_options.yaml`.
- `dart format <edited-files>`: format changed Dart files.
- `flutter test`: run relevant Flutter tests.
- `flutter build web --release`: compile the web application.
- `flutter test test/franchise_payment_plan_test.dart`: verify demo and real plan restoration.
- `cd supabase/tests && npm ci && npm test`: run payment regressions with isolated PostgreSQL and mocked Asaas.

Vercel pins Flutter 3.41.9 in `vercel.json`. Local payment validation used compatible Flutter 3.35.7; preserve dependency constraints and avoid unrelated SDK upgrades.

## Coding Style & Naming Conventions

Use two-space Dart indentation, `snake_case.dart` filenames, `UpperCamelCase` types, and `lowerCamelCase` members. Follow `flutter_lints`, existing widget/model patterns, and Portuguese domain terms. Avoid unrelated generated-code changes.

## Testing Guidelines

Tests use `flutter_test` and `_test.dart` filenames. No coverage threshold is configured. Cover restored installments, duplicate submissions, pending payments, and webhook retries. Distinguish mocked tests from real provider validation.

## Commit & Pull Request Guidelines

History uses short Portuguese descriptions and scoped `fix:`/`feat:` messages. Use concrete titles, such as `fix(pagamento): preserva parcelas da demo`. Describe affected flows, validation, migrations, and linked issues. Include screenshots for visible changes.

## Payment & Configuration Rules

Preserve prices, split percentages, and student validity rules. Keep reduced demo prices until client validation authorizes removal. Demo amounts can create real charges. Never persist passwords or commit private keys or webhook tokens. Publish compatible functions and migrations before dependent app changes.

Student deletion must call `delete-user`: remove Auth first, then finalize both soft-delete markers through `finalize_student_deletion`. Preserve history and allow retries; never report success after a failed Auth removal or database finalization.
