import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_pokedex/pages/pokemon_details_page.dart' as details;
import 'package:flutter_pokedex/widgets/main_app_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_pokedex/components/pokemon-type_colors.dart';

import '../interface/pokemon.dart';

class PokemonListPage extends StatefulWidget {
  const PokemonListPage({super.key});

  @override
  State<PokemonListPage> createState() => _PokemonListPageState();
}

class _PokemonListPageState extends State<PokemonListPage> {
  String _searchQuery = '';
  final ScrollController _scrollController = ScrollController();
  List<Pokemon> pokemonList = [];
  List<Pokemon> _filteredPokemons = [];
  bool isLoading = false;
  int offset = 0;
  int limit = 10;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadPokemons();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !isLoading &&
        hasMore) {
      _loadPokemons();
    }
  }

  Future<void> _loadPokemons() async {
    if (isLoading) return;
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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _filterPokemons() {
    setState(() {
      _filteredPokemons =
          pokemonList.where((pokemon) {
            return pokemon.name.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            );
          }).toList();
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
      onSearchChanged: (value) {
        setState(() {
          _searchQuery = value;
          _searchedPokemon(_searchQuery);
        });
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
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: childAspectRatio,
                      ),
                      itemCount:
                          _searchQuery.isNotEmpty
                              ? _filteredPokemons.length
                              : pokemonList.length,
                      itemBuilder: (context, index) {
                        final pokemon =
                            _searchQuery.isNotEmpty
                                ? _filteredPokemons[index]
                                : pokemonList[index];
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
                            child: Column(
                              children: [
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:
                                      pokemon.types!.map((type) {
                                        final typeName = type.toLowerCase();
                                        final assetPath =
                                            'assets/types/$typeName.svg';

                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 4,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors
                                                    .transparent, // bo teraz pokazujesz obrazek
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
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
