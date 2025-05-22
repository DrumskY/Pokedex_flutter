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
          (json['abilities'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .map((a) => Ability.fromJson(a))
              .toList(),
      gameIndices:
          (json['game_indices'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .map((g) => GameIndex.fromJson(g))
              .toList(),
      moves:
          (json['moves'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .map((m) => Move.fromJson(m))
              .toList(),
      types:
          (json['types'] as List?)
              ?.map((t) {
                if (t is String) return t;
                if (t is Map<String, dynamic> &&
                    t.containsKey('type') &&
                    t['type'] is Map &&
                    t['type']['name'] is String) {
                  return t['type']['name'] as String;
                }
                return null;
              })
              .whereType<String>()
              .toList(),
      stats:
          (json['stats'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .map((s) => Stat.fromJson(s))
              .toList(),
      sprites: Sprites.fromJson(json['sprites']),
      species:
          json['species'] != null && json['species'] is Map<String, dynamic>
              ? Species.fromJson(json['species'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'base_experience': baseExperience,
      'height': height,
      'is_default': isDefault,
      'order': order,
      'weight': weight,
      'abilities': abilities?.map((a) => a.toJson()).toList(),
      'game_indices': gameIndices?.map((g) => g.toJson()).toList(),
      'moves': moves?.map((m) => m.toJson()).toList(),
      'types': types,
      'stats': stats?.map((s) => s.toJson()).toList(),
      'sprites': sprites.toJson(),
      'species': species?.toJson(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Pokemon && other.id == id);

  @override
  int get hashCode => id.hashCode;
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

  Map<String, dynamic> toJson() {
    return {'ability': ability.toJson(), 'is_hidden': isHidden, 'slot': slot};
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

  Map<String, dynamic> toJson() {
    return {'game_index': gameIndex, 'version': version.toJson()};
  }
}

class Move {
  final MapInfo move;

  Move({required this.move});

  factory Move.fromJson(Map<String, dynamic> json) {
    return Move(move: MapInfo.fromJson(json['move']));
  }

  Map<String, dynamic> toJson() {
    return {'move': move.toJson()};
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

  Map<String, dynamic> toJson() {
    return {'base_stat': baseStat, 'effort': effort, 'stat': stat.toJson()};
  }
}

class TypeSlot {
  final int slot;
  final MapInfo type;

  TypeSlot({required this.slot, required this.type});

  factory TypeSlot.fromJson(Map<String, dynamic> json) {
    return TypeSlot(slot: json['slot'], type: MapInfo.fromJson(json['type']));
  }

  Map<String, dynamic> toJson() {
    return {'slot': slot, 'type': type.toJson()};
  }
}

class Sprites {
  final String frontDefault;
  final Other? other;

  Sprites({required this.frontDefault, this.other});

  factory Sprites.fromJson(Map<String, dynamic> json) {
    return Sprites(
      frontDefault: json['front_default'] ?? '',
      other:
          json['other'] != null && json['other']['official-artwork'] != null
              ? Other.fromJson(json['other']['official-artwork'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'front_default': frontDefault,
      'other': other != null ? {'official-artwork': other!.toJson()} : null,
    };
  }
}

class Other {
  final String frontDefault;

  Other({required this.frontDefault});

  factory Other.fromJson(Map<String, dynamic> json) {
    return Other(frontDefault: json['front_default'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'front_default': frontDefault};
  }
}

class Species {
  final String name;
  final String url;

  Species({required this.name, required this.url});

  factory Species.fromJson(Map<String, dynamic> json) {
    return Species(name: json['name'], url: json['url']);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'url': url};
  }
}

class MapInfo {
  final String name;
  final String url;

  MapInfo({required this.name, required this.url});

  factory MapInfo.fromJson(Map<String, dynamic> json) {
    return MapInfo(name: json['name'], url: json['url']);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'url': url};
  }
}
