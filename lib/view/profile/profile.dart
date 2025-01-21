import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:todone/i18n/strings.g.dart';
import 'package:todone/util/shared_preferences.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          AppBar(
            leading: const CircleAvatar(
              child: Text('V'),
            ),
            title: Text(context.t.profile.hello(name: 'Visitor')),
          ),
          const Divider(),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: Text(context.t.profile.settings.darkTheme),
                  trailing: Switch(
                    value: AdaptiveTheme.of(context).mode ==
                        AdaptiveThemeMode.dark,
                    onChanged: (bool isDarkMode) {
                      isDarkMode
                          ? AdaptiveTheme.of(context).setDark()
                          : AdaptiveTheme.of(context).setLight();
                    },
                  ),
                ),
                ListTile(
                  title: Text(context.t.profile.settings.language),
                  trailing: MenuAnchor(
                    menuChildren: [
                      for (final lang in AppLocaleUtils.supportedLocales)
                        MenuItemButton(
                          child: Text(lang.languageCode),
                          onPressed: () async {
                            final prefs = await getPreferences();
                            await prefs.setString('lang', lang.languageCode);
                            await LocaleSettings.setLocale(
                              AppLocale.values.firstWhere(
                                (locale) =>
                                    locale.flutterLocale.languageCode ==
                                    lang.languageCode,
                              ),
                            );
                          },
                        ),
                    ],
                    builder: (context, controller, child) {
                      return TextButton(
                        onPressed: () {
                          controller.isOpen
                              ? controller.close()
                              : controller.open();
                        },
                        child: Text(context.t.$meta.locale.languageCode),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
