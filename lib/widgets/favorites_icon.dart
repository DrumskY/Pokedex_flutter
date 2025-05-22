import 'package:flutter/material.dart';
import 'package:flutter_pokedex/interface/pokemon.dart';
import 'package:flutter_pokedex/services/favorites_storage.dart';

class FavoriteIcon extends StatefulWidget {
  final Pokemon pokemon;
  final bool isFavorite;
  final VoidCallback? onChanged;

  const FavoriteIcon({
    super.key,
    required this.pokemon,
    required this.isFavorite,
    this.onChanged,
  });

  @override
  State<FavoriteIcon> createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon> {
  @override
  void initState() {
    super.initState();
  }

  void _toggleFavorite() async {
    await FavoritesStorage.toggleFavorite(widget.pokemon);
    widget.onChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        widget.isFavorite ? Icons.favorite : Icons.favorite_border_outlined,
      ),
      onPressed: _toggleFavorite,
    );
  }
}
