import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart';
import 'package:jwtcrud/components/error_message.dart';
import 'package:jwtcrud/exceptions/custom_exception.dart';
import 'package:jwtcrud/models/brand.dart';
import 'package:jwtcrud/models/model.dart';
import 'package:jwtcrud/routes/app_routes.dart';
import 'package:jwtcrud/services/api.dart';
import 'package:jwtcrud/services/enums.dart';

class ModelDetailView extends StatefulWidget {
  String id;
  ModelDetailView([String this.id]);

  @override
  _ModelDetailViewState createState() => _ModelDetailViewState();
}

class _ModelDetailViewState extends State<ModelDetailView> {
  Loading loading = Loading.blank;
  Loading loadingSubmit = Loading.blank;
  String errorMsg;
  String errorMsgSubmit;

  var _form = GlobalKey<FormState>();
  var _formData = Map<String, dynamic>();
  List<Brand> brands = [];

  @override
  initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    if (loading == Loading.loading) return;
    loading = Loading.loading;
    errorMsg = null;
    setState(() {});
    try {
      Response respBrands = await Api.getInstance().getBrands();
      if (respBrands.statusCode >= 200 && respBrands.statusCode <= 299) {
        var tmp = jsonDecode(respBrands.body) as List;
        brands = tmp.map((e) => Brand.fromJson(e)).toList();
      } else if (respBrands.statusCode == 500)
        throw CustomException("Server error", "500");
      else
        throw Exception("Unknow error");

      if (widget.id != null) {
        Response respModel = await Api.getInstance().getModels(widget.id);
        if (respModel.statusCode == 200) {
          var tmpModel = jsonDecode(respModel.body);
          Model m = Model.fromJson(tmpModel);
          _formData['name'] = m.name;
          _formData['id_brand'] = m.idBrand;
        } else if (respModel.statusCode == 406) {
          Modular.to.pushNamedAndRemoveUntil(
              AppRoutes.MODELS, ModalRoute.withName("/"));
        } else if (respModel.statusCode == 500)
          throw CustomException("Server error", "500");
        else
          throw Exception("Unknow error");
      }
      loading = Loading.ok;
    } on CustomException catch (e) {
      errorMsg = e.message;
      loading = Loading.error;
    } catch (e) {
      errorMsg = "Unknow error";
      loading = Loading.error;
    }

    setState(() {});
  }

  _onSubmit([String str]) async {
    if (_form.currentState.validate()) {
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        if (loadingSubmit == Loading.loading) return;
        loadingSubmit = Loading.loading;
        errorMsgSubmit = null;
        _form.currentState.save();
        setState(() {});
        Response resp =
            await Api.getInstance().putModel(id: widget.id, data: _formData);
        if (resp.statusCode == 200) {
          await Modular.to.pushNamedAndRemoveUntil(
              AppRoutes.MODELS, ModalRoute.withName("/"));
          loadingSubmit = Loading.ok;
        } else if (resp.statusCode == 422) {
          throw CustomException("Name already in use", "422");
        } else if (resp.statusCode == 500) {
          throw CustomException("Server error", "500");
        } else
          throw Exception("Unknow Error");
      } on CustomException catch (e) {
        errorMsgSubmit = e.message;
        loadingSubmit = Loading.error;
      } catch (e) {
        errorMsgSubmit = "Unknow Error";
        loadingSubmit = Loading.error;
      }
      setState(() {});
    }
  }

  Widget _buildBody() {
    if (loading == Loading.loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (loading == Loading.error) {
      return Center(
        child: Text(errorMsg),
      );
    } else if (loading == Loading.ok) {
      return Form(
        // autovalidate: true,
        key: _form,
        child: Column(
          children: [
            TextFormField(
              initialValue: _formData['name'],
              onSaved: (v) => _formData['name'] = v,
              onFieldSubmitted: _onSubmit,
              validator: (v) {
                if (v == null || v.length < 2)
                  return "Need at least 2 characters.";
                return null;
              },
              decoration: InputDecoration(
                labelText: "Name",
              ),
            ),
            SizedBox(
              height: 20,
            ),
            DropdownButtonFormField(
                value: _formData['id_brand'],
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
                onSaved: (v) => _formData['id_brand'] = v,
                onChanged: (v) {
                  setState(() {
                    _formData['id_brand'] = v;
                  });
                }),
            SizedBox(
              height: 20,
            ),
            loadingSubmit == Loading.error
                ? ErrorMessage(
                    msgError: errorMsgSubmit,
                  )
                : Container(),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.id == null ? "Add Model" : "Update Model",
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () async {
            await Modular.to.pushNamedAndRemoveUntil(
                AppRoutes.MODELS, ModalRoute.withName("/"));
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: _buildBody(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onSubmit,
        child: loadingSubmit == Loading.loading
            ? CircularProgressIndicator(backgroundColor: Colors.white)
            : Icon(
                Icons.save,
              ),
      ),
    );
  }
}
