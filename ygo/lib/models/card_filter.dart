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
