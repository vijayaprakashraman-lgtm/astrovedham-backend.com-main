# Implementation Plan - Firebase Authentication & Google Sign-In

This plan outlines the steps to integrate real Firebase Authentication with Google Sign-In into the AstroVedham project.

## User Flow
1. **Splash**: Checks Firebase auth state.
2. **Authenticated**: Navigates to **Home**.
3. **Unauthenticated**: Navigates to **Login Screen**.
4. **Login**: User clicks "Continue with Google".
5. **Google Auth**: Real Google/Firebase sign-in process.
6. **Post-Login**: Redirection to **Home**; profile data synced.

## User Review Required
> [!IMPORTANT]
> To test real authentication, you **MUST** complete these steps in the Firebase Console:
> 1. Create a Firebase project.
> 2. Add an Android app with package name `com.example.astrovedham`.
> 3. Download `google-services.json` and place it in `android/app/`.
> 4. Enable **Google Sign-In** in Firebase Console -> Authentication -> Sign-in method.
> 5. **Crucial**: Add your **SHA-1** and **SHA-256** fingerprints to the Firebase Android app configuration. You can get these by running `./gradlew signingReport` in the `android` folder.

## Proposed Changes

### [Core/Dependencies]
- [MODIFY] [pubspec.yaml](file:///D:/Flutter_SDK/astrovedham/pubspec.yaml)
    - Add `firebase_core`, `firebase_auth`, and `google_sign_in`.

### [Core/Authentication]
- [NEW] [auth_service.dart](file:///D:/Flutter_SDK/astrovedham/lib/core/services/auth_service.dart)
    - Singleton handling `FirebaseAuth` and `GoogleSignIn` logic.
- [NEW] [auth_provider.dart](file:///D:/Flutter_SDK/astrovedham/lib/core/providers/auth_provider.dart)
    - `ChangeNotifier` to manage user state and expose `authStateChanges()`.

### [Features/Auth]
- [NEW] [login_screen.dart](file:///D:/Flutter_SDK/astrovedham/lib/features/auth/presentation/screens/login_screen.dart)
    - Branded UI with "Continue with Google" button.

### [Main/Lifecycle]
- [MODIFY] [main.dart](file:///D:/Flutter_SDK/astrovedham/lib/main.dart)
    - Initialize Firebase.
    - Add `AuthProvider` to `MultiProvider`.
- [MODIFY] [splash_screen.dart](file:///D:/Flutter_SDK/astrovedham/lib/features/onboarding/presentation/screens/splash_screen.dart)
    - Navigate based on `AuthProvider` state.
- [MODIFY] [app_routes.dart](file:///D:/Flutter_SDK/astrovedham/lib/core/routes/app_routes.dart)
    - Add `/login` route.

### [Profile/Forms]
- [MODIFY] [profile_screen.dart](file:///D:/Flutter_SDK/astrovedham/lib/features/profile/presentation/screens/profile_screen.dart)
    - Sync with Firebase User (Photo, Name, Email).
    - Update Logout to call Firebase Sign Out.
- [MODIFY] [horoscope_input_screen.dart](file:///D:/Flutter_SDK/astrovedham/lib/features/horoscope/presentation/screens/horoscope_input_screen.dart)
    - Pre-fill name/email from authenticated user.

### [Localization]
- [MODIFY] [en.json](file:///D:/Flutter_SDK/astrovedham/assets/translations/en.json) & [ta.json](file:///D:/Flutter_SDK/astrovedham/assets/translations/ta.json)
    - Add `auth.*` keys.

## Verification Plan
### Automated Tests
- `flutter pub get`
- `flutter analyze`

### Manual Verification
1. Open app -> Splash -> Verify redirection to Login (first run).
2. Click Google Sign-In -> Verify Firebase sign-in flow.
3. Verify Home screen appears after login.
4. Go to Profile -> Verify correct name/email/photo.
5. Log out -> Verify redirection to Login.
6. Check persistence: Close app, reopen -> Verify user remains logged in (Splash -> Home).
