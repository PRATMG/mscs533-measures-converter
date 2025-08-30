import 'package:flutter/material.dart';
import 'unit.dart';

/// iOS-friendly dropdown: Material dropdown inside a decorated container.
/// Wrapped with a local Material ancestor to satisfy DropdownButton requirements.
class UnitDropdown extends StatelessWidget {
  const UnitDropdown({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  final List<Unit> items;
  final Unit value;
  final ValueChanged<Unit?> onChanged;
  final String label;

  // Design tokens
  static const Color border = Color(0xFFE2E8F0);
  static const Color fieldBg = Color(0xFFF8FAFC);
  static const Color labelColor = Color(0xFF64748B);
  static const double rField = 12;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: labelColor,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),

        // Local Material ancestor for DropdownButton
        Material(
          type: MaterialType.transparency,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: fieldBg,
              borderRadius: BorderRadius.circular(rField),
              border: Border.all(color: border),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Unit>(
                  value: value,
                  isExpanded: true, // prevent row overflow on narrow screens
                  icon: const Icon(Icons.arrow_drop_down),
                  items: items
                      .map(
                        (u) => DropdownMenuItem<Unit>(
                          value: u,
                          child: Text(
                            '${u.name} (${u.symbol})',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: onChanged,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
