import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:flutter_pokedex/interface/pokemon.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesStorage {
  static const _favoritesKey = 'favorite_pokemons';

  static Future<void> saveFavorites(List<Pokemon> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteJsonList = favorites.map((p) => p.toJson()).toList();
    final jsonString = jsonEncode(favoriteJsonList);
    await prefs.setString(_favoritesKey, jsonString);
  }

  static Future<List<Pokemon>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_favoritesKey);
    if (jsonString == null) return [];

    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      print("Decoded favorites: $decoded");
      return decoded.map((json) => Pokemon.fromJson(json)).toList();
    } catch (e, stack) {
      print("❌ Error decoding favorites: $e");
      print(stack);
      return [];
    }
  }

  static Future<void> toggleFavorite(Pokemon pokemon) async {
    final favorites = await loadFavorites();
    if (favorites.contains(pokemon)) {
      favorites.remove(pokemon);
    } else {
      favorites.add(pokemon);
    }

    await saveFavorites(favorites);
  }

  static Future<bool> isFavorite(Pokemon pokemon) async {
    final favorites = await loadFavorites();
    return favorites.contains(pokemon);
  }
}
