import 'package:flutter/material.dart';
import '../pages/pokemon_list_page.dart';
import '../pages/favorites_page.dart';

class MainAppBar extends StatefulWidget {
  final Widget body;
  final String? title;
  final ValueChanged<String>? onSearchChanged;

  const MainAppBar({
    super.key,
    required this.body,
    this.title,
    this.onSearchChanged,
  });

  @override
  State<MainAppBar> createState() => _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar> {
  bool showSearchBar = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title ?? 'Pokédex',
                  style: const TextStyle(
                    fontFamily: 'PokemonSolid',
                    fontSize: 30,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed:
                      () => (setState(() {
                        widget.onSearchChanged!('');
                        showSearchBar = !showSearchBar;
                      })),
                ),
              ],
            ),
          ],
        ),
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.backgroundColor,
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(
                            'assets/PokeBall_icon.png',
                          ),
                        ),
                        const SizedBox(width: 18),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pokédex',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            Text(
                              'by DrumskY',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.catching_pokemon),
              title: const Text('Pokemon list'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PokemonListPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Favorites'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavoritesPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          if (showSearchBar)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search Pokemon...',
                  prefixIcon: IconButton(
                    icon: const Icon(Icons.search, color: Color(0xFFE53935)),
                    onPressed: () {
                      if (widget.onSearchChanged != null) {
                        widget.onSearchChanged!(_searchController.text);
                      }
                    },
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear, color: Color(0xFFE53935)),
                    onPressed:
                        () => {
                          widget.onSearchChanged!(''),
                          _searchController.clear(),
                        },
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE53935)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFE53935),
                      width: 2.0,
                    ),
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.all(8),
                  fillColor: const Color(0xFFE53935),
                ),
              ),
            ),

          Expanded(child: widget.body),
        ],
      ),
    );
  }
}
