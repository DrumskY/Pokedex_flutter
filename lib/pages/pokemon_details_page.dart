import 'package:flutter/material.dart';
import 'package:flutter_pokedex/widgets/main_app_bar.dart';
import 'package:flutter_pokedex/components/pokemon-type_colors.dart';
import 'package:flutter_svg/svg.dart';

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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 380,
              child: Stack(
                children: [
                  Container(
                    color: backgroundColor,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Positioned(
                    top: 50,
                    left: 15,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: 25.0),
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Text(
                              'Details',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          pokemon.id < 100
                              ? pokemon.id < 10
                                  ? "#00${pokemon.id}"
                                  : "#0${pokemon.id}"
                              : '"#${pokemon.id}"',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 221, 221, 221),
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          pokemonName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          children:
                              pokemon.types!.map((type) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: 48,
                                      width: 48,
                                      decoration: BoxDecoration(
                                        color:
                                            pokemonTypeColors[type] ??
                                            Colors.grey,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            // ignore: deprecated_member_use
                                            color: Colors.black.withOpacity(
                                              0.5,
                                            ),
                                            blurRadius: 6,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      padding: EdgeInsets.all(8),
                                      child: SvgPicture.asset(
                                        'assets/types/$type.svg',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      type[0].toUpperCase() + type.substring(1),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                        ),
                      ],
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
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Image.network(
                        (pokemon.sprites.other?.frontDefault?.isNotEmpty ??
                                false)
                            ? pokemon.sprites.other!.frontDefault
                            : pokemon.sprites.frontDefault,
                        width: 250,
                        height: 250,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFF8F8F8),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: backgroundColor,
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: backgroundColor,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'To jest przykładowy tekst pod tytułem. Możesz tutaj dodać opis lub inne informacje.',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 25),

                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFF8F8F8),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: backgroundColor,
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Stats',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: backgroundColor,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'To jest przykładowy tekst pod tytułem. Możesz tutaj dodać opis lub inne informacje.',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Dodaj więcej zawartości wedle potrzeb
                ],
              ),
            ),
          ],
        ),
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
