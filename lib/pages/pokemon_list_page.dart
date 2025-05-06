// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_pokedex/widgets/main_app_bar.dart';
// import 'package:http/http.dart' as http;
// import 'package:loadmore/loadmore.dart';

// class Pokemon {
//   final String name;
//   final String url;
//   final int? id;
//   final String? imageUrl;
//   final List<String>? types;

//   Pokemon({
//     required this.name,
//     required this.url,
//     this.id,
//     this.imageUrl,
//     this.types,
//   });

//   factory Pokemon.fromJson(Map<String, dynamic> json) {
//     return Pokemon(name: json['name'], url: json['url']);
//   }

//   factory Pokemon.fromDetailsJson(Map<String, dynamic> json) {
//     return Pokemon(
//       name: json['name'],
//       url: '', // już niepotrzebne
//       id: json['id'],
//       imageUrl: json['sprites']['front_default'],
//       types:
//           (json['types'] as List)
//               .map((t) => t['type']['name'] as String)
//               .toList(),
//     );
//   }
// }

// class PokemonListPage extends StatefulWidget {
//   const PokemonListPage({super.key});

//   @override
//   State<PokemonListPage> createState() => _PokemonListPageState();
// }

// class _PokemonListPageState extends State<PokemonListPage> {
//   List<Pokemon> pokemonList = [];
//   bool isLoading = true;
//   int offset = 0;
//   final int limit = 20;
//   bool hasMore = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadMore();
//   }

//   Future<bool> _loadMore() async {
//     print("Loading more pokemons...");
//     final url = 'https://pokeapi.co/api/v2/pokemon?offset=$offset&limit=$limit';
//     final response = await http.get(Uri.parse(url));

//     if (response.statusCode == 200) {
//       final jsonData = json.decode(response.body);
//       final List results = jsonData['results'];

//       final futures =
//           results.map((item) async {
//             try {
//               final detailResponse = await http.get(Uri.parse(item['url']));
//               if (detailResponse.statusCode == 200) {
//                 final detailJson = json.decode(detailResponse.body);
//                 return Pokemon.fromDetailsJson(detailJson);
//               }
//             } catch (_) {}
//             return null;
//           }).toList();

//       final pokemons = await Future.wait(futures);
//       final newPokemons = pokemons.whereType<Pokemon>().toList();

//       setState(() {
//         pokemonList.addAll(newPokemons);
//         offset += limit;
//         isLoading = false;
//         hasMore = newPokemons.isNotEmpty;
//       });

//       return newPokemons.isNotEmpty; // ✅ informacja czy można jeszcze ładować
//     } else {
//       setState(() {
//         isLoading = false;
//         hasMore = false;
//       });
//       return false;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MainAppBar(
//       title: 'Pokemon List',
//       body:
//           isLoading && pokemonList.isEmpty
//               ? const Center(child: CircularProgressIndicator())
//               : LoadMore(
//                 isFinish: !hasMore,
//                 onLoadMore: _loadMore,
//                 child: GridView.builder(
//                   padding: const EdgeInsets.all(8),
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2, // Liczba kolumn
//                     crossAxisSpacing: 8,
//                     mainAxisSpacing: 8,
//                     childAspectRatio: 0.85, // proporcje kafelka
//                   ),
//                   itemCount: pokemonList.length,
//                   itemBuilder: (context, index) {
//                     final pokemon = pokemonList[index];
//                     return Card(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       elevation: 4,
//                       child: InkWell(
//                         onTap: () {
//                           // Można przejść do szczegółów
//                         },
//                         borderRadius: BorderRadius.circular(16),
//                         child: Padding(
//                           padding: const EdgeInsets.all(8),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               pokemon.imageUrl != null
//                                   ? Image.network(
//                                     pokemon.imageUrl!,
//                                     width: 72,
//                                     height: 72,
//                                     fit: BoxFit.contain,
//                                   )
//                                   : const Icon(Icons.image, size: 72),
//                               const SizedBox(height: 8),
//                               Text(
//                                 pokemon.name.toUpperCase(),
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                               if (pokemon.types != null)
//                                 Text(
//                                   pokemon.types!.join(', '),
//                                   style: const TextStyle(color: Colors.grey),
//                                   textAlign: TextAlign.center,
//                                 ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//     );
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_pokedex/pages/pokemon_details_page.dart' as details;
import 'package:flutter_pokedex/widgets/main_app_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_pokedex/components/pokemon-type_colors.dart';

