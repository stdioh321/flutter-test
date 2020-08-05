import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart';
import 'package:jwtcrud/components/custom_drawer.dart';
import 'package:jwtcrud/exceptions/custom_exception.dart';
import 'package:jwtcrud/models/brand.dart';
import 'package:jwtcrud/routes/app_routes.dart';
import 'package:jwtcrud/services/api.dart';
import 'package:jwtcrud/services/enums.dart';

class BrandsView extends StatefulWidget {
  @override
  _BrandsViewState createState() => _BrandsViewState();
}

class _BrandsViewState extends State<BrandsView> {
  List<Brand> _brands = [];
  List<Brand> brands = [];
  Loading loading = Loading.loading;
  String errorMsg;
  @override
  initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    try {
      // if (loading == Loading.loading) return;
      setState(() {
        loading = Loading.loading;
        errorMsg = null;
      });
      Response resp = await Api.getInstance().getBrands();
      if (resp.statusCode == 200) {
        var tmp = jsonDecode(resp.body) as List;
        _brands = tmp.map((e) => Brand.fromJson(e)).toList();
        brands = [..._brands];
        setState(() {
          loading = Loading.ok;
        });
      } else if (resp.statusCode == 401) {
        throw CustomException("Unauthorized", "401");
      } else if (resp.statusCode == 500) {
        throw CustomException("Server Error", "500");
      } else {
        throw Exception("Unknow Error");
      }
    } on CustomException catch (e) {
      errorMsg = e.message;
      setState(() {
        loading = Loading.error;
      });
    } catch (e) {
      errorMsg = "Unknow Error";
      setState(() {
        loading = Loading.error;
      });
    }
  }

  Widget _buidBody() {
    if (loading == Loading.loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (loading == Loading.error) {
      return Center(
        child: Text(errorMsg),
      );
    } else if (loading == Loading.ok) {
      if (brands.length == 0)
        return Center(
          child: Text(
            "Empty",
          ),
        );
      return ListView.separated(
        separatorBuilder: (context, index) => Divider(
          height: 2,
        ),
        itemCount: brands.length,
        itemBuilder: (context, index) {
          var brand = brands[index];
          return ListTile(
            title: Text(brand.name),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Modular.to.pushNamed("${AppRoutes.BRAND_DETAIL}/${brand.id}");
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
        title: Text(
          "Brands",
        ),
      ),
      body: Container(
        child: _buidBody(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Modular.to.pushNamed("${AppRoutes.BRAND_DETAIL}");
        },
        mini: true,
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}

class Brands {}
