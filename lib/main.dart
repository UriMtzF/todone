import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:todone/i18n/strings.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(TranslationProvider(child: MainApp(savedThemeMode: savedThemeMode)));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key, this.savedThemeMode});
  final AdaptiveThemeMode? savedThemeMode;

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan[700]!),
      ),
      dark: ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan[700]!),
      ),
      debugShowFloatingThemeButton: true,
      initial: savedThemeMode ?? AdaptiveThemeMode.dark,
      builder: (theme, darkTheme) {
        return MaterialApp(
          home: const Scaffold(
            body: Center(
              child: Text('Hello World!'),
            ),
          ),
          theme: theme,
          darkTheme: darkTheme,
          locale: TranslationProvider.of(context).flutterLocale,
          supportedLocales: AppLocaleUtils.supportedLocales,
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
        );
      },
    );
  }
}
