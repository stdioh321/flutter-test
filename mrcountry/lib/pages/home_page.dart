import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:mrcountry/main.dart';
import 'package:mrcountry/models/country.dart';
import 'package:mrcountry/pages/location_detail.dart';
import 'package:mrcountry/services/api.dart';
import 'package:mrcountry/services/utils.dart';
import 'package:simple_search_bar/simple_search_bar.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:websafe_svg/websafe_svg.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Country> _countriesList = [];
  List<Country> countriesList = [];
  bool loading = true;
  AppBarController appBarController = AppBarController();
  Color appBarColor;

  @override
  void initState() {
    // TODO: implement initState

    // appBarColor = Theme.of(context).primaryColor;
    super.initState();
    loadCountries();
  }

  void loadCountries() async {
    setState(() {
      _countriesList = [];
      countriesList = [];
      loading = true;
    });
    try {
      _countriesList = await Api.instance.getCountries();
      setState(() {
        countriesList = _countriesList.toList();
      });
    } catch (e) {
      print(e);
      setState(() {
        _countriesList = null;
        // countriesList = null;
        loading = false;
        _showDialog("Error", "Unable to get the data.");
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            // define os botões na base do dialogo
            FlatButton(
              child: Text(
                "Close",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              color: Colors.red,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildBody() {
    if (loading) {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.timer),
            Text(
              "Loading...",
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          ],
        ),
      );
    } else if (_countriesList == null) {
      // print("I'm HERE");
      return Center(
          child: RaisedButton(
        onPressed: () {
          loadCountries();
        },
        color: Theme.of(context).primaryColor,
        child: Text("Retry",
            style: TextStyle(
              color: Colors.white,
            )),
      ));
    } else if (countriesList.length == 0) {
      return Center(
        child: Text(
          "Empty.",
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      );
    }
    return ListView.builder(
        itemCount: countriesList.length,
        itemBuilder: (context, index) {
          Country currCountry = countriesList[index];
          return Column(
            children: [
              ListTile(
                title: Text(currCountry.name),
                subtitle: Text(currCountry.region),
                onTap: () async {
                  // print(currCountry);
                  // Navigator.of(context).pushNamed("/location-detail");
                  var navResult = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            LocationDetailPage(country: currCountry),
                      ));
                  Utils.instance.primaryColor = Utils.instance.randomColor();
                  // print(navResult);
                },
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_forward,
                    )
                  ],
                ),
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.place,
                      color: Theme.of(context).primaryColor,
                      size: 35,
                    ),
                  ],
                ),
              ),
              Divider(
                color: Theme.of(context).primaryColor,
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text('Countries'),
        //   centerTitle: true,

        //   leading: Icon(
        //     Icons.search,
        //   ),
        // ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Utils.instance.changeBrightness(context);
            // print(apS.brightness);
          },
          mini: true,
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(
            Icons.lightbulb_outline,
          ),
        ),
        appBar: SearchAppBar(
          // primary: Theme.of(context).primaryColor,
          primary: Utils.instance.randomColor(),
          appBarController: appBarController,
          // You could load the bar with search already active
          autoSelected: false,
          searchHint: "Search...",
          mainTextColor: Colors.white,
          onChange: (String value) {
            //Your function to filter list. It should interact with
            //the Stream that generate the final list
            // print(value);
            setState(() {
              if (_countriesList != null)
                countriesList = _countriesList.where((element) {
                  if (element.name
                          .toLowerCase()
                          .trim()
                          .indexOf(value.toLowerCase().trim()) >
                      -1) return true;
                  return false;
                }).toList();
            });
          },
          //Will show when SEARCH MODE wasn't active
          mainAppBar: AppBar(
            title: Text("Mr. Country"),
            backgroundColor: appBarColor,
            centerTitle: true,
            actions: <Widget>[
              InkWell(
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Icon(
                    Icons.search,
                  ),
                ),
                onTap: () {
                  //This is where You change to SEARCH MODE. To hide, just
                  //add FALSE as value on the stream
                  appBarController.stream.add(true);
                },
              ),
            ],
          ),
        ),
        body: buildBody());
  }
}
