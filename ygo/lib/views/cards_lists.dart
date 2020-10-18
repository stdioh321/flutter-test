import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:load/load.dart';
import 'package:simple_search_bar/simple_search_bar.dart';
import 'package:ygo/models/card_model.dart';
import 'package:ygo/routes/routes.dart';
import 'package:ygo/services/api.dart';
import 'package:ygo/views/card_details.dart';

class CardsList extends StatefulWidget {
  @override
  _CardsListState createState() => _CardsListState();
}

class _CardsListState extends State<CardsList> {
  List<CardModel> _cards = [];
  List<CardModel> cards = [];
  AppBarController appBarController = AppBarController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tmp();
  }

  tmp() async {
    showLoadingDialog(tapDismiss: false);
    try {
      Response resp = await Api.getInstance().getCards();
      if (resp.statusCode != 200) throw HttpException("Http Error");
      print("TMP");
      var tmpCardList = (jsonDecode(resp.body) as Map)['data'] as List<dynamic>;
      tmpCardList.forEach((el) {
        _cards.add(CardModel.fromJson(el));
      });
      cards = [..._cards];

      print(cards[0].toJson());
    } catch (e) {
      print("Error");
      print(e);
    }
    hideLoadingDialog();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(
        // primary: Theme.of(context).primaryColor,
        appBarController: appBarController,
        // You could load the bar with search already active
        autoSelected: false,
        searchHint: "Search Here...",
        mainTextColor: Colors.white,

        onChange: (String value) {
          //Your function to filter list. It should interact with
          //the Stream that generate the final list
          if (_cards == null || _cards.length < 1) return;
          value = value ?? "";
          value = value.toLowerCase().trim();
          print(value);
          setState(() {
            cards = _cards.where((el) {
              if (el.name.toLowerCase().indexOf(value) > -1) return true;
              return false;
            }).toList();
          });
          // setState(() {});
        },
        //Will show when SEARCH MODE wasn't active
        mainAppBar: AppBar(
          title: Text("Cards"),
          actions: <Widget>[
            InkWell(
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                child: Icon(
                  Icons.search,
                ),
              ),
              onTap: () {
                //This is where You change to SEARCH MODE. To hide, just
                //add FALSE as value on the stream
                if (_cards == null || _cards.length < 1) return;

                appBarController.stream.add(true);
              },
            ),
          ],
        ),
        primary: null,
      ),
      body: LoadingProvider(
        themeData: LoadingThemeData(loadingBackgroundColor: Colors.transparent),
        child: Container(
          padding: EdgeInsets.all(15),
          child: GridView.count(
            crossAxisCount: 2,
            // padding: EdgeInsets.only(bottom: 400),
            // crossAxisSpacing: 0,
            mainAxisSpacing: 10,
            children: cards.map((e) {
              return Container(
                // decoration: BoxDecoration(border: Border.all(width: 1)),
                padding: EdgeInsets.all(3),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        e.name,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return CardDetails(card: e);
                          }));
                        },
                        child: FadeInImage.assetNetwork(
                          image: e.cardImages[0].imageUrlSmall,
                          placeholder: 'assets/images/card_placeholder.png',
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
