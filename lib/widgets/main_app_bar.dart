import 'package:flutter/material.dart';
import 'package:flutter_pokedex/components/pokemon-type_colors.dart';
import '../pages/pokemon_list_page.dart';
import '../pages/favorites_page.dart';

class MainAppBar extends StatefulWidget {
  final Widget body;
  final String? title;
  final bool? searchVisible;
  final bool? typeIconVisible;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<String>? onTypeChanged;

  const MainAppBar({
    super.key,
    required this.body,
    this.title,
    this.searchVisible,
    this.typeIconVisible,
    this.onSearchChanged,
    this.onTypeChanged,
  });

  @override
  State<MainAppBar> createState() => _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar> {
  bool isSearchVisible = true;
  bool isTypeIconVisible = true;
  bool showSearchBar = false;
  bool showTypeBar = false;
  String? selectedType;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isSearchVisible = widget.searchVisible ?? true;
    isTypeIconVisible = widget.typeIconVisible ?? true;
  }

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    isSearchVisible
                        ? IconButton(
                          icon: Icon(Icons.search),
                          onPressed:
                              () => (setState(() {
                                widget.onSearchChanged!('');
                                showSearchBar = !showSearchBar;
                              })),
                        )
                        : SizedBox(),
                    isTypeIconVisible
                        ? IconButton(
                          icon: Icon(Icons.expand_more),
                          onPressed:
                              () => (setState(() {
                                showTypeBar = !showTypeBar;
                              })),
                        )
                        : SizedBox(),
                  ],
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
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                border: Border(bottom: Divider.createBorderSide(context)),
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

          if (showTypeBar)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    pokemonTypeColors.entries.map((entry) {
                      final isSelected = selectedType == entry.key;

                      return SizedBox(
                        width: 90,
                        height: 36,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: entry.value,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side:
                                  isSelected
                                      ? const BorderSide(
                                        color: Colors.black54,
                                        width: 2,
                                      )
                                      : BorderSide.none,
                            ),
                            shadowColor:
                                isSelected ? Colors.black : Colors.transparent,
                            elevation: isSelected ? 4 : 0,
                          ),
                          onPressed: () {
                            setState(() {
                              if (selectedType == entry.key) {
                                selectedType = 'all';
                              } else {
                                selectedType = entry.key;
                              }
                            });
                            if (widget.onTypeChanged != null) {
                              widget.onTypeChanged!(selectedType ?? entry.key);
                            }
                          },
                          child: Text(
                            entry.key,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),

          Expanded(child: widget.body),
        ],
      ),
    );
  }
}
