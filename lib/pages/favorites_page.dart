import 'package:flutter/material.dart';
import 'package:flutter_pokedex/widgets/main_app_bar.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainAppBar(
      title: 'Favorites List',
      body: const Center(child: Text('Tu będzie lista Pokemonów')),
    );
  }
}
