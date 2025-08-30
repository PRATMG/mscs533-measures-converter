import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

// These are my own files that handle the logic and custom widgets for conversion.
import 'converter.dart'; // Defines the converter interface
import 'converter_impl.dart'; // Actual implementation of conversion logic
import 'result_card.dart'; // Widget to show the conversion result
import 'swap_button.dart'; // Widget for the circular swap button
import 'unit.dart'; // Defines unit and category data
import 'unit_dropdown.dart'; // Custom dropdown widget for unit selection

class ConverterPage extends StatefulWidget {
  const ConverterPage({super.key});

  @override
  State<ConverterPage> createState() => _ConverterPageState();
}

// I created an enum to represent the three types of conversions my app supports.
enum Mode { length, weight, temp }

class _ConverterPageState extends State<ConverterPage> {
  // ---- Design tokens ---------------------------------------------------------
  // Instead of hardcoding styles everywhere, I put them here so it's easier to manage.
  static const Color bg = Color(0xFFF1F5F9);
  static const Color card = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE2E8F0);
  static const Color fieldBg = Color(0xFFF8FAFC);
  static const Color label = Color(0xFF64748B);

  // Standard radius and padding values I use across the UI
  static const double rCard = 20;
  static const double rButton = 16;
  static const double rField = 12;
  static const double pad6 = 6;
  static const double pad12 = 12;
  static const double pad16 = 16;

  // Controller to manage the value input field, I set a default of 543 for testing.
  final _valueCtrl = TextEditingController(text: '543');
  // Key for the form so I can add validation if needed later.
  final _formKey = GlobalKey<FormState>();
  // My converter object which handles the actual math for conversion.
  final Converter _converter = const ConverterImpl();

  Mode _mode = Mode.length;
  late Unit _from = unitsOf(Category.length).first;
  late Unit _to = unitsOf(Category.length)[1];

  // Current computed result
  double? _result;

  // Snapshot used to render the result card (prevents parsing live text in build)
  double? _displayInput;
  Unit? _displayFrom;
  Unit? _displayTo;
  Mode? _displayMode;

  // Accepts "12.3" or "12,3". Returns null if invalid.
  double? _coerceToDouble(String raw) {
    final t = raw.trim();
    if (t.isEmpty) return null;
    // Normalize comma decimal to dot and ensure only digits + single decimal.
    final normalized = t.replaceAll(',', '.');
    // Reject if contains letters or multiple dots.
    final invalid =
        RegExp(r'[^0-9.\- ]').hasMatch(normalized) ||
        RegExp(r'\.').allMatches(normalized).length > 1;
    if (invalid) return null;
    return double.tryParse(normalized);
  }

  List<Unit> _unitsFor(Mode m) => switch (m) {
    Mode.length => unitsOf(Category.length),
    Mode.weight => unitsOf(Category.weight),
    Mode.temp => unitsOf(Category.temperature),
  };

  void _onMode(Mode m) => setState(() {
    _mode = m;
    final list = _unitsFor(m);
    _from = list.first;
    _to = list.length > 1 ? list[1] : list.first;
    _result = null;
  });

  void _swap() {
    HapticFeedback.lightImpact();
    setState(() {
      final t = _from;
      _from = _to;
      _to = t;
      _result = null;
    });
  }

  void _convert() {
    final parsed = _coerceToDouble(_valueCtrl.text);
    if (parsed == null) {
      setState(() => _result = null);
      return;
    }
    final out = _converter.convert(value: parsed, from: _from, to: _to);
    setState(() {
      _result = out;

      // snapshot for rendering the card (prevents parsing during build)
      _displayInput = parsed;
      _displayFrom = _from;
      _displayTo = _to;
      _displayMode = _mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.viewInsetsOf(context).bottom;
    final list = _unitsFor(_mode);
    if (!list.contains(_from)) _from = list.first;
    if (!list.contains(_to)) _to = list.length > 1 ? list[1] : list.first;

    final isConvertible = _coerceToDouble(_valueCtrl.text) != null;

    return CupertinoPageScaffold(
      backgroundColor: bg,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Measures Converter'),
      ),
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: viewInsets),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Padding(
                padding: const EdgeInsets.all(pad16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Segmented control ------------------------------------------------
                    MediaQuery(
                      // Cap scaling only for the segmented control so it doesn't get huge.
                      data: MediaQuery.of(
                        context,
                      ).copyWith(textScaler: const TextScaler.linear(1.0)),
                      child: CupertinoSegmentedControl<Mode>(
                        padding: EdgeInsets.zero,
                        groupValue: _mode,
                        // NOTE: remove the `const` before the map so we can apply styles cleanly.
                        children: {
                          Mode.length: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            child: Text(
                              'Length',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Mode.weight: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            child: Text(
                              'Weight',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Mode.temp: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            child: Text(
                              'Temp',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        },
                        onValueChanged: _onMode,
                      ),
                    ),
                    const SizedBox(height: pad16),

                    // Form card --------------------------------------------------------
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: card,
                        borderRadius: BorderRadius.circular(rCard),
                        border: Border.all(color: border),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1F000000),
                            blurRadius: 16,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(pad16),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Value',
                                style: TextStyle(
                                  color: label,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: pad6),

                              // Value field (Cupertino) + input formatters to avoid junk chars
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  color: fieldBg,
                                  borderRadius: BorderRadius.circular(rField),
                                  border: Border.all(color: border),
                                ),
                                child: CupertinoTextField(
                                  controller: _valueCtrl,
                                  placeholder: 'Enter value',
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                        signed: false,
                                      ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      // digits, optional one dot or comma
                                      RegExp(r'[0-9,.]'),
                                    ),
                                  ],
                                  decoration: const BoxDecoration(),
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                              const SizedBox(height: pad16),

                              // From / Swap / To row (no overflow)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: UnitDropdown(
                                      items: list,
                                      value: _from,
                                      onChanged: (u) =>
                                          setState(() => _from = u ?? _from),
                                      label: 'From',
                                    ),
                                  ),
                                  const SizedBox(width: pad12),
                                  SizedBox(
                                    width: 44,
                                    height: 44,
                                    child: SwapButton(onPressed: _swap),
                                  ),
                                  const SizedBox(width: pad12),
                                  Expanded(
                                    child: UnitDropdown(
                                      items: list,
                                      value: _to,
                                      onChanged: (u) =>
                                          setState(() => _to = u ?? _to),
                                      label: 'To',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: pad16),

                              SizedBox(
                                height: 48,
                                child: CupertinoButton.filled(
                                  borderRadius: BorderRadius.circular(rButton),
                                  onPressed: isConvertible ? _convert : null,
                                  child: const Text('Convert'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: pad16),

                    // Result card ------------------------------------------------------
                    if (_result != null &&
                        _displayInput != null &&
                        _displayFrom != null &&
                        _displayTo != null &&
                        _displayMode != null)
                      ResultCard(
                        topLine:
                            '${_displayInput!.toStringAsFixed(1)} ${_displayFrom!.name}',
                        bottomLine: _displayMode == Mode.temp
                            ? '= ${_result!.toStringAsFixed(1)} ${_displayTo!.name}'
                            : '= ${_result!.toStringAsFixed(3)} ${_displayTo!.name}',
                        onCopyText:
                            '${_displayInput!.toStringAsFixed(_displayMode == Mode.temp ? 1 : 3)} ${_displayFrom!.name} = '
                            '${_result!.toStringAsFixed(_displayMode == Mode.temp ? 1 : 3)} ${_displayTo!.name}',
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
