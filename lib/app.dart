import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'features/converter_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Measures Converter',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      // Add a Scaffold so ScaffoldMessenger has a target for SnackBars.
      home: const Scaffold(
        // Transparent by default; your CupertinoPageScaffold renders the UI.
        body: ConverterPage(),
      ),
    );
  }
}
