import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:ygo/components/card_viewer.dart';
import 'package:ygo/generated/l10n.dart';
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
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "${widget.card.name}",
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
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
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => CardViewer(
                              card: widget.card,
                            ),
                          ),
                        );
                      },
                      child: ConstrainedBox(
                          constraints: BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height / 2,
                              maxWidth:
                                  (MediaQuery.of(context).size.width / 2) - 20),
                          child: CachedNetworkImage(
                            imageUrl: widget.card.cardImages[0].imageUrl,
                            errorWidget: (_, url, error) {
                              return Image.asset(
                                  "assets/images/card_placeholder.png");
                            },
                            placeholder: (context, url) {
                              return Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(),
                                  ],
                                ),
                              );
                            },
                          )
                          // FadeInImage.assetNetwork(

                          // ),
                          ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(),
                            // Text(
                            //   "${widget.card.name}",
                            //   style: TextStyle(
                            //       fontWeight: FontWeight.w900, fontSize: 17),
                            // ),
                            // Divider(
                            //     // height: 20,
                            //     ),
                            Text("${S.of(context).type}: ${widget.card.type}"),
                            Divider(),
                            Text("${S.of(context).race}: ${widget.card.race}"),
                            Divider(),
                            widget.card.attribute == null
                                ? SizedBox()
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${S.of(context).attribute}: ${widget.card.attribute}",
                                      ),
                                      Divider(),
                                    ],
                                  ),
                            widget.card.level == null
                                ? SizedBox()
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${S.of(context).level}/${S.of(context).rank}: ${widget.card.level}",
                                      ),
                                      Divider(),
                                    ],
                                  ),
                            widget.card.archetype == null
                                ? SizedBox()
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "${S.of(context).archtype}: ${widget.card.archetype}"),
                                      Divider(),
                                    ],
                                  ),

                            widget.card.atk == null
                                ? SizedBox()
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${S.of(context).atk}: ${widget.card.atk} / ${S.of(context).def}: ${widget.card.def}",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      Divider(),
                                    ],
                                  ),

                            widget.card.banlistInfo == null
                                ? SizedBox()
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("${S.of(context).banlist}"),
                                      widget.card.banlistInfo.banTcg == null
                                          ? SizedBox()
                                          : Text(
                                              "TCG: ${widget.card.banlistInfo.banTcg}"),
                                      widget.card.banlistInfo.banOcg == null
                                          ? SizedBox()
                                          : Text(
                                              "OCG: ${widget.card.banlistInfo.banOcg}"),
                                      widget.card.banlistInfo.banGoat == null
                                          ? SizedBox()
                                          : Text(
                                              "Goat: ${widget.card.banlistInfo.banGoat}"),
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
