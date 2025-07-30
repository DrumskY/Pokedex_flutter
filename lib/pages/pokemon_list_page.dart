import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_pokedex/pages/pokemon_details_page.dart' as details;
import 'package:flutter_pokedex/widgets/favorites_icon.dart';
import 'package:flutter_pokedex/widgets/main_app_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_pokedex/components/pokemon-type_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../interface/pokemon.dart';

class PokemonListPage extends StatefulWidget {
  const PokemonListPage({super.key});

  @override
  State<PokemonListPage> createState() => _PokemonListPageState();
}

class _PokemonListPageState extends State<PokemonListPage> {
  String _searchQuery = '';
  String _typeQuery = '';
  final ScrollController _scrollController = ScrollController();
  List<Pokemon> pokemonList = [];
  List<Pokemon> _filteredPokemons = [];
  List<Pokemon> favoritePokemons = [];
  bool isLoading = false;
  int offset = 0;
  int limit = 10;
  int page = 0;
  bool hasMore = true;
  String _currentMode = 'all';

  int typeOffset = 0;
  final int typeLimit = 10;
  List<Pokemon> typePokemonList = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _loadPokemons();
    _scrollController.addListener(_onScroll);
  }

  bool isFavorite(Pokemon p) {
    return favoritePokemons.contains(p);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        hasMore &&
        !isLoading &&
        _searchQuery.isEmpty) {
      if (_currentMode == 'all') {
        _loadPokemons();
      } else if (_currentMode == 'type') {
        _fetchPokemonByType(_typeQuery, loadMore: true);
      }
    }
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getString('favorite_pokemons');
    if (favoritesJson == null) return;

    final List decoded = jsonDecode(favoritesJson);
    setState(() {
      favoritePokemons =
          decoded
              .map((e) => Pokemon.fromJson(e as Map<String, dynamic>))
              .toList();
    });
  }

  Future<void> _refreshFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getString('favorite_pokemons');
    if (favoritesJson == null) {
      setState(() => favoritePokemons = []);
      return;
    }

    final List decoded = jsonDecode(favoritesJson);
    setState(() {
      favoritePokemons =
          decoded
              .map((e) => Pokemon.fromJson(e as Map<String, dynamic>))
              .toList();
    });
  }

  Future<void> _loadPokemons({bool reset = false}) async {
    if (isLoading) return;

    if (reset) {
      setState(() {
        offset = 0;
        pokemonList.clear();
        hasMore = true;
      });
    }

    setState(() => isLoading = true);

    final url = 'https://pokeapi.co/api/v2/pokemon?offset=$offset&limit=$limit';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List results = data['results'];

        final List<Future<Pokemon?>> futureList =
            results.map((pokemon) async {
              try {
                final detailResponse = await http.get(
                  Uri.parse(pokemon['url']),
                );
                if (detailResponse.statusCode == 200) {
                  final detailJson = json.decode(detailResponse.body);
                  return Pokemon.fromJson(detailJson);
                }
              } catch (_) {}
              return null;
            }).toList();

        final pokemons = await Future.wait(futureList);
        final newPokemons = pokemons.whereType<Pokemon>().toList();

        setState(() {
          offset += limit;
          pokemonList.addAll(newPokemons);
          hasMore = newPokemons.isNotEmpty;
        });
      } else {
        setState(() {
          hasMore = false;
        });
      }
    } catch (e) {
      print('Error loading pokemons: $e');
      setState(() {
        hasMore = false;
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _searchedPokemon(String pokemonName) async {
    _filteredPokemons = [];
    final url = 'https://pokeapi.co/api/v2/pokemon/$pokemonName';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final pokemon = Pokemon.fromJson(data);

        setState(() {
          _filteredPokemons.add(pokemon);
        });
      } else {
        setState(() {
          _filteredPokemons = [];
        });
      }
    } catch (e) {
      print('Error loading pokemons: $e');
    }
  }

  Future<void> _fetchPokemonByType(String type, {bool loadMore = false}) async {
    if (isLoading) return;

    if (!loadMore) {
      setState(() {
        typeOffset = 0;
        typePokemonList.clear();
        hasMore = true;
      });
    }

    setState(() => isLoading = true);

    final url = 'https://pokeapi.co/api/v2/type/$type';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List pokemonEntries = data['pokemon'];

        final total = pokemonEntries.length;

        final start = typeOffset;
        final end =
            (typeOffset + typeLimit < total) ? typeOffset + typeLimit : total;

        if (start >= total) {
          setState(() {
            hasMore = false;
          });
          return;
        }

        final pageEntries =
            pokemonEntries
                .sublist(start, end)
                .map((entry) => entry['pokemon']['url'])
                .toList();

        final detailFutures =
            pageEntries.map((url) async {
              try {
                final res = await http.get(Uri.parse(url));
                if (res.statusCode == 200) {
                  final jsonData = jsonDecode(res.body);
                  return Pokemon.fromJson(jsonData);
                }
              } catch (e) {
                print('Error loading details: $e');
              }
              return null;
            }).toList();

        final pokemons = await Future.wait(detailFutures);
        final loaded = pokemons.whereType<Pokemon>().toList();

        setState(() {
          typeOffset = end;
          typePokemonList.addAll(loaded);
          pokemonList = typePokemonList;
          hasMore = end < total;
        });
      }
    } catch (e) {
      print('Error loading type pokemons: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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

    final displayedList =
        _searchQuery.isNotEmpty
            ? _filteredPokemons
            : (_typeQuery.isNotEmpty && _typeQuery != 'all')
            ? pokemonList
                .where(
                  (p) =>
                      p.types?.any(
                        (type) =>
                            type.toLowerCase() == _typeQuery.toLowerCase(),
                      ) ??
                      false,
                )
                .toList()
            : pokemonList;

    return MainAppBar(
      onSearchChanged: (value) {
        setState(() {
          _searchQuery = value;
          _filteredPokemons.clear();
        });

        if (_searchQuery.isEmpty) {
          if (_typeQuery != 'all') {
            _fetchPokemonByType(_typeQuery);
          } else {
            _loadPokemons(reset: true);
          }
        } else {
          _searchedPokemon(_searchQuery);
        }
      },

      onTypeChanged: (value) {
        setState(() {
          _typeQuery = value;
          _searchQuery = '';
          _filteredPokemons.clear();
          _currentMode = value == 'all' ? 'all' : 'type';
          pokemonList.clear();
          hasMore = true;
        });

        if (_typeQuery != 'all') {
          _fetchPokemonByType(_typeQuery);
        } else {
          _loadPokemons(reset: true);
        }
      },

      title: 'Pokédex',
      body: Column(
        children: [
          Expanded(
            child:
                _searchQuery.isNotEmpty && _filteredPokemons.isEmpty
                    ? const Center(
                      child: Text(
                        'No results.',
                        style: TextStyle(fontSize: 30, color: Colors.grey),
                      ),
                    )
                    : GridView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(8),
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: childAspectRatio,
                      ),
                      itemCount: displayedList.length,
                      itemBuilder: (context, index) {
                        final pokemon = displayedList[index];
                        final isFav = favoritePokemons.any(
                          (p) => p.id == pokemon.id,
                        );
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
                    ),
          ),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
