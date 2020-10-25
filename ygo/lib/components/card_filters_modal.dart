import 'package:flutter/material.dart';
import 'package:ygo/components/filter_item.dart';
import 'package:ygo/generated/l10n.dart';
import 'package:ygo/models/card_filter.dart';
import 'package:ygo/services/filters_service.dart';
import 'package:basic_utils/basic_utils.dart' as basic;

class CardFiltersModal extends StatefulWidget {
  CardFiltersModal();
  @override
  _CardFiltersModalState createState() => _CardFiltersModalState();
}

class _CardFiltersModalState extends State<CardFiltersModal> {
  bool tmpBool = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(50),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                backgroundColor: Colors.red,
                mini: true,
                onPressed: () {
                  FiltersService.getInstance().cardFilter.clear();
                  setState(() {});
                  // Navigator.pop(context);
                },
                child: GestureDetector(
                  onLongPress: () {
                    // Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FloatingActionButton(
                backgroundColor: Colors.green,
                child: Icon(
                  Icons.done_outline,
                  color: Colors.white,
                ),
                // color
                mini: true,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          appBar: TabBar(
            labelPadding: EdgeInsets.all(15),
            tabs: [
              Text(
                S.of(context).monster,
              ),
              Text(
                "${S.of(context).spell}/${S.of(context).trap}",
              ),
            ],
          ),
          body: TabBarView(
            children: [
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  // decoration: BoxDecoration(
                  //   border: Border.all(
                  //     width: 2,
                  //     color: Colors.red,
                  //   ),
                  // ),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${S.of(context).cardType}",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w900),
                        ),
                      ),
                      Wrap(
                        children: FiltersService.getInstance()
                            .monsterCardTypes
                            .map((e) {
                          return FilterItem(
                            itemValue: FiltersService.getInstance()
                                    .cardFilter
                                    .type[e] ??
                                false,
                            title: basic.StringUtils.capitalize(e),
                            callback: (bool v) {
                              print(v);
                              FiltersService.getInstance().cardFilter.type[e] =
                                  v;
                            },
                          );
                        }).toList(),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${S.of(context).attribute}",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w900),
                        ),
                      ),
                      Wrap(
                        children:
                            FiltersService.getInstance().attributes.map((e) {
                          return FilterItem(
                            // widthFactor: 0.5,
                            itemValue: FiltersService.getInstance()
                                    .cardFilter
                                    .attribute[e] ??
                                false,
                            title:
                                basic.StringUtils.capitalize(e, allWords: true),
                            callback: (bool v) {
                              FiltersService.getInstance()
                                  .cardFilter
                                  .attribute[e] = v;
                            },
                          );
                        }).toList(),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${S.of(context).monsterType}",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w900),
                        ),
                      ),
                      Wrap(
                        children: (() {
                          var tmpMonsterTypes = FiltersService.getInstance()
                              .monsterTypes
                              .map((e) {
                            return FilterItem(
                              // widthFactor: 0.5,
                              itemValue: FiltersService.getInstance()
                                      .cardFilter
                                      .monsterType[e] ??
                                  false,
                              title: basic.StringUtils.capitalize(e,
                                  allWords: true),
                              callback: (bool v) {
                                FiltersService.getInstance()
                                    .cardFilter
                                    .monsterType[e] = v;
                              },
                            );
                          }).toList();
                          ['tuner', 'spirit', 'gemini', 'toon', 'union']
                              .forEach((element) {
                            tmpMonsterTypes.add(FilterItem(
                              // widthFactor: 0.5,
                              itemValue: FiltersService.getInstance()
                                      .cardFilter
                                      .type[element] ??
                                  false,
                              title: basic.StringUtils.capitalize(element,
                                  allWords: true),
                              callback: (bool v) {
                                FiltersService.getInstance()
                                    .cardFilter
                                    .type[element] = v;
                              },
                            ));
                          });

                          return tmpMonsterTypes;
                        })(),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${S.of(context).level}/${S.of(context).rank}",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w900),
                        ),
                      ),
                      Wrap(
                        children: List.generate(12, (index) {
                          String level = "${index + 1}";
                          return FilterItem(
                            // widthFactor: 0.5,
                            itemValue: FiltersService.getInstance()
                                    .cardFilter
                                    .level[level] ??
                                false,
                            title: level,
                            callback: (bool v) {
                              FiltersService.getInstance()
                                  .cardFilter
                                  .level[level] = v;
                            },
                          );
                        }),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${S.of(context).banlist}",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w900),
                        ),
                      ),
                      Wrap(
                        children: FiltersService.getInstance().banlist.map((e) {
                          return FilterItem(
                            callback: (bool v) {
                              FiltersService.getInstance()
                                  .cardFilter
                                  .banlist[e] = v;
                            },
                            itemValue: FiltersService.getInstance()
                                    .cardFilter
                                    .banlist[e] ??
                                false,
                            title:
                                basic.StringUtils.capitalize(e, allWords: true),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${S.of(context).spellType}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Wrap(
                        children: FiltersService.getInstance().spells.map((e) {
                          return FilterItem(
                            // widthFactor: 0.5,
                            itemValue: FiltersService.getInstance()
                                    .cardFilter
                                    .spell[e] ??
                                false,
                            title:
                                basic.StringUtils.capitalize(e, allWords: true),
                            callback: (bool v) {
                              FiltersService.getInstance().cardFilter.spell[e] =
                                  v;
                            },
                          );
                        }).toList(),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${S.of(context).trapType}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Wrap(
                        children: FiltersService.getInstance().traps.map((e) {
                          return FilterItem(
                            // widthFactor: 0.5,
                            itemValue: FiltersService.getInstance()
                                    .cardFilter
                                    .trap[e] ??
                                false,
                            title:
                                basic.StringUtils.capitalize(e, allWords: true),
                            callback: (bool v) {
                              FiltersService.getInstance().cardFilter.trap[e] =
                                  v;
                            },
                          );
                        }).toList(),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${S.of(context).banlist}",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w900),
                        ),
                      ),
                      Wrap(
                        children: FiltersService.getInstance().banlist.map((e) {
                          return FilterItem(
                            callback: (bool v) {
                              FiltersService.getInstance()
                                  .cardFilter
                                  .banlist[e] = v;
                            },
                            itemValue: FiltersService.getInstance()
                                    .cardFilter
                                    .banlist[e] ??
                                false,
                            title:
                                basic.StringUtils.capitalize(e, allWords: true),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// GridView.count(
//   crossAxisCount: 2,
//   children: [
//     FilterItem(
//       itemValue: FiltersService.getInstance()
//               .cardFilter
//               .type['normal'] ??
//           false,
//       title: "Normal",
//       callback: (bool v) {
//         print(v);
//         FiltersService.getInstance()
//             .cardFilter
//             .type["normal"] = v;
//       },
//     ),
//     FilterItem(
//       itemValue: FiltersService.getInstance()
//               .cardFilter
//               .type['effect'] ??
//           false,
//       title: "Effect",
//       callback: (bool v) {
//         print(v);
//         FiltersService.getInstance()
//             .cardFilter
//             .type["effect"] = v;
//       },
//     ),
//     FilterItem(
//       itemValue: FiltersService.getInstance()
//               .cardFilter
//               .type['fusion'] ??
//           false,
//       title: "Fusion",
//       callback: (bool v) {
//         print(v);
//         FiltersService.getInstance()
//             .cardFilter
//             .type["fusion"] = v;
//       },
//     ),
//     FilterItem(
//       itemValue: FiltersService.getInstance()
//               .cardFilter
//               .type['ritual'] ??
//           false,
//       title: "Ritual",
//       callback: (bool v) {
//         print(v);
//         FiltersService.getInstance()
//             .cardFilter
//             .type["ritual"] = v;
//       },
//     ),
//     FilterItem(
//       itemValue: FiltersService.getInstance()
//               .cardFilter
//               .type['synchro'] ??
//           false,
//       title: "Synchro",
//       callback: (bool v) {
//         print(v);
//         FiltersService.getInstance()
//             .cardFilter
//             .type["synchro"] = v;
//       },
//     ),
//     FilterItem(
//       itemValue: FiltersService.getInstance()
//               .cardFilter
//               .type['xyz'] ??
//           false,
//       title: "Xyz",
//       callback: (bool v) {
//         print(v);
//         FiltersService.getInstance()
//             .cardFilter
//             .type["xyz"] = v;
//       },
//     ),
//     FilterItem(
//       itemValue: FiltersService.getInstance()
//               .cardFilter
//               .type['pendulum'] ??
//           false,
//       title: "Pendulum",
//       callback: (bool v) {
//         print(v);
//         FiltersService.getInstance()
//             .cardFilter
//             .type["pendulum"] = v;
//       },
//     ),
//     FilterItem(
//       itemValue: FiltersService.getInstance()
//               .cardFilter
//               .type['link'] ??
//           false,
//       title: "Link",
//       callback: (bool v) {
//         print(v);
//         FiltersService.getInstance()
//             .cardFilter
//             .type["link"] = v;
//       },
//     ),
//   ],
// ),
