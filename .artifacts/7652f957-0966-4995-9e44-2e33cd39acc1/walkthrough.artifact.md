# Walkthrough - UI Layout Fix for Truncated Text

I have updated the UI components to handle longer translated text (especially in Tamil) and ensure that no horoscope names are truncated or hidden.

## Changes Made

### 1. Horoscope Service Card (Home Screen)
- **Title Visibility**: Increased `maxLines` to `2` for service names.
- **Badge Relocation**: Moved the "OFFER" badge from the title row to a `Stack` over the service image. This prevents the badge from pushing the title out of view and provides more horizontal space.

### 2. Order Card (My Orders Screen)
- **Multi-line Titles**: Allowed the service name to wrap to 2 lines instead of being truncated.
- **Localization**: Localized the "Amount" label which was previously hard-coded in English.

### 3. Review Details Screen
- **Header Alignment**: Verified that service headers use `Expanded` layouts to naturally wrap long titles during the checkout flow.

### 4. Zodiac Card
- **Translation Cleanup**: Fixed a redundant UI element where the Tamil name was shown twice when the app was already set to Tamil. Now, the secondary name only shows if the primary name is in English.

## Verification

- **Static Analysis**: Ran `flutter analyze` and confirmed no layout or logic errors were introduced.
- **Visual Logic**:
    - **English**: Shows "Aries / மேஷம்".
    - **Tamil**: Shows only "மேஷம்" (cleaner look).
    - **Long Titles**: "Super Life Horoscope" now wraps correctly to a second line if needed.
