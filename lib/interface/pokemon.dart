class Pokemon {
  final int id;
  final String name;
  final int? baseExperience;
  final int? height;
  final bool? isDefault;
  final int? order;
  final int? weight;
  final List<Ability>? abilities;
  final List<GameIndex>? gameIndices;
  final List<Move>? moves;
  final List<String>? types;
  final List<Stat>? stats;
  final Sprites sprites;
  final Species? species;

  Pokemon({
    required this.id,
    required this.name,
    this.baseExperience,
    this.height,
    this.isDefault,
    this.order,
    this.weight,
    this.abilities,
    this.gameIndices,
    this.moves,
    this.types,
    this.stats,
    required this.sprites,
    this.species,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      name: json['name'],
      baseExperience: json['base_experience'],
      height: json['height'],
      isDefault: json['is_default'],
      order: json['order'],
      weight: json['weight'],
      abilities:
          (json['abilities'] as List).map((a) => Ability.fromJson(a)).toList(),
      gameIndices:
          (json['game_indices'] as List)
              .map((g) => GameIndex.fromJson(g))
              .toList(),
      moves: (json['moves'] as List).map((m) => Move.fromJson(m)).toList(),
      types:
          (json['types'] as List)
              .map((t) => t['type']['name'] as String)
              .toList(),
      stats: (json['stats'] as List).map((s) => Stat.fromJson(s)).toList(),
      sprites: Sprites.fromJson(json['sprites']),
      species: Species.fromJson(json['species']),
    );
  }
}

class Ability {
  final MapInfo ability;
  final bool isHidden;
  final int slot;

  Ability({required this.ability, required this.isHidden, required this.slot});

  factory Ability.fromJson(Map<String, dynamic> json) {
    return Ability(
      ability: MapInfo.fromJson(json['ability']),
      isHidden: json['is_hidden'],
      slot: json['slot'],
    );
  }
}

class GameIndex {
  final int gameIndex;
  final MapInfo version;

  GameIndex({required this.gameIndex, required this.version});

  factory GameIndex.fromJson(Map<String, dynamic> json) {
    return GameIndex(
      gameIndex: json['game_index'],
      version: MapInfo.fromJson(json['version']),
    );
  }
}

class Move {
  final MapInfo move;

  Move({required this.move});

  factory Move.fromJson(Map<String, dynamic> json) {
    return Move(move: MapInfo.fromJson(json['move']));
  }
}

class Stat {
  final int baseStat;
  final int effort;
  final MapInfo stat;

  Stat({required this.baseStat, required this.effort, required this.stat});

  factory Stat.fromJson(Map<String, dynamic> json) {
    return Stat(
      baseStat: json['base_stat'],
      effort: json['effort'],
      stat: MapInfo.fromJson(json['stat']),
    );
  }
}

class TypeSlot {
  final int slot;
  final MapInfo type;

  TypeSlot({required this.slot, required this.type});

  factory TypeSlot.fromJson(Map<String, dynamic> json) {
    return TypeSlot(slot: json['slot'], type: MapInfo.fromJson(json['type']));
  }
}

class Sprites {
  final String frontDefault;

  Sprites({required this.frontDefault});

  factory Sprites.fromJson(Map<String, dynamic> json) {
    return Sprites(frontDefault: json['front_default'] ?? '');
  }
}

class Species {
  final String name;
  final String url;

  Species({required this.name, required this.url});

  factory Species.fromJson(Map<String, dynamic> json) {
    return Species(name: json['name'], url: json['url']);
  }
}

class MapInfo {
  final String name;
  final String url;

  MapInfo({required this.name, required this.url});

  factory MapInfo.fromJson(Map<String, dynamic> json) {
    return MapInfo(name: json['name'], url: json['url']);
  }
}
