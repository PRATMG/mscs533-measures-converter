import 'converter.dart';
import 'unit.dart';

/// Pure conversion implementation. Easy to unit-test.
class ConverterImpl implements Converter {
  const ConverterImpl();

  @override
  double convert({
    required double value,
    required Unit from,
    required Unit to,
  }) {
    if (from == to) return value;

    switch (from.category) {
      case Category.length:
        // Normalize to meters.
        final meters = switch (from.name) {
          'meters' => value,
          'kilometers' => value * 1000.0,
          'feet' => value * 0.3048,
          'miles' => value * 1609.344,
          _ => value,
        };
        // meters -> target.
        return switch (to.name) {
          'meters' => meters,
          'kilometers' => meters / 1000.0,
          'feet' => meters / 0.3048,
          'miles' => meters / 1609.344,
          _ => meters,
        };

      case Category.weight:
        // Normalize to kilograms.
        final kg = switch (from.name) {
          'kilograms' => value,
          'pounds' => value * 0.45359237,
          _ => value,
        };
        // kg -> target.
        return switch (to.name) {
          'kilograms' => kg,
          'pounds' => kg / 0.45359237,
          _ => kg,
        };

      case Category.temperature:
        // °C <-> °F.
        if (from.name == 'celsius' && to.name == 'fahrenheit') {
          return value * 9 / 5 + 32;
        }
        if (from.name == 'fahrenheit' && to.name == 'celsius') {
          return (value - 32) * 5 / 9;
        }
        return value;
    }
  }
}
