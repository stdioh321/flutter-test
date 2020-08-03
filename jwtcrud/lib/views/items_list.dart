import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:jwtcrud/exceptions/custom_exception.dart';
import 'package:jwtcrud/models/item.dart';
import 'package:jwtcrud/providers/auth_provider.dart';
import 'package:jwtcrud/providers/enums.dart';
import 'package:jwtcrud/providers/items_provider.dart';
import 'package:jwtcrud/routes/app_routes.dart';
import 'package:jwtcrud/services/api.dart';
import 'package:jwtcrud/services/auth_service.dart';
import 'package:provider/provider.dart';

class ItemsList extends StatefulWidget {
  @override
  _ItemsListState createState() => _ItemsListState();
}

class _ItemsListState extends State<ItemsList> {
  ItemsProvider itemsProvider;
  ReqStatus status = ReqStatus.init;
  @override
  void initState() {
    loadItems();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    print("didChangeDependencies HOME");
    itemsProvider = Provider.of(context);
    super.didChangeDependencies();
  }

  loadItems() async {
    setState(() {
      status = ReqStatus.loading;
    });
    var itemP = Provider.of<ItemsProvider>(context, listen: false);
    // itemP.notifyListeners();
    try {
      Response resp = await Api.getInstance()
          .itemsGet(AuthService.instance.getUser().token);
      if (resp.statusCode == 200) {
        itemP.loadItems(resp.body);
        status = ReqStatus.done;
        itemP.notifyListeners();
      } else
        throw Exception('ERROR');
    } catch (e) {
      print(e);
      // setState(() {
      status = ReqStatus.error;
      itemP.notifyListeners();
      // });
    }
  }

  Widget buildBody() {
    if (status == ReqStatus.loading ||
        status == ReqStatus.init ||
        itemsProvider == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (status == ReqStatus.error) {
      return Center(
        child: FlatButton(
            color: Colors.red,
            onPressed: () {
              loadItems();
            },
            child: Text(
              "Reload",
              style: TextStyle(
                color: Colors.white,
              ),
            )),
      );
    } else if (status == ReqStatus.done) {
      return Container(
        child: ListView.builder(
          itemCount: itemsProvider.items.length,
          itemBuilder: (context, index) {
            var item = itemsProvider.items[index];
            return ListTile(
              title: Text(
                item.name,
              ),
              trailing: Icon(
                Icons.arrow_forward,
              ),
              onTap: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.ITEM_DETAIL,
                  arguments: item,
                );
              },
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("\$${item.price}"),
                  Text("${item.color}"),
                ],
              ),
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print("build Home");
    return Scaffold(
      appBar: AppBar(
        title: Text("Items"),
        automaticallyImplyLeading: false,
      ),
      body: buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await AuthService.instance.setUser(null);
          print("DELETED");
        },
        child: Icon(
          Icons.remove,
        ),
      ),
    );
  }
}
