import 'unit.dart';

/// Contract for converters: keeps the UI decoupled from the math.
abstract class Converter {
  double convert({required double value, required Unit from, required Unit to});
}
