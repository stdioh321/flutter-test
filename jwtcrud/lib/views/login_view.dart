import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart';
import 'package:jwtcrud/components/error_message.dart';
import 'package:jwtcrud/exceptions/custom_exception.dart';
import 'package:jwtcrud/models/user.dart';
import 'package:jwtcrud/routes/app_routes.dart';
import 'package:jwtcrud/services/api.dart';
import 'package:jwtcrud/services/auth_service.dart';
import 'package:jwtcrud/services/enums.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  var _formKey = GlobalKey<FormState>();
  var formData = Map<String, String>();
  String errorMsg;
  Loading loadingStatus = Loading.blank;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  _onSubmit() async {
    if (_formKey.currentState.validate()) {
      if (loadingStatus == Loading.loading) return;
      setState(() {
        errorMsg = null;
        loadingStatus = Loading.loading;
      });
      try {
        _formKey.currentState.save();
        // print(formData);
        Response resp = await Api.getInstance().postLogin(
            username: formData['username'], password: formData['password']);

        if (resp.statusCode == 200) {
          var tmp = jsonDecode(resp.body);
          var user = User.fromJson(tmp['user']);
          user.token = tmp['token'];
          await AuthService.instance.setUser(user);
          // print(AuthService.instance.getUser().email);
          Modular.to.pushReplacementNamed(AppRoutes.ITEMS);
          setState(() {
            loadingStatus = Loading.ok;
          });
        } else if (resp.statusCode == 401)
          throw CustomException("User or password wrong", 401.toString(),
              cause: resp.body);
        else if (resp.statusCode == 422)
          throw CustomException("Field validation", 422.toString(),
              cause: resp.body);
        else if (resp.statusCode == 500)
          throw CustomException("Server error", 500.toString(),
              cause: resp.body);
        else
          throw CustomException("Unknow error", "0");
      } on CustomException catch (e) {
        // print(e.cause);
        setState(() {
          errorMsg = e.message;
          loadingStatus = Loading.error;
        });
      } catch (e) {
        setState(() {
          errorMsg = "Unknow Error";
          loadingStatus = Loading.error;
        });
      }
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
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Username",
                    ),
                    onSaved: (v) => formData['username'] = v,
                    onFieldSubmitted: (str) => _onSubmit(),
                    validator: (value) {
                      if (value == null || value.length < 3)
                        return "The field must have at least 3 characters.";
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Password",
                    ),
                    onSaved: (v) => formData['password'] = v,
                    obscureText: true,
                    onFieldSubmitted: (str) => _onSubmit(),
                    validator: (value) {
                      // if (value == null || value.length < 3)
                      //   return "The field must have at least 3 characters.";
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: loadingStatus == Loading.loading
                        ? CircularProgressIndicator()
                        : RaisedButton.icon(
                            onPressed: _onSubmit,
                            icon: Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.all(15),
                            label: Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 26,
                                color: Colors.white,
                              ),
                            )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  errorMsg == null
                      ? Container()
                      : ErrorMessage(
                          msgError: errorMsg,
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