import '../interface/pokemon.dart' as my_pokemon;

// class Pokemon {
//   final int id;
//   final String name;
//   final String imageUrl;
//   final List<String>? types;

//   Pokemon({
//     required this.id,
//     required this.name,
//     required this.imageUrl,
//     this.types,
//   });

//   factory Pokemon.fromJson(Map<String, dynamic> json) {
//     return Pokemon(
//       id: json['id'],
//       name: json['name'],
//       imageUrl: json['sprites']['front_default'] ?? '',
//       types:
//           (json['types'] as List)
//               .map((t) => t['type']['name'] as String)
//               .toList(),
//     );
//   }

//   @override
//   String toString() {
//     return 'Pokemon(name: $id, name: $name, imageUrl: $imageUrl, types: $types)';
//   }
// }

class PokemonListPage extends StatefulWidget {
  const PokemonListPage({super.key});

  @override
  State<PokemonListPage> createState() => _PokemonListPageState();
}

class _PokemonListPageState extends State<PokemonListPage> {
  final ScrollController _scrollController = ScrollController();
  List<my_pokemon.Pokemon> pokemonList = [];
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

        print(results);

        final List<Future<my_pokemon.Pokemon?>> futureList =
            results.map((pokemon) async {
              try {
                final detailResponse = await http.get(
                  Uri.parse(pokemon['url']),
                );
                if (detailResponse.statusCode == 200) {
                  final detailJson = json.decode(detailResponse.body);
                  return my_pokemon.Pokemon.fromJson(detailJson);
                }
              } catch (_) {}
              return null;
            }).toList();

        final pokemons = await Future.wait(futureList);
        final newPokemons = pokemons.whereType<my_pokemon.Pokemon>().toList();

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
      // Mały ekran (np. telefon)
      crossAxisCount = 2;
      childAspectRatio = 0.9;
    } else if (screenWidth < 900) {
      // Średni ekran (np. mały tablet)
      crossAxisCount = 3;
      childAspectRatio = 1.0;
    } else {
      // Duży ekran (np. duży tablet lub desktop)
      crossAxisCount = 4;
      childAspectRatio = 1.2;
    }
    return MainAppBar(
      title: 'Pokemon List',
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: childAspectRatio,
              ),
              itemCount: pokemonList.length,
              itemBuilder: (context, index) {
                final pokemon = pokemonList[index];
                final backgroundColor =
                    (pokemon.types?.isNotEmpty ?? false)
                        ? pokemonTypeColors[((pokemon.types!.length > 1 &&
                                    pokemon.types![0].toLowerCase() == 'normal')
                                ? pokemon.types![1].toLowerCase()
                                : pokemon.types![0].toLowerCase())] ??
                            const Color(0xFFA8A77A)
                        : const Color(0xFFA8A77A);
                String capitalize(String s) =>
                    s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : s;
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
                              (context) =>
                                  details.PokemonDetailsPage(pokemon: pokemon),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Text(
                          capitalize(pokemon.name),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: Colors.black,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                              pokemon.types!.map((type) {
                                final typeName = type.toLowerCase();
                                final assetPath = 'assets/types/$typeName.svg';

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
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: SvgPicture.asset(
                                    assetPath,
                                    width: 30,
                                    height: 30,
                                    placeholderBuilder:
                                        (context) =>
                                            const Icon(Icons.error, size: 24),
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
