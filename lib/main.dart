import 'package:material_ui/material_ui.dart';

import 'pages/catalog_page.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const NorthlineApp());
}

class NorthlineApp extends StatefulWidget {
  const NorthlineApp({super.key});

  @override
  State<NorthlineApp> createState() => _NorthlineAppState();
}

class _NorthlineAppState extends State<NorthlineApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Northline — Product Catalogue',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: CatalogPage(
        isDarkMode: _themeMode == ThemeMode.dark,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}
