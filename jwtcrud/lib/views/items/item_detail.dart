import 'dart:convert';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart';
import 'package:jwtcrud/components/error_message.dart';
import 'package:jwtcrud/exceptions/custom_exception.dart';
import 'package:jwtcrud/models/brand.dart';
import 'package:jwtcrud/models/item.dart';
import 'package:jwtcrud/models/model.dart';
import 'package:jwtcrud/routes/app_routes.dart';
import 'package:jwtcrud/services/api.dart';
import 'package:jwtcrud/services/auth_service.dart';
import 'package:jwtcrud/services/enums.dart';
import 'package:jwtcrud/services/utils.dart';

class ItemDetailView extends StatefulWidget {
  String id;
  ItemDetailView({this.id}) {
    // print(id);
  }
  @override
  _ItemDetailViewState createState() => _ItemDetailViewState();
}

class _ItemDetailViewState extends State<ItemDetailView> {
  Loading loading = Loading.loading;
  Loading loadingSubmit = Loading.blank;

  Item item;
  List<Brand> brands = [];
  List<Model> _models = [];
  List<Model> models = [];

  String chosenBrand;
  String chosenModel;
  String errorMessageSubmit;
  var _form = GlobalKey<FormState>();
  var _formData = Map<String, dynamic>();
  GlobalKey<AutoCompleteTextFieldState<String>> _keySimpleAutoComplete =
      GlobalKey();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _loadData();
  }

  _loadData() async {
    loading = Loading.loading;
    setState(() {});
    try {
      // print("chosenModel: $chosenModel");
      Response respBrand = await Api.getInstance().getBrands();
      brands = (jsonDecode(respBrand.body) as List)
          .map((e) => Brand.fromJson(e))
          .toList();
      // print(brands);
      Response respModel = await Api.getInstance().getModels();
      _models = (jsonDecode(respModel.body) as List)
          .map((e) => Model.fromJson(e))
          .toList();

      if (widget.id != null) {
        Response respItem = await Api.getInstance().getItems(widget.id);
        item = Item.fromJson(jsonDecode(respItem.body));

        models = _models
            .where((element) => element.idBrand == item.idBrand)
            .toList();

        _formData['name'] = item.name;
        _formData['price'] = item.price;
        _formData['color'] = item.color;
        // _keySimpleAutoComplete.currentState.currentText = item.color;

        _formData['id_brand'] = item.idBrand;
        chosenBrand = _formData['id_brand'];
        if (models.where((e) => "${e.id}" == item.idModel).length > 0) {
          _formData['id_model'] = item.idModel;
          chosenModel = _formData['id_model'];
        }
      }

      loading = Loading.ok;
    } catch (e) {
      print(e);
      item = null;
      brands = null;
      _models = null;
      models = null;
      loading = Loading.error;
    }
    setState(() {});
  }

  _onSubmit([String str]) {
    if (_isValidate()) {
      _form.currentState.save();
      errorMessageSubmit = null;
      setState(() {});
      if (widget.id != null)
        _putItem();
      else
        _postItem();
      // print(_formData);
    }
  }

  _isValidate() {
    if (_form.currentState.validate()) {
      // if (_formData['id_brand'] != null && _formData['id_model'] != null)
      return true;
    }

    return false;
  }

  _postItem() async {
    if (loadingSubmit == Loading.loading) return;
    loadingSubmit = Loading.loading;
    setState(() {});
    try {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      Response resp = await Api.getInstance().postItem(_formData);
      if (resp.statusCode >= 200 && resp.statusCode <= 299) {
        await Modular.to
            .pushNamedAndRemoveUntil(AppRoutes.ITEMS, ModalRoute.withName("/"));
        loadingSubmit = Loading.ok;
        setState(() {});
      } else if (resp.statusCode == 409) {
        throw CustomException("Name already used.", "409");
      } else if (resp.statusCode == 400) {
        throw CustomException("Field validation.", "400");
      } else if (resp.statusCode == 500) {
        throw CustomException("Server Error.", "500");
      } else {
        throw Exception("Unknow error");
      }
    } on CustomException catch (e) {
      loadingSubmit = Loading.error;
      errorMessageSubmit = e.message;
      setState(() {});
    } catch (e) {
      loadingSubmit = Loading.error;
      errorMessageSubmit = "Unknow error";
      setState(() {});
    }
  }

  _putItem() async {
    if (loadingSubmit == Loading.loading) return;
    loadingSubmit = Loading.loading;
    setState(() {});
    try {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      Response resp = await Api.getInstance().putItem("${item.id}", _formData);
      if (resp.statusCode >= 200 && resp.statusCode <= 299) {
        await Modular.to
            .pushNamedAndRemoveUntil(AppRoutes.ITEMS, ModalRoute.withName("/"));
        loadingSubmit = Loading.ok;
        setState(() {});
      } else if (resp.statusCode == 409) {
        throw CustomException("Name already used.", "409");
      } else if (resp.statusCode == 400) {
        throw CustomException("Field validation.", "400");
      } else if (resp.statusCode == 500) {
        throw CustomException("Server Error.", "500");
      } else {
        throw Exception("Unknow error");
      }
    } on CustomException catch (e) {
      loadingSubmit = Loading.error;
      errorMessageSubmit = e.message;
      setState(() {});
    } catch (e) {
      loadingSubmit = Loading.error;
      errorMessageSubmit = "Unknow error";
      setState(() {});
    }
  }

  Widget _buildBody() {
    if (loading == Loading.loading) {
      return Center(child: CircularProgressIndicator());
    } else if (loading == Loading.error) {
      return Center(child: Text("Error"));
    } else if (loading == Loading.ok) {
      return Container(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Form(
            key: _form,
            child: Column(
              children: [
                TextFormField(
                  initialValue: _formData['name'],
                  onSaved: (v) => _formData['name'] = v,
                  onFieldSubmitted: _onSubmit,
                  validator: (v) {
                    if (v == null || v.length < 2)
                      return "It must have at least 2 characters.";
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Name",
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                DropdownButtonFormField(
                  value: chosenBrand,
                  isExpanded: true,
                  hint: Text("Brand"),
                  validator: (value) {
                    if (value == null) return "*Required";
                    return null;
                  },
                  items: brands
                      .map(
                        (e) => DropdownMenuItem(
                          child: Text(e.name),
                          value: "${e.id}",
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    setState(() {
                      chosenBrand = v;
                      _formData['id_brand'] = v;
                      models = [];
                      chosenModel = null;
                      _formData['id_model'] = null;
                      models =
                          _models.where((e) => "${e.idBrand}" == v).toList();
                    });
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                DropdownButtonFormField(
                  value: chosenModel,
                  isExpanded: true,
                  hint: Text("Model"),
                  validator: (value) {
                    if (value == null) return "*Required";
                    return null;
                  },
                  items: models.map(
                    (e) {
                      return DropdownMenuItem(
                        child: Text(e.name),
                        value: "${e.id}",
                      );
                    },
                  ).toList(),
                  onChanged: (v) {
                    setState(() {
                      chosenModel = v;
                      _formData['id_model'] = v;
                    });
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  initialValue: _formData['price'],
                  onSaved: (v) => _formData['price'] = v,
                  onFieldSubmitted: _onSubmit,
                  validator: (v) {
                    if (v == null || v.length < 1)
                      return "It must have at least 1 characters.";
                    return null;
                  },
                  inputFormatters: [
                    TextInputFormatter.withFunction(
                      (oldValue, newValue) {
                        String txt =
                            newValue.text.replaceAll(RegExp(r'\D'), "");

                        if (txt != null && txt.length > 2) {
                          // print("inside if");
                          // var n = double.parse(txt.padLeft(4, '0'));

                          txt = txt.substring(0, (txt.length - 2)) +
                              "." +
                              txt.substring(txt.length - 2);
                          // txt = txt.padLeft(4, '0');
                        }
                        newValue = newValue.copyWith(
                            text: txt,
                            selection: TextSelection(
                              baseOffset: txt.length,
                              extentOffset: txt.length,
                            ));
                        return newValue;
                      },
                    )
                  ],
                  decoration: InputDecoration(
                      labelText: "Price",
                      icon: Icon(
                        Icons.attach_money,
                      )),
                ),
                SizedBox(
                  height: 15,
                ),
                SimpleAutoCompleteTextField(
                  controller: TextEditingController(text: _formData['color']),
                  decoration: InputDecoration(
                    labelText: "Color (optional)",
                    icon: Icon(Icons.color_lens),
                  ),
                  textChanged: (data) {
                    _formData['color'] = data;
                  },
                  clearOnSubmit: false,
                  textSubmitted: (data) {
                    _formData['color'] = data;
                    // _onSubmit();
                  },
                  key: _keySimpleAutoComplete,
                  suggestions: [
                    "Blue",
                    "Green",
                    "Red",
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                loadingSubmit == Loading.loading
                    ? Container(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        alignment: Alignment.center,
                        child: FlatButton.icon(
                          color: Theme.of(context).primaryColor,
                          onPressed: _onSubmit,
                          icon: Icon(
                            Icons.save,
                            color: Colors.white,
                          ),
                          label: Text(
                            "Save",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                SizedBox(
                  height: 15,
                ),
                errorMessageSubmit == null
                    ? Container()
                    : ErrorMessage(msgError: errorMessageSubmit)
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print("ItemDetail build");
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == null ? "Add Item" : "Update Item"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.save,
            ),
            // disabledColor: Colors.red,
            onPressed: loading == Loading.loading ? null : _onSubmit,
          )
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            // if (Modular.to.canPop()) {
            //   print("CanPop");
            //   Modular.to.pop();
            // } else
            Modular.to.pushNamedAndRemoveUntil(
                AppRoutes.ITEMS, ModalRoute.withName("/"));
          },
        ),
      ),
      body: Container(
        child: _buildBody(),
      ),
    );
  }
}
