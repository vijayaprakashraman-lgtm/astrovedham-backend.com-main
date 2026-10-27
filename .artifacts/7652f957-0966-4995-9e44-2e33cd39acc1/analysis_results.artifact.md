# AstroVedham Localization Audit Report

## Phase 1 Findings

### Configuration Audit
- **easy_localization**: Correctly configured in `main.dart`.
- **Supported Locales**: English (`en`), Tamil (`ta`).
- **Fallback Locale**: English (`en`).
- **Translation Path**: `assets/translations`.
- **Hindi Localization**: Not found in configuration or assets.

### Translation Files Audit (`en.json` vs `ta.json`)
- **Missing Keys in Tamil**:
  - The entire `horoscope` section (Daily Horoscope, Zodiac signs) is missing in `ta.json`.
  - Several keys in `profile` and `common` might be missing or inconsistent.
- **Inconsistent Translations**:
  - `onboarding.tagline` differs significantly in meaning.
  - Service names in `ta.json` don't exactly match the user's requested natural Tamil terminology.
- **Placeholder Safety**: Placeholders like `{}` in `common.step` seem consistent.

### Hard-coded UI Text Audit
Found significant hard-coded strings in:
- `lib/core/routes/app_routes.dart` (Error routes)
- `lib/features/horoscope/presentation/screens/pdf_viewer_screen.dart` (Loading/Error states)
- `lib/features/horoscope/presentation/screens/review_details_screen.dart` (Success/Error messages, "Review Consultation")
- `lib/features/orders/presentation/screens/order_detail_screen.dart` (Amount, Dates, Download status)
- `lib/features/consultation/presentation/screens/consultation_form_screen.dart` (Validation messages)
- `lib/features/home/presentation/widgets/horoscope_service_card.dart` ("OFFER" badge)
- `lib/features/horoscope_generator/domain/entities/horoscope_service.dart` (One subtitle)

### Service & Consultation Audit
- **Horoscope Services**: Mostly localized but need term updates in Tamil.
- **Astrologer Consultation**: "Review Consultation" title is hard-coded. Subtitle in the model is hard-coded.
- **Muhurtham / Panchang**: UI labels need verification in the translation files (currently missing or incomplete).

### Tamil Quality Audit
- Needs update for "Life Horoscope", "Super Life Horoscope", "Gemstones Horoscope", etc., to match the requested natural Tamil.

## Categorized Issues

### CRITICAL
- Missing `horoscope` section in `ta.json` (prevents Tamil users from using daily horoscope).

### HIGH
- Hard-coded strings in PDF viewer and Order Success/Error flows.
- Hard-coded validation messages in forms.

### MEDIUM
- Inconsistent Tamil terminology for core services.
- Hard-coded "OFFER" badge.

### LOW
- Hard-coded error route message.
- Hard-coded fallback "User Name" in profile.
