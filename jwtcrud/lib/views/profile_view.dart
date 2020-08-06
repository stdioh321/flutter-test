import 'dart:convert';
import 'dart:math';
// import 'dart:html' as html;
// import 'package:file_picker_web/file_picker_web.dart' as fileWeb;
import 'package:file_picker/file_picker.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:http/http.dart';
import 'package:jwtcrud/components/custom_drawer.dart';
import 'package:jwtcrud/components/error_message.dart';
import 'package:jwtcrud/exceptions/custom_exception.dart';
import 'package:jwtcrud/models/user.dart';
import 'package:jwtcrud/routes/app_routes.dart';
import 'package:jwtcrud/services/api.dart';
import 'package:jwtcrud/services/auth_service.dart';
import 'package:jwtcrud/services/enums.dart';
import 'package:jwtcrud/services/utils.dart';

class ProfileView extends StatefulWidget {
  bool isUpdate;
  ProfileView([this.isUpdate = false]);
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  Loading loading = Loading.blank;
  Loading loadingSubmit = Loading.blank;
  String errorMsg;
  String errorMsgSubmit;
  var _form = GlobalKey<FormState>();
  var _formData = Map<String, dynamic>();
  String imageName;
  var birthdateCtrl = TextEditingController();
  @override
  initState() {
    super.initState();
    if (widget.isUpdate == true) {
      _loadData();
    } else {
      loading = Loading.ok;
    }
  }

