class CardFilter {
  Map<String, bool> type = Map();
  Map<String, bool> race = Map();
  Map<String, bool> attribute = Map();
  Map<String, bool> monsterType = Map();
  Map<String, bool> level = Map();
  Map<String, bool> spell = Map();
  Map<String, bool> trap = Map();

  clear() {
    type = Map();
    race = Map();
    attribute = Map();
    monsterType = Map();
    level = Map();
    spell = Map();
    trap = Map();
  }

  bool hasActiveFilter() {
    bool tmpFilter = false;
    tmpFilter = type.entries.any((v) => v.value == true);
    tmpFilter = race.entries.any((v) => v.value == true);
    tmpFilter = attribute.entries.any((v) => v.value == true);
    tmpFilter = monsterType.entries.any((v) => v.value == true);
    tmpFilter = level.entries.any((v) => v.value == true);
    tmpFilter = spell.entries.any((v) => v.value == true);
    tmpFilter = trap.entries.any((v) => v.value == true);

    return tmpFilter;
  }
}

class CardFilters {
  Map<String, bool> type;
  Map<String, bool> race;
  Map<String, bool> attribute;
  Map<String, bool> monsterType;
  Map<String, bool> level;
  Map<String, bool> spell;
  Map<String, bool> trap;

  static CardFilters _instance;

  CardFilters() {
    init();
  }
  static get instance {
    if (_instance == null) _instance = CardFilters();
    return _instance;
  }

  init() {
    type = Map();
    race = Map();
    attribute = Map();
    monsterType = Map();
    level = Map();
    spell = Map();
    trap = Map();
  }

  List<String> attributes = [
    "light",
    "dark",
    "water",
    "fire",
    "earth",
    "wind",
    "divine",
  ];
  List<String> monsterCardTypes = [
    "normal",
    "effect",
    "ritual",
    "fusion",
    "sychro",
    "xyz",
    "pendulum",
    "link"
  ];
  List<String> monsterTypes = [
    "dragon",
    "zombie",
    "fiend",
    "pyro",
    "sea serpent",
    "rock",
    "machine",
    "fish",
    "dinosaur",
    "insect",
    "beast",
    "beast-warrior",
    "aqua",
    "warrior",
    "winged beast",
    "fairy",
    "spellcaster",
    "thunder",
    "reptile",
    "psychic",
    "wyrm",
    "cyberse",
    "divine-beast",
  ];

  List<String> spells = [
    "normal",
    "continuous",
    "field",
    "quick-play",
    "equip",
    "ritual"
  ];
  List<String> traps = [
    "normal",
    "counter",
    "continuous",
  ];
}
