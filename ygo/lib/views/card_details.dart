import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:ygo/models/card_model.dart';

class CardDetails extends StatefulWidget {
  final CardModel card;

  CardDetails({Key key, @required CardModel this.card});

  @override
  _CardDetailsState createState() => _CardDetailsState();
}

class _CardDetailsState extends State<CardDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Card Detail"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Container(),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => CardViewer(
                                url: widget.card.cardImages[0].imageUrl,
                              ),
                            ),
                          );
                        },
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height / 2),
                          child: FadeInImage.assetNetwork(
                            image: widget.card.cardImages[0].imageUrl,
                            placeholder: 'assets/images/card_placeholder.png',
                          ),
                        ),
                      ),
                      // Image.network(
                      //   widget.card.cardImages[0].imageUrl,
                      //   fit: BoxFit.contain,
                      // ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Container(
                        padding: EdgeInsets.only(left: 15),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(),
                            Text(
                              "${widget.card.name}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 20),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text("Type: ${widget.card.type}"),
                            Text("Race: ${widget.card.race}"),

                            widget.card.archetype == null
                                ? SizedBox()
                                : Text("Archtype: ${widget.card.archetype}"),
                            SizedBox(
                              height: 20,
                            ),
                            widget.card.atk == null
                                ? SizedBox()
                                : Text("Atk: ${widget.card.atk}",
                                    style: TextStyle(fontSize: 20)),
                            widget.card.def == null
                                ? SizedBox()
                                : Text("Def: ${widget.card.def}",
                                    style: TextStyle(fontSize: 20)),
                            widget.card.banlistInfo == null
                                ? SizedBox()
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 20),
                                      Text("Banlist"),
                                      widget.card.banlistInfo.banTcg == null
                                          ? SizedBox()
                                          : Text(
                                              "TCG: ${widget.card.banlistInfo.banTcg}"),
                                      widget.card.banlistInfo.banOcg == null
                                          ? SizedBox()
                                          : Text(
                                              "OCG: ${widget.card.banlistInfo.banOcg}"),
                                    ],
                                  ),

                            // Text("${widget.card}"),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Text(
                  "${widget.card.desc}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CardViewer extends StatelessWidget {
  final String url;
  CardViewer({@required this.url});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Card")),
      body: Container(
          child: PhotoView(
        enableRotation: true,
        // initialScale: 0.8,
        imageProvider: NetworkImage(url),
      )),
    );
  }
}
