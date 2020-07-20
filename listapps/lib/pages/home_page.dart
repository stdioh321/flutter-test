import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:listapps/models/country.dart';
import 'package:listapps/pages/location_detail.dart';
import 'package:listapps/services/api.dart';
import 'package:simple_search_bar/simple_search_bar.dart';
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCountries();
  }

  void loadCountries() async {
    // setState(() {
    loading = true;
    // });
    try {
      // await Future.delayed(Duration(seconds: 4));
      _countriesList = await Api.instance.getCountries();
      countriesList = _countriesList.toList();
    } catch (e) {
      print(e);
    } finally {
      // setState(() {
      loading = false;
      // });
    }
    setState(() {});
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
      appBar: SearchAppBar(
        primary: Theme.of(context).primaryColor,
        appBarController: appBarController,
        // You could load the bar with search already active
        autoSelected: false,
        searchHint: "Search...",
        mainTextColor: Colors.white,
        onChange: (String value) {
          //Your function to filter list. It should interact with
          //the Stream that generate the final list
          print(value);
          setState(() {
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
          title: Text("Countries"),
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
      body: ListView.builder(
          itemCount: countriesList.length,
          itemBuilder: (context, index) {
            Country currCountry = countriesList[index];
            return Column(
              children: [
                ListTile(
                  title: Text(currCountry.name),
                  subtitle: Text(currCountry.region),
                  onTap: () {
                    // print(currCountry);
                    // Navigator.of(context).pushNamed("/location-detail");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              LocationDetailPage(country: currCountry),
                        ));
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
          }),
    );
  }
}
