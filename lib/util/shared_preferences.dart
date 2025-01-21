import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferencesWithCache> getPreferences() async {
  final prefs = SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(),
  );

  return prefs;
}
