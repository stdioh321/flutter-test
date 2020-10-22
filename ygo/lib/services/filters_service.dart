import 'package:ygo/models/card_filter.dart';

class FiltersService {
  static FiltersService _instance = null;
  CardFilter cardFilter = CardFilter();

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
  FiltersService() {
    print("FiltersService Constructor");
  }
  static FiltersService getInstance() {
    if (_instance == null) _instance = new FiltersService();
    return _instance;
  }
}
