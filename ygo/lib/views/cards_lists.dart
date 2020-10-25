import 'dart:convert';
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:load/load.dart';
import 'package:simple_search_bar/simple_search_bar.dart';
import 'package:ygo/components/card_filters_modal.dart';
import 'package:ygo/generated/l10n.dart';
import 'package:ygo/models/card_filter.dart';
import 'package:ygo/models/card_model.dart';
import 'package:ygo/routes/routes.dart';
import 'package:ygo/services/api.dart';
import 'package:ygo/services/filters_service.dart';
import 'package:ygo/services/prefs.dart';
import 'package:ygo/services/status.dart';
import 'package:ygo/services/utils.dart';
import 'package:ygo/views/card_details.dart';

class CardsList extends StatefulWidget {
  @override
  _CardsListState createState() => _CardsListState();
}

class _CardsListState extends State<CardsList>
    with SingleTickerProviderStateMixin {
  List<CardModel> _cards = [];
  List<CardModel> cards = [];
  AppBarController appBarController = AppBarController();
  final _debouncer = Debouncer(milliseconds: 500);
  Status status = Status.none;
  TextEditingController _txtCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  bool currLang = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadCards();
    // loadCards();
  }

  _resetAll() {
    _cards = [];
    cards = [];
    _txtCtrl.text = "";
  }

  loadCards({String lang: ""}) async {
    showLoadingDialog(tapDismiss: false);
    status = Status.loading;

    _resetAll();
    setState(() {});
    try {
      Response resp = await Api.getInstance()
          .getCards(lang: Prefs.instance.prefs.get("lang") ?? "en");
      if (resp.statusCode != 200) throw HttpException("Http Error");

      var tmpCardList = (jsonDecode(resp.body) as Map)['data'] as List<dynamic>;
      tmpCardList.forEach((el) {
        _cards.add(CardModel.fromJson(el));
      });
      cards = [..._cards];
      status = Status.ok;
    } catch (e) {
      print("Error");
      print(e);
      status = Status.error;
    }

    hideLoadingDialog();
    setState(() {});
  }

  onExecFilter() {
    print("onExecFilter");
    if (status != Status.ok) return;

    _debouncer.run(() {
      cards = _cards.toList();
      String search = _txtCtrl.text ?? "";
      search = search.toLowerCase().trim();
      // print(search);
      setState(() {
        cards = _cards.where((el) {
          // Filter Card Types
          if (FiltersService.getInstance()
              .cardFilter
              .type
              .containsValue(true)) {
            return FiltersService.getInstance()
                .cardFilter
                .type
                .entries
                .any((element) {
              if ((el.type.toLowerCase().trim().indexOf(element.key) > -1 &&
                      element.value == true) ||
                  (element.key == "effect" &&
                      el.type.toLowerCase().trim().contains(
                            RegExp(r'(toon|spirit|gemini|tuner|union)'),
                          ))) {
                return true;
              }
              return false;
            });
          }

          return true;
        }).toList();
        // Filter Monster Attributes
        cards = cards.where((el) {
          if (FiltersService.getInstance()
              .cardFilter
              .attribute
              .containsValue(true)) {
            return FiltersService.getInstance()
                .cardFilter
                .attribute
                .entries
                .any((element) {
              if (el.attribute != null &&
                  el.attribute.toLowerCase().trim().indexOf(element.key) > -1 &&
                  element.value == true) {
                return true;
              }
              return false;
            });
          }
          return true;
        }).toList();

        // Filter Monster Types
        cards = cards.where((el) {
          if (FiltersService.getInstance()
              .cardFilter
              .monsterType
              .containsValue(true)) {
            return FiltersService.getInstance()
                .cardFilter
                .monsterType
                .entries
                .any((element) {
              if (el.race != null &&
                  el.race.toLowerCase().trim() == element.key &&
                  element.value == true) {
                return true;
              }
              return false;
            });
          }
          return true;
        }).toList();

        // Filter Monster Level
        cards = cards.where((el) {
          if (FiltersService.getInstance()
              .cardFilter
              .level
              .containsValue(true)) {
            return FiltersService.getInstance()
                .cardFilter
                .level
                .entries
                .any((element) {
              if (el.level != null &&
                  el.level == int.parse(element.key) &&
                  element.value == true) {
                return true;
              }
              return false;
            });
          }
          return true;
        }).toList();

        // Filter Spell Types
        cards = cards.where((el) {
          if (FiltersService.getInstance()
              .cardFilter
              .spell
              .containsValue(true)) {
            return FiltersService.getInstance()
                .cardFilter
                .spell
                .entries
                .any((element) {
              if (el.race != null &&
                  el.type.toLowerCase().trim() == "spell card" &&
                  el.race.toLowerCase().trim() == element.key &&
                  element.value == true) {
                return true;
              }
              return false;
            });
          }
          return true;
        }).toList();

        // Filter Trap Types
        cards = cards.where((el) {
          if (FiltersService.getInstance()
              .cardFilter
              .trap
              .containsValue(true)) {
            return FiltersService.getInstance()
                .cardFilter
                .trap
                .entries
                .any((element) {
              if (el.race != null &&
                  el.type.toLowerCase().trim() == "trap card" &&
                  el.race.toLowerCase().trim() == element.key &&
                  element.value == true) {
                return true;
              }
              return false;
            });
          }
          return true;
        }).toList();

        // Filter per Banlist
        cards = cards.where((el) {
          if (FiltersService.getInstance()
              .cardFilter
              .banlist
              .containsValue(true)) {
            return FiltersService.getInstance()
                .cardFilter
                .banlist
                .entries
                .any((element) {
              if (el?.banlistInfo?.banTcg != null &&
                  el.banlistInfo.banTcg.toLowerCase().trim() == element.key &&
                  element.value == true) {
                return true;
              }
              return false;
            });
          }
          return true;
        }).toList();

        // Filter Search Text
        cards = cards.where((el) {
          if (el.name.toLowerCase().indexOf(search) > -1) return true;
          if (el.desc.toLowerCase().indexOf(search) > -1) return true;
          return false;
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Utils.instance.removeFocus(context);
      },
      child: Scaffold(
        appBar: _buildSearchBar(context),
        body: LoadingProvider(
          themeData:
              LoadingThemeData(loadingBackgroundColor: Colors.transparent),
          child: _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return AppBar(
      actions: status != Status.ok
          ? []
          : [
              InkWell(
                child: IconButton(
                  icon: Icon(Icons.filter_alt_outlined),
                  onPressed: () async {
                    Utils.instance.removeFocus(context);
                    await showDialog(
                      context: context,
                      builder: (context) => CardFiltersModal(),
                    );
                    onExecFilter();
                  },
                ),
              ),
              DropdownButtonHideUnderline(
                child: DropdownButton(
                  value: Prefs.instance.prefs.get("lang") ?? "en",
                  iconSize: 0,
                  items: [
                    DropdownMenuItem(
                      value: 'pt',
                      child: Image.asset(
                        "assets/images/flags/pt.png",
                        // placeholder: "assets/images/flags/pt.png",
                        fit: BoxFit.contain,
                        width: 25,
                        height: 25,
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'en',
                      child: Image.asset(
                        "assets/images/flags/en.png",
                        // placeholder: "assets/images/flags/pt.png",
                        fit: BoxFit.contain,
                        width: 25,
                        height: 25,
                      ),
                    ),
                    // DropdownMenuItem(
                    //   value: 'fr',
                    //   child: Image.asset(
                    //     "assets/images/flags/fr.png",
                    //     // placeholder: "assets/images/flags/pt.png",
                    //     fit: BoxFit.contain,
                    //     width: 25,
                    //     height: 25,
                    //   ),
                    // ),
                    // DropdownMenuItem(
                    //   value: 'it',
                    //   child: Image.asset(
                    //     "assets/images/flags/it.png",
                    //     // placeholder: "assets/images/flags/pt.png",
                    //     fit: BoxFit.contain,
                    //     width: 25,
                    //     height: 25,
                    //   ),
                    // ),
                    // DropdownMenuItem(
                    //   value: 'de',
                    //   child: Image.asset(
                    //     "assets/images/flags/de.png",
                    //     // placeholder: "assets/images/flags/pt.png",
                    //     fit: BoxFit.contain,
                    //     width: 25,
                    //     height: 25,
                    //   ),
                    // ),
                  ],
                  onChanged: (value) async {
                    // print(value);
                    Utils.instance.removeFocus(context);
                    await Prefs.instance.prefs.setString("lang", value);
                    S.load(Locale(value));
                    FiltersService.getInstance().cardFilter.clear();
                    loadCards(lang: value);

                    setState(() {});
                  },
                  onTap: () {
                    // Utils.instance.removeFocus(context);
                    try {
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                    } catch (e) {}
                  },
                ),
              ),
              SizedBox(
                width: 5,
              ),
            ],
      // leading: ,
      title: Container(
        alignment: Alignment.centerLeft,
        // decoration: BoxDecoration(
        //   border: Border.all(color: Colors.red, width: 1),
        // ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: "${S.of(context).typeCard}...",
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                enabled: status == Status.ok,
                controller: _txtCtrl,
                onChanged: (v) {
                  onExecFilter();
                },
              ),
            ),
            _txtCtrl.text.isEmpty || status != Status.ok
                ? SizedBox()
                : IconButton(
                    icon: Icon(Icons.highlight_remove),
                    onPressed: () {
                      _txtCtrl.text = "";
                      onExecFilter();
                    },
                  )
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (status == Status.loading) {
      return Center(
        child: Text(
          S.of(context).loading,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        ),
      );
    } else if (status == Status.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              S.of(context).error,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton.icon(
              icon: Icon(Icons.refresh),
              label: Text(S.of(context).retry),
              onPressed: () {
                loadCards(
                  lang: Prefs.instance.prefs.get("lang"),
                );
              },
            ),
          ],
        ),
      );
    } else if (status == Status.ok) {
      if (cards.length == 0)
        return Center(
          child: Text(
            S.of(context).empty,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
          ),
        );

      return Stack(children: [
        Scrollbar(
          controller: _scrollCtrl,
          isAlwaysShown: false,
          radius: Radius.circular(10),
          child: Container(
            padding: EdgeInsets.all(05),
            child: GridView.count(
              controller: _scrollCtrl,
              crossAxisCount: MediaQuery.of(context).size.width > 768 ? 4 : 2,
              childAspectRatio: 0.685,
              mainAxisSpacing: 10,
              children: cards.map((e) {
                return Container(
                  // decoration: BoxDecoration(border: Border.all(width: 1)),
                  padding: EdgeInsets.all(3),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        // decoration: BoxDecoration(
                        //     border: Border.all(
                        //   color: Colors.red,
                        //   width: 2,
                        // )),
                        height: 20,
                        child: Text(
                          e.name,
                          // maxLines: 2,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold
                              // letterSpacing: 2,
                              ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () async {
                            Utils.instance.removeFocus(context);

                            var _previousScrollOffset = _scrollCtrl.offset;

                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return CardDetails(card: e);
                                },
                              ),
                            );
                            // print(_previousScrollOffset);
                            _scrollCtrl.animateTo(
                              _previousScrollOffset,
                              curve: Curves.easeInOut,
                              duration: Duration(milliseconds: 500),
                            );
                            // Utils.instance.removeFocus(context);
                            // appBarController.stream.add(false);
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CachedNetworkImage(
                                imageUrl: e.cardImages[0].imageUrl,
                                placeholder: (context, url) {
                                  return Container(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(),
                                    ],
                                  ));
                                  // return Image.asset(
                                  //     "assets/images/card_placeholder.png");
                                },
                              ),
                              Container(
                                alignment: Alignment.topRight,
                                child: (() {
                                  if (e.banlistInfo != null) {
                                    if (e.banlistInfo.banTcg != null) {
                                      String tmpImg = "forbidden.png";
                                      if (e.banlistInfo.banTcg
                                              .trim()
                                              .toLowerCase() ==
                                          "semi-limited")
                                        tmpImg = "limited-2.png";
                                      else if (e.banlistInfo.banTcg
                                              .trim()
                                              .toLowerCase() ==
                                          "limited") tmpImg = "limited-1.png";
                                      return Image.asset(
                                        "assets/images/${tmpImg}",
                                        width: 20,
                                        height: 20,
                                      );
                                    }
                                  }
                                  return SizedBox();
                                })(),
                              ),
                            ],
                          ),
                          // FadeInImage.assetNetwork(
                          //   fit: BoxFit.contain,
                          //   image: e.cardImages[0].imageUrlSmall,
                          //   placeholder: 'assets/images/card_placeholder.png',
                          // ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          // padding: ,
          padding: EdgeInsets.only(top: 40),
          child: CircleAvatar(
            maxRadius: 14,
            backgroundColor: Colors.grey[100],
            child: Text(
              "${cards.length}",
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: cards.length % 2 == 0 ? Colors.red : Colors.blue,
              ),
            ),
          ),
        ),
      ]);
    }
  }
}
