import 'package:shared_preferences/shared_preferences.dart';

class FavoriteProductService {
    static const String _key = 'favorite_product';

    final SharedPreferencesAsync _prefs =
        SharedPreferencesAsync();
    
    Future<void> saveFavorite(String nama) async {
        await _prefs.setString(_key, nama);
    }

    Future<String?> getFavorite() async {
        return await _prefs.getString(_key);
    }

    Future<void> removeFavorite() async {
        await _prefs.remove(_key);
    }
}
