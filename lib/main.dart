import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:todone/i18n/strings.g.dart';
import 'package:todone/view/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  await LocaleSettings.useDeviceLocale();
  runApp(TranslationProvider(child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.cyan[700],
      ),
      dark: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.cyan[700],
      ),
      debugShowFloatingThemeButton: true,
      initial: AdaptiveThemeMode.dark,
      builder: (theme, darkTheme) {
        return MaterialApp(
          home: const HomePage(),
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
