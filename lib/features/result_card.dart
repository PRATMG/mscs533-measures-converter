// I am using Cupertino and Material widgets together here.
// Cupertino gives the iOS style, but I still need Material for SnackBar.
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icon, SnackBar, ScaffoldMessenger;
import 'package:flutter/services.dart';

// This widget is the card that shows the result after conversion.
// I wanted it to look like a clean iOS-style card with rounded corners, shadow, and a copy button.
class ResultCard extends StatelessWidget {
  const ResultCard({
    super.key,
    required this.topLine, // the main bold text (ex: "1000.0 kilograms")
    required this.bottomLine, // the smaller text (ex: "= 2204.623 pounds")
    required this.onCopyText, // plain text that gets copied to clipboard
  });

  final String topLine;
  final String bottomLine;
  final String onCopyText;

  // I keep the design tokens here so they are reusable and easy to tweak.
  static const Color card = Color(0xFFFFFFFF); // card background color
  static const Color border = Color(0xFFE2E8F0); // subtle border color
  static const double rCard = 20; // card corner radius
  static const double pad12 = 12; // horizontal spacing
  static const double pad16 = 16; // padding inside card

  // This method handles copying the result to the clipboard.
  // I also show a SnackBar so the user gets feedback when the copy is successful.
  void _copy(BuildContext context) {
    Clipboard.setData(ClipboardData(text: onCopyText));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Result copied')));
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(rCard),
        border: Border.all(color: border),
        boxShadow: const [
          // I used a shadow to make the card stand out from the background.
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(pad16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Leading circle icon to show success (a checkmark).
            const _CircleIcon(),
            const SizedBox(width: pad12),

            // Expanded so the text takes up all the remaining space.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top bold line with input + from unit
                  Text(
                    topLine,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Bottom smaller line with result
                  Text(
                    bottomLine,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),

            // Copy button on the right. I used CupertinoButton to match iOS style.
            CupertinoButton(
              padding: const EdgeInsets.all(8),
              minimumSize: const Size(
                44,
                44,
              ), // ensures tap area meets accessibility guidelines
              onPressed: () => _copy(context),
              child: const Icon(CupertinoIcons.doc_on_doc),
            ),
          ],
        ),
      ),
    );
  }
}

// This is a small widget for the circle with the checkmark inside.
// I kept it separate to keep the code clean and reusable.
class _CircleIcon extends StatelessWidget {
  const _CircleIcon();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC), // light background for the circle
        shape: BoxShape.circle,
      ),
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(
          CupertinoIcons.check_mark_circled_solid,
          color: CupertinoColors.activeGreen, // green checkmark for success
        ),
      ),
    );
  }
}
