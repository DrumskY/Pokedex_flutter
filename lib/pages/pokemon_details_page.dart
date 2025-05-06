import 'package:flutter/material.dart';
import 'package:flutter_pokedex/widgets/main_app_bar.dart';
import 'package:flutter_pokedex/components/pokemon-type_colors.dart';

import '../interface/pokemon.dart' as my_pokemon;

class PokemonDetailsPage extends StatelessWidget {
  final my_pokemon.Pokemon pokemon;

  const PokemonDetailsPage({Key? key, required this.pokemon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String pokemonName =
        '${pokemon.name[0].toUpperCase()}${pokemon.name.substring(1)}';
    final backgroundColor =
        (pokemon.types?.isNotEmpty ?? false)
            ? pokemonTypeColors[((pokemon.types!.length > 1 &&
                        pokemon.types![0].toLowerCase() == 'normal')
                    ? pokemon.types![1].toLowerCase()
                    : pokemon.types![0].toLowerCase())] ??
                const Color(0xFFA8A77A)
            : const Color(0xFFA8A77A);
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 50,
            left: 10,
            child: GestureDetector(
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: -20,
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                'assets/pokeball.png',
                width: 200,
                height: 200,
              ),
            ),
          ),
          Positioned.fill(
            top: 300,
            child: ClipPath(
              clipper: SmileClipper(),
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.only(top: 00),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SmileClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, 40);
    path.quadraticBezierTo(size.width / 2, 100, size.width, 40);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
