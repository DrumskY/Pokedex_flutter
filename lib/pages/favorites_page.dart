import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_pokedex/components/pokemon-type_colors.dart';
import 'package:flutter_pokedex/interface/pokemon.dart';
import 'package:flutter_pokedex/pages/pokemon_details_page.dart' as details;
import 'package:flutter_pokedex/widgets/favorites_icon.dart';
import 'package:flutter_pokedex/widgets/main_app_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Pokemon> listPokemons = [];
  List<Pokemon> favoritesPokemons = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getString('favorite_pokemons');
    if (favoritesJson == null) return;

    final List decoded = jsonDecode(favoritesJson);
    final pokemons =
        decoded
            .map((e) => Pokemon.fromJson(e as Map<String, dynamic>))
            .toList();

    setState(() {
      favoritesPokemons = pokemons;
      listPokemons = List.from(pokemons);
    });
  }

  Future<void> _refreshFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getString('favorite_pokemons');
    if (favoritesJson == null) {
      setState(() => favoritesPokemons = []);
      return;
    }

    final List decoded = jsonDecode(favoritesJson);
    setState(() {
      favoritesPokemons =
          decoded
              .map((e) => Pokemon.fromJson(e as Map<String, dynamic>))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount;
    double childAspectRatio;

    if (screenWidth < 600) {
      crossAxisCount = 2;
      childAspectRatio = 0.9;
    } else if (screenWidth < 900) {
      crossAxisCount = 3;
      childAspectRatio = 1.0;
    } else {
      crossAxisCount = 4;
      childAspectRatio = 1.2;
    }
    return MainAppBar(
      title: 'Favorites',
      searchVisible: false,
      body: Column(
        children: [
          Expanded(
            child:
                favoritesPokemons.isNotEmpty
                    ? GridView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(8),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: childAspectRatio,
                      ),
                      itemCount: listPokemons.length,
                      itemBuilder: (context, index) {
                        final pokemon = listPokemons[index];
                        final isFav =
                            favoritesPokemons.isNotEmpty
                                ? favoritesPokemons.any(
                                  (item) => item.id == pokemon.id,
                                )
                                : false;
                        final backgroundColor =
                            (pokemon.types?.isNotEmpty ?? false)
                                ? pokemonTypeColors[((pokemon.types!.length >
                                                1 &&
                                            pokemon.types![0].toLowerCase() ==
                                                'normal')
                                        ? pokemon.types![1].toLowerCase()
                                        : pokemon.types![0].toLowerCase())] ??
                                    const Color(0xFFA8A77A)
                                : const Color(0xFFA8A77A);
                        String capitalize(String s) =>
                            s.isNotEmpty
                                ? '${s[0].toUpperCase()}${s.substring(1)}'
                                : s;
                        return Card(
                          color: backgroundColor,
                          clipBehavior: Clip.hardEdge,
                          child: InkWell(
                            splashColor: Colors.white.withAlpha(30),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => details.PokemonDetailsPage(
                                        pokemon: pokemon,
                                      ),
                                ),
                              );
                            },
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    Padding(padding: EdgeInsets.only(top: 20)),
                                    Text(
                                      capitalize(pokemon.name),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 1.2,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children:
                                          pokemon.types!.map((type) {
                                            final typeName = type.toLowerCase();
                                            final assetPath =
                                                'assets/types/$typeName.svg';

                                            return Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 4,
                                                  ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: SvgPicture.asset(
                                                assetPath,
                                                width: 30,
                                                height: 30,
                                                placeholderBuilder:
                                                    (context) => const Icon(
                                                      Icons.error,
                                                      size: 24,
                                                    ),
                                              ),
                                            );
                                          }).toList(),
                                    ),
                                    Image.network(pokemon.sprites.frontDefault),
                                  ],
                                ),
                                Positioned(
                                  top: -5,
                                  right: -5,
                                  child: FavoriteIcon(
                                    pokemon: pokemon,
                                    isFavorite: isFav,
                                    onChanged: _refreshFavorites,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                    : Center(
                      child: Text(
                        'No results.',
                        style: TextStyle(fontSize: 30, color: Colors.grey),
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
