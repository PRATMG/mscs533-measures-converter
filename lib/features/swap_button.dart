import 'package:flutter/material.dart';

/// Circular 44x44 swap button with ripple and proper semantics.
/// Haptics are triggered by the parent (so we keep this dumb & reusable).
class SwapButton extends StatelessWidget {
  const SwapButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Swap units',
      button: true,
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.swap_horiz_rounded),
          ),
        ),
      ),
    );
  }
}
