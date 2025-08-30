/// Supported unit categories.
enum Category { length, weight, temperature }

/// Simple unit model.
class Unit {
  final String name; // e.g., "meters"
  final String symbol; // e.g., "m"
  final Category category;

  const Unit(this.name, this.symbol, this.category);
}

/// Master unit list (you can extend this later).
const units = <Unit>[
  // Length
  Unit('meters', 'm', Category.length),
  Unit('kilometers', 'km', Category.length),
  Unit('feet', 'ft', Category.length),
  Unit('miles', 'mi', Category.length),

  // Weight
  Unit('kilograms', 'kg', Category.weight),
  Unit('pounds', 'lb', Category.weight),

  // Temperature
  Unit('celsius', '°C', Category.temperature),
  Unit('fahrenheit', '°F', Category.temperature),
];

/// Helper to filter units by category.
List<Unit> unitsOf(Category c) => units.where((u) => u.category == c).toList();
