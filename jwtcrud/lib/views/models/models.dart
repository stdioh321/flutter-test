import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart';
import 'package:jwtcrud/components/custom_drawer.dart';
import 'package:jwtcrud/exceptions/custom_exception.dart';
import 'package:jwtcrud/models/model.dart';
import 'package:jwtcrud/routes/app_routes.dart';
import 'package:jwtcrud/services/api.dart';
import 'package:jwtcrud/services/enums.dart';

class ModelsViews extends StatefulWidget {
  @override
  _ModelsViewsState createState() => _ModelsViewsState();
}

class _ModelsViewsState extends State<ModelsViews> {
  Loading loading = Loading.blank;
  String errorMsg;
  List<Model> _models = [];
  List<Model> models = [];

  @override
  initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    try {
      if (loading == Loading.loading) return;
      errorMsg = null;
      loading = Loading.loading;
      setState(() {});

      Response resp = await Api.getInstance().getModels();
      if (resp.statusCode == 200) {
        var tmp = jsonDecode(resp.body) as List;
        _models = tmp.map((e) => Model.fromJson(e)).toList();
        models = [..._models];
        loading = Loading.ok;
      } else if (resp.statusCode == 401) {
        throw CustomException("Unauthorized", "401");
      } else if (resp.statusCode == 500) {
        throw CustomException("Server error", "500");
      } else {
        throw Exception("Unknow error");
      }
    } on CustomException catch (e) {
      errorMsg = e.message;
      loading = Loading.error;
    } catch (e) {
      errorMsg = "Unknow error";
      loading = Loading.error;
    }
    setState(() {});
  }

  _buildBody() {
    // super.
    if (loading == Loading.loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (loading == Loading.error) {
      return Center(
        child: Text(errorMsg),
      );
    } else if (loading == Loading.ok) {
      return ListView.separated(
        separatorBuilder: (context, index) => Divider(
          height: 2,
        ),
        itemCount: models.length,
        itemBuilder: (context, index) {
          var model = models[index];
          return ListTile(
            title: Text(model.name),
            subtitle: Text("${model.brand.name}"),
            trailing: Icon(
              Icons.arrow_forward,
            ),
            onTap: () async {
              await Modular.to
                  .pushNamed("${AppRoutes.MODEL_DETAIL}/${model.id}");
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text("Models"),
      ),
      body: Container(
        child: _buildBody(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Modular.to.pushNamed("${AppRoutes.MODEL_DETAIL}");
        },
        mini: true,
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
