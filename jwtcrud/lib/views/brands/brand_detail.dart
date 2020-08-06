import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart';
import 'package:jwtcrud/components/error_message.dart';
import 'package:jwtcrud/exceptions/custom_exception.dart';
import 'package:jwtcrud/models/brand.dart';
import 'package:jwtcrud/routes/app_routes.dart';
import 'package:jwtcrud/services/api.dart';
import 'package:jwtcrud/services/enums.dart';

class BrandDetailView extends StatefulWidget {
  String id;
  BrandDetailView({String this.id});
  @override
  _BrandDetailState createState() => _BrandDetailState();
}

class _BrandDetailState extends State<BrandDetailView> {
  var _form = GlobalKey<FormState>();
  var _formData = Map<String, dynamic>();
  Loading loading = Loading.blank;
  Loading loadingSubmit = Loading.blank;
  String errorMsg;

  @override
  initState() {
    super.initState();
    setState(() {
      _loadData();
    });
  }

  _loadData() async {
    try {
      loading = Loading.loading;
      errorMsg = null;
      setState(() {});
      if (widget.id != null) {
        Response resp = await Api.getInstance().getBrands(widget.id);
        if (resp.statusCode == 200) {
          var tmp = jsonDecode(resp.body);
          var brand = Brand.fromJson(tmp);
          _formData['id'] = widget.id;
          _formData['name'] = brand.name;
        } else if (resp.statusCode == 406) {
          await Modular.to.pushNamedAndRemoveUntil(
              AppRoutes.BRANDS, ModalRoute.withName("/"));
        } else if (resp.statusCode == 500) {
          throw CustomException("Server Error", "500");
        } else {
          throw Exception("Unknow error");
        }
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
      if (loadingSubmit == Loading.loading || loading == Loading.loading)
        return;
      _form.currentState.save();
      setState(() {
        loadingSubmit = Loading.loading;
        errorMsg = null;
      });
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        Response resp =
            await Api.getInstance().puBrand(id: widget.id, data: _formData);
        if (resp.statusCode >= 200 && resp.statusCode <= 299) {
          await Modular.to.pushNamedAndRemoveUntil(
              AppRoutes.BRANDS, ModalRoute.withName("/"));
          loadingSubmit = Loading.ok;
        } else if (resp.statusCode == 400) {
          throw CustomException("Field Validation", "400");
        } else if (resp.statusCode == 409) {
          throw CustomException("Name already in use", "409");
        } else if (resp.statusCode == 500) {
          throw CustomException("Server error", "500");
        } else {
          throw Exception("Unknow error");
        }
      } on CustomException catch (e) {
        errorMsg = e.message;
        loadingSubmit = Loading.error;
      } catch (e) {
        errorMsg = "Unknow error";
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
        child: Text("Error"),
      );
    } else if (loading == Loading.ok) {
      return Container(
        padding: EdgeInsets.all(15),
        child: Form(
          key: _form,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Name"),
                initialValue: _formData['name'],
                onSaved: (v) => _formData['name'] = v,
                onFieldSubmitted: _onSubmit,
                validator: (value) {
                  if (value == null || value.length < 2)
                    return "Need at least 2 characters";
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              errorMsg == null ? Container() : ErrorMessage(msgError: errorMsg),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.id == null ? "Add Brand" : "Update Brand",
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Modular.to.pushNamedAndRemoveUntil(
                AppRoutes.BRANDS, ModalRoute.withName("/"));
          },
        ),
      ),
      body: Container(
        child: _buildBody(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onSubmit,
        // mini: true,

        child: loadingSubmit == Loading.loading
            ? CircularProgressIndicator(
                backgroundColor: Colors.white,
              )
            : Icon(
                Icons.save,
              ),
      ),
    );
  }
}
