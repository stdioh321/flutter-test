import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:jwtcrud/models/brand.dart';
import 'package:jwtcrud/models/item.dart';
import 'package:jwtcrud/models/model.dart';
import 'package:jwtcrud/routes/app_routes.dart';
import 'package:jwtcrud/services/auth_service.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ItemDetail extends StatefulWidget {
  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  Item item;
  List<Brand> lstBrands = [];
  List<Model> lstModels = [];

  String slcBrand;
  String slcModel;

  final _form = GlobalKey<FormState>();
  final _formData = Map<String, dynamic>();
  String color;
  TextEditingController priceCtrl = TextEditingController(text: "");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadItem();
    print("DETAIL didChangeDependencies");
  }

  @override
  dispose() {
    super.dispose();
    print("DETAIL dispose");
  }

  Future _loadData() async {
    try {
      Response rBrand = await get("http://localhost:8000/api/brand", headers: {
        "Authorization": "Bearer " + AuthService.instance.getUser().token
      });
      Response rModel = await get("http://localhost:8000/api/model", headers: {
        "Authorization": "Bearer " + AuthService.instance.getUser().token
      });
      if (rBrand.statusCode == 200 && rModel.statusCode == 200) {
        lstBrands = (jsonDecode(rBrand.body) as List)
            .map((e) => Brand.fromJson(e))
            .toList();
        lstModels = (jsonDecode(rModel.body) as List)
            .map((e) => Model.fromJson(e))
            .toList();
        setState(() {
          print("DONE");
        });
      } else {
        throw Exception("Error getting Brands and Models");
      }
    } catch (e) {
      print(e);
    }
  }

  _loadItem() {
    item = (ModalRoute.of(context).settings.arguments as Item);
    if (item == null) {
      Timer.run(() {
        Navigator.of(context).pushNamed(AppRoutes.ITEMS_LIST);
      });

      return false;
    }

    _formData['color'] = item.color;
    color = _formData['color'];
    _formData['id'] = item.id;
    _formData['id_brand'] = item.idBrand;
    slcBrand = _formData['id_brand'];
    _formData['id_model'] = item.idModel;
    slcModel = _formData['id_model'];
    _formData['name'] = item.name;
    _formData['price'] = item.price;
    priceCtrl.text = _formData['price'];
    print(_formData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Item Detail"),
      ),
      body: Builder(
          builder: (context) => Container(
                padding: EdgeInsets.all(15),
                child: Form(
                  key: _form,
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _formData['name'],
                        onSaved: (newValue) => _formData['name'] = newValue,
                        validator: (String value) {
                          if (value == null || value.length < 3)
                            return "Must have at least 3 characters.";
                          return null;
                        },
                        // focusNode: ,
                        decoration: InputDecoration(
                          labelText: "Name",
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DropdownButton(
                          isExpanded: true,
                          value: color,
                          hint: Text(
                            "Color",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          items: ['Blue', 'Red', 'Green']
                              .map(
                                (e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ),
                              )
                              .toList(),
                          onChanged: (str) {
                            setState(() {
                              _formData['color'] = str;
                              color = str;
                            });
                          }),
                      TextFormField(
                        controller: priceCtrl,
                        inputFormatters: [
                          TextInputFormatter.withFunction((oldValue, newValue) {
                            // print(oldValue.text);
                            String txt =
                                newValue.text.replaceAll(RegExp(r'[\D\.]'), "");
                            // txt = txt.replaceAll(RegExp(r'^0+'), "");
                            if (txt.length > 2) {
                              txt = txt.substring(0, txt.length - 2) +
                                  "." +
                                  txt.substring(txt.length - 2);
                            }
                            return newValue.copyWith(
                                text: txt,
                                selection: TextSelection(
                                  baseOffset: txt.length,
                                  extentOffset: txt.length,
                                ));
                          }),
                        ],
                        // initialValue: _formData['price'],
                        onSaved: (newValue) => _formData['price'] = newValue,
                        validator: (String value) {
                          if (value == null || value.length < 1)
                            return "Must have at least 1   characters.";
                          return null;
                        },
                        // focusNode: ,
                        decoration: InputDecoration(
                          labelText: "Price",
                          icon: Icon(Icons.attach_money),
                        ),
                        onChanged: (value) {
                          if (value != null) {}
                        },
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                      ),
                      DropdownButton(
                          value: slcBrand,
                          hint: Text(
                            "Brand",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          isExpanded: true,
                          items: lstBrands
                              .map((e) => DropdownMenuItem(
                                    value: "${e.id}",
                                    child: Text(e.name),
                                  ))
                              .toList(),
                          onChanged: (v) {
                            setState(() {
                              _formData['id_brand'] = v;
                              slcBrand = v;
                            });
                          }),
                      DropdownButton(
                          value: slcModel,
                          hint: Text(
                            "Model",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          isExpanded: true,
                          items: lstModels
                              .map((e) => DropdownMenuItem(
                                    value: "${e.id}",
                                    child: Text(e.name),
                                  ))
                              .toList(),
                          onChanged: (v) {
                            setState(() {
                              _formData['id_model'] = v;
                            });
                          }),
                    ],
                  ),
                ),
              )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_form.currentState.validate()) {
            _form.currentState.save();
            var it = Item.fromJson(_formData);
            // print(it.name);
            print(it.toString());
          } else {
            try {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Check the form"),
              ));
            } catch (e) {
              print(e);
            }
          }
        },
        mini: true,
        child: Icon(
          Icons.save,
        ),
      ),
    );
  }
}
