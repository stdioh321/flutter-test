// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Type your card`
  String get typeCard {
    return Intl.message(
      'Type your card',
      name: 'typeCard',
      desc: '',
      args: [],
    );
  }

  /// `Empty`
  String get empty {
    return Intl.message(
      'Empty',
      name: 'empty',
      desc: '',
      args: [],
    );
  }

  /// `Loading`
  String get loading {
    return Intl.message(
      'Loading',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message(
      'Retry',
      name: 'retry',
      desc: '',
      args: [],
    );
  }

  /// `Monster`
  String get monster {
    return Intl.message(
      'Monster',
      name: 'monster',
      desc: '',
      args: [],
    );
  }

  /// `Spell`
  String get spell {
    return Intl.message(
      'Spell',
      name: 'spell',
      desc: '',
      args: [],
    );
  }

  /// `Trap`
  String get trap {
    return Intl.message(
      'Trap',
      name: 'trap',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get type {
    return Intl.message(
      'Type',
      name: 'type',
      desc: '',
      args: [],
    );
  }

  /// `Race`
  String get race {
    return Intl.message(
      'Race',
      name: 'race',
      desc: '',
      args: [],
    );
  }

  /// `Archtype`
  String get archtype {
    return Intl.message(
      'Archtype',
      name: 'archtype',
      desc: '',
      args: [],
    );
  }

  /// `Atk`
  String get atk {
    return Intl.message(
      'Atk',
      name: 'atk',
      desc: '',
      args: [],
    );
  }

  /// `Def`
  String get def {
    return Intl.message(
      'Def',
      name: 'def',
      desc: '',
      args: [],
    );
  }

  /// `Banlist`
  String get banlist {
    return Intl.message(
      'Banlist',
      name: 'banlist',
      desc: '',
      args: [],
    );
  }

  /// `Monster Type`
  String get monsterType {
    return Intl.message(
      'Monster Type',
      name: 'monsterType',
      desc: '',
      args: [],
    );
  }

  /// `Card Type`
  String get cardType {
    return Intl.message(
      'Card Type',
      name: 'cardType',
      desc: '',
      args: [],
    );
  }

  /// `Attribute`
  String get attribute {
    return Intl.message(
      'Attribute',
      name: 'attribute',
      desc: '',
      args: [],
    );
  }

  /// `Level`
  String get level {
    return Intl.message(
      'Level',
      name: 'level',
      desc: '',
      args: [],
    );
  }

  /// `Rank`
  String get rank {
    return Intl.message(
      'Rank',
      name: 'rank',
      desc: '',
      args: [],
    );
  }

  /// `Spell Type`
  String get spellType {
    return Intl.message(
      'Spell Type',
      name: 'spellType',
      desc: '',
      args: [],
    );
  }

  /// `Trap Type`
  String get trapType {
    return Intl.message(
      'Trap Type',
      name: 'trapType',
      desc: '',
      args: [],
    );
  }

  /// `Normal`
  String get normal {
    return Intl.message(
      'Normal',
      name: 'normal',
      desc: '',
      args: [],
    );
  }

  /// `Effect`
  String get effect {
    return Intl.message(
      'Effect',
      name: 'effect',
      desc: '',
      args: [],
    );
  }

  /// `Ritual`
  String get ritual {
    return Intl.message(
      'Ritual',
      name: 'ritual',
      desc: '',
      args: [],
    );
  }

  /// `Fusion`
  String get fusion {
    return Intl.message(
      'Fusion',
      name: 'fusion',
      desc: '',
      args: [],
    );
  }

  /// `Synchro`
  String get synchro {
    return Intl.message(
      'Synchro',
      name: 'synchro',
      desc: '',
      args: [],
    );
  }

  /// `Pendulum`
  String get pendulum {
    return Intl.message(
      'Pendulum',
      name: 'pendulum',
      desc: '',
      args: [],
    );
  }

  /// `Link`
  String get link {
    return Intl.message(
      'Link',
      name: 'link',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get light {
    return Intl.message(
      'Light',
      name: 'light',
      desc: '',
      args: [],
    );
  }

  /// `Dark`
  String get dark {
    return Intl.message(
      'Dark',
      name: 'dark',
      desc: '',
      args: [],
    );
  }

  /// `Water`
  String get water {
    return Intl.message(
      'Water',
      name: 'water',
      desc: '',
      args: [],
    );
  }

  /// `Fire`
  String get fire {
    return Intl.message(
      'Fire',
      name: 'fire',
      desc: '',
      args: [],
    );
  }

  /// `Earth`
  String get earth {
    return Intl.message(
      'Earth',
      name: 'earth',
      desc: '',
      args: [],
    );
  }

  /// `Wind`
  String get wind {
    return Intl.message(
      'Wind',
      name: 'wind',
      desc: '',
      args: [],
    );
  }

  /// `Divine`
  String get divine {
    return Intl.message(
      'Divine',
      name: 'divine',
      desc: '',
      args: [],
    );
  }

  /// `Dragon`
  String get dragon {
    return Intl.message(
      'Dragon',
      name: 'dragon',
      desc: '',
      args: [],
    );
  }

  /// `Zombie`
  String get zombie {
    return Intl.message(
      'Zombie',
      name: 'zombie',
      desc: '',
      args: [],
    );
  }

  /// `Fiend`
  String get fiend {
    return Intl.message(
      'Fiend',
      name: 'fiend',
      desc: '',
      args: [],
    );
  }

  /// `Pyro`
  String get pyro {
    return Intl.message(
      'Pyro',
      name: 'pyro',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'sea serpent' key

  /// `Rock`
  String get rock {
    return Intl.message(
      'Rock',
      name: 'rock',
      desc: '',
      args: [],
    );
  }

  /// `Machine`
  String get machine {
    return Intl.message(
      'Machine',
      name: 'machine',
      desc: '',
      args: [],
    );
  }

  /// `Fish`
  String get fish {
    return Intl.message(
      'Fish',
      name: 'fish',
      desc: '',
      args: [],
    );
  }

  /// `Dionsaur`
  String get dinosaur {
    return Intl.message(
      'Dionsaur',
      name: 'dinosaur',
      desc: '',
      args: [],
    );
  }

  /// `Insect`
  String get insect {
    return Intl.message(
      'Insect',
      name: 'insect',
      desc: '',
      args: [],
    );
  }

  /// `Beast`
  String get beast {
    return Intl.message(
      'Beast',
      name: 'beast',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'beast-warrior' key

  /// `Aqua`
  String get aqua {
    return Intl.message(
      'Aqua',
      name: 'aqua',
      desc: '',
      args: [],
    );
  }

  /// `Warrior`
  String get warrior {
    return Intl.message(
      'Warrior',
      name: 'warrior',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'winged beast' key

  /// `Fairy`
  String get fairy {
    return Intl.message(
      'Fairy',
      name: 'fairy',
      desc: '',
      args: [],
    );
  }

  /// `Spellcaster`
  String get spellcaster {
    return Intl.message(
      'Spellcaster',
      name: 'spellcaster',
      desc: '',
      args: [],
    );
  }

  /// `Thunder`
  String get thunder {
    return Intl.message(
      'Thunder',
      name: 'thunder',
      desc: '',
      args: [],
    );
  }

  /// `Reptile`
  String get reptile {
    return Intl.message(
      'Reptile',
      name: 'reptile',
      desc: '',
      args: [],
    );
  }

  /// `Psychic`
  String get psychic {
    return Intl.message(
      'Psychic',
      name: 'psychic',
      desc: '',
      args: [],
    );
  }

  /// `Wyrm`
  String get wyrm {
    return Intl.message(
      'Wyrm',
      name: 'wyrm',
      desc: '',
      args: [],
    );
  }

  /// `Cyberse`
  String get cyberse {
    return Intl.message(
      'Cyberse',
      name: 'cyberse',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'divine-beast' key

  /// `Tuner`
  String get tuner {
    return Intl.message(
      'Tuner',
      name: 'tuner',
      desc: '',
      args: [],
    );
  }

  /// `Spirit`
  String get spirit {
    return Intl.message(
      'Spirit',
      name: 'spirit',
      desc: '',
      args: [],
    );
  }

  /// `Gemini`
  String get gemini {
    return Intl.message(
      'Gemini',
      name: 'gemini',
      desc: '',
      args: [],
    );
  }

  /// `Toon`
  String get toon {
    return Intl.message(
      'Toon',
      name: 'toon',
      desc: '',
      args: [],
    );
  }

  /// `Union`
  String get union {
    return Intl.message(
      'Union',
      name: 'union',
      desc: '',
      args: [],
    );
  }

  /// `Continuos`
  String get continuos {
    return Intl.message(
      'Continuos',
      name: 'continuos',
      desc: '',
      args: [],
    );
  }

  /// `Field`
  String get field {
    return Intl.message(
      'Field',
      name: 'field',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'quick-play' key

  /// `Equip`
  String get equip {
    return Intl.message(
      'Equip',
      name: 'equip',
      desc: '',
      args: [],
    );
  }

  /// `Counter`
  String get counter {
    return Intl.message(
      'Counter',
      name: 'counter',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'pt'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}