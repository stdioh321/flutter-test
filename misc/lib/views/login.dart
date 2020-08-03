import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:misc/providers/auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  GlobalKey<FormState> _form = GlobalKey();

  Map<String, dynamic> user = Map();
  TextEditingController txtUserCtrl = TextEditingController(),
      txtPassCtrl = TextEditingController();
  FocusNode _passFocus = FocusNode();
  bool loading = false;
  // final storage = new FlutterSecureStorage();

  AuthProvider auth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOk();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    // Future.delayed(Duration(seconds: 3), () {
    print("didChangeDependencies");
    auth = Provider.of<AuthProvider>(context);

    auth = Provider.of<AuthProvider>(context);
    // });
  }

  void getOk() async {
    Response resp = await get("http://localhost:8000");
    print(resp.body);
    // return resp.body;
  }

  doSomethin() async {
    await auth.doSomething();
    print("doSomethin LOCAL");
  }

  Future<Response> doLogin() async {
    Response resp = await post('http://localhost:8000/api/login', body: user);
    return resp;
  }

  void onSaved(String val) {
    print(val);
  }

  onSubmitForm() async {
    try {
      if (_form.currentState.validate() && loading == false) {
        setState(() {
          loading = true;
        });
        print("Valid");
        _form.currentState.save();
        print("After Save");
        var result = await doLogin();
        // print(jsonDecode(result.body)['user']['email']);
        await Future.delayed(Duration(seconds: 3));
        if (result.statusCode == 200) {
          await auth.prefs.setString('login', result.body);
          print(jsonDecode(result.body)['token']);
          // auth.token =res
          // await storage.write(key: "login", value: result.body);
        }
        // _form.currentState.deactivate();
      } else {
        print("Invalid");
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Container(
        padding: EdgeInsets.only(
          left: 15,
          right: 15,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: auth.myList
                    .map((e) => Container(
                          child: Text(e),
                        ))
                    .toList(),
              ),
              Container(
                alignment: Alignment.center,
                child: Image.network(
                  "https://picsum.photos/110/110",
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Form(
                  key: _form,
                  // autovalidate: ,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: txtUserCtrl,
                          focusNode: FocusNode(),
                          onSaved: (String v) {
                            user['username'] = v;
                            print("onSave: ${txtUserCtrl.text}");
                          },
                          onEditingComplete: () {
                            print('onEditingComplete');
                          },
                          onFieldSubmitted: (String v) {
                            FocusScope.of(context).requestFocus(_passFocus);
                          },
                          validator: (String v) {
                            if (v == null || v.length < 3)
                              return "This field needs at least 3 characters.";
                            return null;
                          },
                          decoration: InputDecoration(
                              // errorText: "Username error",
                              labelText: "Username",
                              icon: Icon(
                                Icons.person,
                              )),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          controller: txtPassCtrl,
                          focusNode: _passFocus,
                          onSaved: (String v) {
                            user['password'] = v;
                          },
                          validator: (String v) {
                            if (v == null || v.length < 3)
                              return "This field needs at least 3 characters.";
                            return null;
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                              // errorText: "Password error",
                              labelText: "Password",
                              icon: Icon(
                                Icons.vpn_key,
                              )),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: 150,
                          child: loading == true
                              ? CircularProgressIndicator()
                              : FlatButton.icon(
                                  // padding: EdgeInsets.all(15),
                                  textColor: Colors.white,
                                  icon: Icon(Icons.person),
                                  label: Text(
                                    "Login",
                                    style: TextStyle(
                                        // fontSize: 25,
                                        ),
                                  ),
                                  color: Theme.of(context).primaryColor,
                                  onPressed: onSubmitForm,
                                ),
                        )
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            auth.addToList(txt: "aaa");
          }),
    );
  }
}
