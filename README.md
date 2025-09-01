# Measures Converter

This is a Flutter application I created as part of **MSCS 533**.  
The app allows users to convert values between **metric** and **imperial** units.  
It supports three categories of conversions:

- **Length** (meters, kilometers, feet, miles)  
- **Weight** (kilograms, pounds)  
- **Temperature** (Celsius, Fahrenheit)  

---

## Features
- iOS-first design using **Cupertino widgets** for a native iOS look.  
- Dropdowns to select “From” and “To” units.  
- Circular swap button with haptic feedback.  
- Primary **Convert** button that is disabled until a valid number is entered.  
- Results displayed in a card with a checkmark and a copy-to-clipboard option.  
- Accessibility: tap targets are ≥ 44x44, good text contrast, and supports dynamic text sizes.  
- Includes a simple **widget test** to check that the app loads with the right UI.  

---

## Project Structure
The project is organized using a **feature-based folder structure**:

```
lib/
 ├─ app.dart              # Root app widget
 ├─ main.dart
 ├─ core/                 # Shared theme/tokens
 └─ features/
     ├─ converter_page.dart
     ├─ result_card.dart
     ├─ swap_button.dart
     ├─ unit.dart
     ├─ unit_dropdown.dart
     ├─ converter.dart
     └─ converter_impl.dart
```

---

## How to Run
1. Make sure you have Flutter installed and set up for iOS development.  
2. Clone this repository:  
   ```bash
   git clone https://github.com/PRATMG/mscs533-measures-converter.git
   cd mscs533-measures-converter
   ```
3. Install dependencies:  
   ```bash
   flutter pub get
   ```
4. Run the app on an iOS simulator:  
   ```bash
   flutter run -d ios
   ```

---

## Tests
To run the widget test:

```bash
flutter test
```

---

## Notes
This app was built for learning purposes and demonstrates:
- Flutter state management with a `StatefulWidget`.
- Separation of UI into smaller reusable widgets.
- Basic unit conversion logic in Dart.
- Following lint rules (`flutter_lints`) and code comments for readability.

---

## Repository
GitHub link to the project:  
[https://github.com/PRATMG/mscs533-measures-converter](https://github.com/PRATMG/mscs533-measures-converter)