  _loadData() async {
    try {
      if (loading == Loading.loading) return;
      loading = Loading.loading;
      errorMsg = null;
      setState(() {});

      Response resp = await Api.getInstance().getMe();
      if (resp.statusCode == 200) {
        var tmp = jsonDecode(resp.body);
        User user = User.fromJson(tmp);
        user.token = AuthService.instance.getToken();
        loading = Loading.ok;
        // print(user.toJson());
        _formData = user.toJson();
        birthdateCtrl.text = user.birthdate;
      } else if (resp.statusCode == 401) {
        throw CustomException("Unauthorized", "401");
      } else if (resp.statusCode == 500) {
        throw CustomException("Unauthorized", "500");
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

  _onSubmit([String str]) async {
    try {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusScope.of(context).requestFocus(FocusNode()); //remove focus
      // WidgetsBinding.instance.addPostFrameCallback(
      //     (_) => _textEditingController.clear()); // clear content
      if (_form.currentState.validate()) {
        if (loadingSubmit == Loading.loading) return;
        loadingSubmit = Loading.loading;
        errorMsgSubmit = null;
        _form.currentState.save();
        setState(() {});

        Map<String, dynamic> fData = {};
        fData['name'] = _formData['name'];
        fData['user'] = _formData['user'];
        fData['email'] = _formData['email'];
        fData['password'] = _formData['password'];
        fData['birthdate'] = _formData['birthdate'];
        if (_formData['image'] != null && imageName != null) {
          fData['image'] = _formData['image'];
          fData['image_name'] = imageName;
        }
        // print(fData);
        fData.removeWhere((key, value) => value == null);
        var sR = await Api.getInstance().putUser(fData, !widget.isUpdate);
        if (sR.statusCode == 200) {
          if (widget.isUpdate == false) {
            Utils.instance.displayToast("User Added");
            // showToast(
            //   "User added",
            //   context: context,
            //   backgroundColor: Colors.green,
            // );
            await Modular.to.pushReplacementNamed(AppRoutes.LOGIN);

            return;
          }
          var tmp = await sR.stream.bytesToString();
          // print(tmp);
          User user = User.fromJson(jsonDecode(tmp));
          user.token = AuthService.instance.getToken();
          if (user.image != null)
            user.image += "?r=" + "${Random().nextInt(10000)}";
          await AuthService.instance.setUser(user);
          loadingSubmit = Loading.ok;
          Utils.instance.displayToast("User Updated");
          // showToast(
          //   "User update",
          //   context: context,
          //   backgroundColor: Colors.green,
          // );
        } else if (sR.statusCode == 422) {
          var tmp = jsonDecode(await sR.stream.bytesToString());
          // print(tmp);

          if (tmp['errors'] != null &&
              tmp['errors']['user'] != null &&
              tmp['errors']['user']['Unique'] != null) {
            throw CustomException("Username already in use", "422");
          } else if (tmp['errors'] != null &&
              tmp['errors']['email'] != null &&
              tmp['errors']['email']['Unique'] != null) {
            throw CustomException("Email already in use", "422");
          }

          throw CustomException("Field Validation", "422");
        } else if (sR.statusCode == 500) {
          throw CustomException("Server error", "500");
        } else {
          throw Exception("Unknow error");
        }
      }
    } on CustomException catch (e) {
      errorMsgSubmit = e.message;
      loadingSubmit = Loading.error;
    } catch (e) {
      errorMsgSubmit = "Unknow error";
      loadingSubmit = Loading.error;
    }
    setState(() {});
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
      return SingleChildScrollView(
        child: Form(
            key: _form,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: "Name"),
                  initialValue: _formData["name"],
                  onSaved: (v) => _formData["name"] = v,
                  onFieldSubmitted: _onSubmit,
                  validator: (v) {
                    if (v == null || v.length < 2) {
                      return "Need at least 2 characters.";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Email"),
                  initialValue: _formData["email"],
                  onSaved: (v) => _formData["email"] = v,
                  onFieldSubmitted: _onSubmit,
                  validator: (String value) {
                    Pattern pattern =
                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                    RegExp regex = new RegExp(pattern);
                    if (!regex.hasMatch(value))
                      return 'Enter Valid Email';
                    else
                      return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Username"),
                  initialValue: _formData["user"],
                  onSaved: (v) => _formData["user"] = v,
                  onFieldSubmitted: _onSubmit,
                  validator: (String value) {
                    if (value == null || value.length < 2)
                      return "Need at least 2 characters.";
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Password"),
                  onSaved: (v) => _formData["password"] = v,
                  obscureText: true,
                  onFieldSubmitted: _onSubmit,
                  validator: (String value) {
                    if (widget.isUpdate == false &&
                        (value == null || value.length < 5)) {
                      return "Needs at least 5 characters.";
                    }
                    if (value == null || value.length == 0)
                      return null;
                    else if (value != null && value.length < 5)
                      return "Needs at least 5 characters.";
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  readOnly: true,
                  controller: birthdateCtrl,
                  onSaved: (v) => _formData['birthdate'] = v,
                  validator: (value) {
                    if (widget.isUpdate == false && value == null ||
                        value.length < 1) {
                      return "*Required";
                    }
                    return null;
                  },
                  // initialValue: _formData['birthdate'] == null ? null : "1",
                  decoration: InputDecoration(
                    labelText: "Birthdate",
                  ),
                  onTap: () async {
                    var currDate = _formData['birthdate'] == null
                        ? DateTime.now()
                        : DateTime.parse(_formData['birthdate']);
                    var d = await showDatePicker(
                        context: context,
                        initialDate: currDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now());
                    // print(d);
                    setState(() {
                      if (d != null) {
                        // String day = "${d.day}".padLeft(2, "0");
                        // String month = "${d.month}".padLeft(2, "0");
                        // String year = "${d.year}";
                        // birthdateCtrl.text = "$day-$month-$year";
                        birthdateCtrl.text = d.toString();
                      } else
                        birthdateCtrl.text = "";
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    RaisedButton(
                      onPressed: () async {
                        // _startFilePicker();

                        try {
                          if (kIsWeb) {
                            // var imageWeb = await fileWeb.FilePicker.getFile(
                            //     type: FileType.image);
                            // imageName = imageWeb.name;
                            // html.FileReader fReader = html.FileReader();
                            // fReader.onLoadEnd.listen((event) {
                            //   _formData['image'] = fReader.result;
                            //   // imageName = imageWeb.name;
                            // });
                            // var blob = imageWeb.slice();

                            // fReader.readAsArrayBuffer(blob);
                          } else {
                            var f =
                                await FilePicker.getFile(type: FileType.image);
                            _formData['image'] = f.readAsBytesSync();
                            // print(_formData['image']);
                            imageName = f.path.split('/').last;
                            // print(imageName);
                          }
                        } catch (e) {
                          imageName = null;
                          _formData['image'] = null;
                        }
                        setState(() {});
                      },
                      child: Text(
                        imageName == null ? "Pick Image" : "Change Image",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    imageName == null
                        ? Container()
                        : IconButton(
                            icon: Icon(
                              Icons.remove_circle_outline,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              setState(() {
                                imageName = null;
                                _formData['image'] = null;
                              });
                            },
                          )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                errorMsgSubmit == null
                    ? Container()
                    : ErrorMessage(msgError: errorMsgSubmit),
              ],
            )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: widget.isUpdate == true ? CustomDrawer() : null,
      appBar: AppBar(
        title: Text(
          "Profile",
        ),
        leading: widget.isUpdate == true
            ? null
            : IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () async {
                  await Modular.to.pushReplacementNamed(AppRoutes.LOGIN);
                }),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: _buildBody(),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _onSubmit();
          },
          child: loadingSubmit == Loading.loading
              ? CircularProgressIndicator(
                  backgroundColor: Colors.white,
                )
              : Icon(
                  Icons.save,
                )),
    );
  }
}
