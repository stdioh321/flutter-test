import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart';
import 'package:jwtcrud/components/custom_drawer.dart';
import 'package:jwtcrud/models/item.dart';
import 'package:jwtcrud/providers/items_provider.dart';
import 'package:jwtcrud/routes/app_routes.dart';
import 'package:jwtcrud/services/api.dart';
import 'package:jwtcrud/services/auth_service.dart';
import 'package:jwtcrud/services/enums.dart';
import 'package:jwtcrud/services/utils.dart';
import 'package:load/load.dart';

class ItemsView extends StatefulWidget {
  @override
  _ItemsViewState createState() => _ItemsViewState();
}

class _ItemsViewState extends State<ItemsView> {
  Loading loading = Loading.loading;
  @override
  void initState() {
    _loadData();
    super.initState();
  }

  _loadData() async {
    // showLoadingDialog();
    setState(() {
      loading = Loading.loading;
    });
    try {
      Response resp = await Api.getInstance().getItems();

      if (resp.statusCode == 200) {
        var itemsProv = Modular.get<ItemsProvider>();
        itemsProv.items = (jsonDecode(resp.body) as List)
            .map((e) => Item.fromJson(e))
            .toList();
        setState(() {
          loading = Loading.ok;
        });
      } else {
        throw Exception("ERROR");
      }
    } catch (e) {
      setState(() {
        loading = Loading.error;
      });
    }
  }

  _buildBody() {
    if (loading == Loading.loading) {
      return CircularProgressIndicator();
    } else if (loading == Loading.ok) {
      var itemsProv = Modular.get<ItemsProvider>();
      return ListView.separated(
        itemCount: itemsProv.items.length,
        itemBuilder: (context, index) {
          var item = itemsProv.items[index];
          return ListTile(
            title: Text(item.name),
            subtitle: Text("\$${item.price}"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Modular.to.pushNamed("${AppRoutes.ITEM_DETAIL}/${item.id}");
            },
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(Icons.assignment)],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: 2,
          );
        },
      );
    } else {
      return Center(
        child: Text("Error"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text("Items"),

        // automaticallyImplyLeading: false,
      ),
      body: Container(
        child: Center(
          child: _buildBody(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        child: Icon(Icons.add),
        onPressed: () {
          Modular.to.pushNamed(AppRoutes.ITEM_DETAIL);
        },
      ),
    );
  }
}
