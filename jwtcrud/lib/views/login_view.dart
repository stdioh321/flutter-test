import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:jwtcrud/components/error_message.dart';
import 'package:jwtcrud/exceptions/custom_exception.dart';
import 'package:jwtcrud/models/user.dart';
import 'package:jwtcrud/providers/auth_provider.dart';
import 'package:jwtcrud/routes/app_routes.dart';
import 'package:jwtcrud/services/api.dart';
import 'package:jwtcrud/services/auth_service.dart';
import 'package:jwtcrud/services/enums.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  AuthProvider auth;
  GlobalKey<FormState> _form;
  Map<String, String> credentials;
  Loading loading;
  String msgError;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _form = GlobalKey();
    credentials = Map();
    loading = Loading.blank;
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    auth = Provider.of<AuthProvider>(context);
    // print(auth.getUser());
    // auth.log(txt: "adskjfkljasdjf");
  }

  void onSubmit() async {
    try {
      msgError = null;
      if (_form.currentState.validate()) {
        if (loading == Loading.loading) return;
        loading = Loading.loading;
        auth.notifyListeners();
        _form.currentState.save();
        Response resp = await Api.getInstance().postLogin(
            username: credentials["username"],
            password: credentials["password"]);
        loading = Loading.ok;
        auth.notifyListeners();
        if (resp.statusCode == 200) {
          var tmp = jsonDecode(resp.body);
          var mapUser = tmp['user'];
          mapUser['token'] = tmp['token'];
          User user = User.fromJson(mapUser);
          await AuthService.instance.setUser(user);
          // print("DONE");
          Navigator.of(context).pushReplacementNamed(AppRoutes.ITEMS_LIST);
        } else if (resp.statusCode == 401) {
          throw CustomException("Unauthorized", "401");
        } else if (resp.statusCode == 422) {
          throw CustomException("Fields Validation", "422");
        } else if (resp.statusCode == 500) {
          throw CustomException("Server Error", "500");
        } else {
          throw Exception("Unknow Error");
        }
      }
    } on CustomException catch (e) {
      await auth.setUser(null);
      msgError = e.message;
    } catch (e) {
      await auth.setUser(null);
      msgError = "Unknow Error";
      print(e);
    } finally {
      // Future.delayed(Duration(seconds: 1), () {
      loading = Loading.error;
      auth.notifyListeners();
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(
            15,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  "https://borlabs.io/wp-content/uploads/2019/09/blog-wp-login.png",
                  fit: BoxFit.contain,
                  width: 300,
                ),
                SizedBox(
                  height: 20,
                ),
                Form(
                    key: _form,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(labelText: "Username"),
                          validator: (value) {
                            if (value == null || value.length < 3)
                              return "The value must have at least 3 characters.";
                            return null;
                          },
                          onSaved: (v) => credentials['username'] = v,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(labelText: "Password"),
                          validator: (value) {
                            if (value == null || value.length < 3)
                              return "The value must have at least 3 characters.";
                            return null;
                          },
                          onSaved: (v) => credentials['password'] = v,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // ButtonIcon
                        Container(
                            child: loading == Loading.loading
                                ? CircularProgressIndicator()
                                : FlatButton(
                                    onPressed: onSubmit,
                                    child: Text("Login"),
                                  )),
                        Container(
                          alignment: Alignment.center,
                          child: msgError == null
                              ? null
                              : ErrorMessage(msgError: msgError),
                        )
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
