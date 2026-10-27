# Implementation Plan - Total UI Color Theme Update

Migrate the entire application's color theme to the new "Sacred Emerald & Gold" palette provided.

## User Review Required

> [!IMPORTANT]
> - This change replaces the existing "Emerald & Gold" brand identity with the new palette.
> - **Primary Brand Color**: Shifted to a deeper Emerald (`#064E3B`).
> - **Accents**: Updated to Sacred Gold (`#D97706`) and Accent Gold (`#FFB300`).
> - **Surfaces**: Cards will use Jade Green (`#0F766E`) while backgrounds use Mint Cream (`#ECFDF5`).
> - **Dark Mode**: Will be updated to use the deep forest tones provided (`#022C22` background, `#064E3B` surfaces).

## Proposed Changes

### Core Theme

#### [MODIFY] [app_colors.dart](file:///D:/Flutter_SDK/astrovedham/lib/core/theme/app_colors.dart)
- Overhaul the `AppColors` class to include the new palette constants while maintaining compatibility with existing usages.
- **Mapping**:
  - `primaryEmerald` -> `#064E3B` (PrimaryGreen)
  - `deepEmerald` -> `#022C22` (DarkBackground)
  - `antiqueGold` -> `#D97706` (SacredGold)
  - `background` -> `#ECFDF5` (SheetBackground)
  - `surface` -> `#FFFFFF`
  - `surfaceElevated` -> `#D1FAE5` (LightBorder)
  - `textPrimary` -> `#022C22` (PrimaryText)
  - `textSecondary` -> `#047857` (SecondaryText)
  - `success` -> `#10B981` (SuccessGreen)
  - `error` -> `#DC2626` (AlertRed)
  - `jadeGreen` -> `#0F766E` (CardSurface)
- Add the specialized functional colors: `OrangeLight`, `OrangeDark`, `AccentGold`, `GreenAuspicious`, `RedInauspicious`, `BlueText`.

#### [MODIFY] [app_theme.dart](file:///D:/Flutter_SDK/astrovedham/lib/core/theme/app_theme.dart)
- Update `lightTheme` and `darkTheme` to use the new mapped colors.
- Ensure `scaffoldBackgroundColor` for light theme is `#ECFDF5`.
- Update `ColorScheme` to reflect the new primary and secondary accents.
- Update `NavigationDestination` and `ElevatedButton` themes.

#### [MODIFY] [app_text_theme.dart](file:///D:/Flutter_SDK/astrovedham/lib/core/theme/app_text_theme.dart)
- Ensure all text styles point to the updated `AppColors.textPrimary` and `AppColors.textSecondary`.

### Features - Horoscope

#### [MODIFY] [horoscope_service_card.dart](file:///D:/Flutter_SDK/astrovedham/lib/features/home/presentation/widgets/horoscope_service_card.dart)
- Ensure it uses the new `CardSurface` (`#0F766E`) correctly. (It already uses `AppColors.jadeGreen` which is being mapped to this value).

## Verification Plan

### Manual Verification
- Verify the Home screen, Service Info screens, and navigation bars use the new palette.
- Check the contrast of text (`#022C22`) against the new background (`#ECFDF5`).
- Confirm Dark Mode looks correct with the deep forest background (`#022C22`) and light mint text (`#ECFDF5`).
