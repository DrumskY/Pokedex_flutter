import 'package:flutter/material.dart';
import 'pages/pokemon_list_page.dart';

void main() {
  runApp(const MainWidget());
}

class MainWidget extends StatelessWidget {
  const MainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokédex',
      theme: ThemeData(
        fontFamily: 'Nunito',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE53935),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF9F9F9),
          foregroundColor: Color.fromARGB(255, 221, 72, 69),
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        scaffoldBackgroundColor: const Color(
          0xFFF9F9F9,
        ), // prawie biały, lekki krem
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w200,
            color: Colors.black87,
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w300,
          ),
          labelLarge: TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w200,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFFE53935),
        ), // czerwone ikony
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFFFD700), // żółty Pikachu
          foregroundColor: Colors.black, // czarne ikony na żółtym
        ),
        drawerTheme: const DrawerThemeData(backgroundColor: Colors.white),
        useMaterial3: true,
      ),
      home: const PokemonListPage(), // startowa strona
    );
  }
}
