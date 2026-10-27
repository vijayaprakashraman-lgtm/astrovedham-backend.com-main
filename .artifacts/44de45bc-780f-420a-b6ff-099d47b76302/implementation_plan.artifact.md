# Deep Celestial Rich Premium Theme Implementation Plan

Implement the **Deep Celestial + Royal Indigo + Metallic Gold + Multi-Color Service Identity** design across the entire AstroVedham Flutter application. This transformation aims to make the app feel Premium, Spiritual, and Professional while maintaining all existing functionality and localization.

## Proposed Changes

### Core Theme Architecture

#### [MODIFY] [app_colors.dart](file:///D:/Flutter_SDK/astrovedham/lib/core/theme/app_colors.dart)
- Refine the core palette:
    - **Primary Indigo**: Deepen the royal indigo shades.
    - **Metallic Gold**: Enhance the gold palette for premium highlights.
    - **Service Identity**: Review and refine the 10 service colors to ensure they are professionally selected and consistent with the celestial brand.
- Add semantic colors for elevated surfaces, borders, and gradients.
- Define specific color sets for Light and Dark themes.

#### [MODIFY] [app_theme.dart](file:///D:/Flutter_SDK/astrovedham/lib/core/theme/app_theme.dart)
- Implement comprehensive `ThemeData` for both Light and Dark modes.
- **CardTheme**: Use circular corners (24-32dp), subtle borders, and soft shadows.
- **ButtonThemes**: Update `ElevatedButton` and `OutlinedButton` with premium styling (gradients for primary buttons, refined borders for outlined).
- **InputDecorationTheme**: Modern, clean text fields with celestial-tinted backgrounds.
- **NavigationBarTheme**: Refined navigation with deep celestial colors and gold indicators.

#### [MODIFY] [app_text_theme.dart](file:///D:/Flutter_SDK/astrovedham/lib/core/theme/app_text_theme.dart)
- Refine typography hierarchy using premium fonts (e.g., Plus Jakarta Sans).
- Ensure high contrast and readability across both themes.

### Feature UI Enhancements

#### [MODIFY] [horoscope_service_card.dart](file:///D:/Flutter_SDK/astrovedham/lib/features/home/presentation/widgets/horoscope_service_card.dart)
- Redesign the card to use the service-specific identity more elegantly.
- Apply rich gradients, premium icon containers, and refined price/badge layouts.

#### [MODIFY] [home_screen.dart](file:///D:/Flutter_SDK/astrovedham/lib/features/home/presentation/screens/home_screen.dart)
- Update the Hero section with the new **Deep Celestial Gradient** and **Metallic Gold** highlights.
- Ensure the overall page flow feels premium and spacious.

#### [MODIFY] [service_info_screen.dart](file:///D:/Flutter_SDK/astrovedham/lib/features/horoscope/presentation/screens/service_info_screen.dart)
- Apply the service-specific theme to headers, buttons, and highlights.
- Ensure the transition from Home to Service Info feels seamless.

#### [MODIFY] [service_form_screen.dart](file:///D:/Flutter_SDK/astrovedham/lib/features/horoscope/presentation/screens/service_form_screen.dart)
- Refine form fields and step indicators to match the premium theme.

#### [MODIFY] [review_details_screen.dart](file:///D:/Flutter_SDK/astrovedham/lib/features/horoscope/presentation/screens/review_details_screen.dart)
- Elevate the review summary with clean cards and clear action buttons.

#### [MODIFY] [order_card.dart](file:///D:/Flutter_SDK/astrovedham/lib/features/orders/presentation/widgets/order_card.dart)
- Apply the celestial theme to order history cards.

### Validation Plan

- **Code Quality**:
    - Run `dart format .` to ensure consistent formatting.
    - Run `flutter analyze` to catch any UI-related errors or warnings.
- **Visual Verification**:
    - Verify Home, Horoscope, and all 10 service screens.
    - Check both Light and Dark theme implementations.
    - Verify responsive layout on different screen sizes.
- **Functional Integrity**:
    - Ensure all API calls (Railway, PDF, Horoscope) continue to work.
    - Confirm localization (`.tr()`) is preserved and not hardcoded.
