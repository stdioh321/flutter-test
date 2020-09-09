import 'package:boilerplate/models/todoa.dart';
import 'package:boilerplate/services/google_auth.dart';
import 'package:boilerplate/services/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:load/load.dart';

class TodoFirebaseAuthView extends StatefulWidget {
  @override
  _TodoFirebaseAuthViewState createState() => _TodoFirebaseAuthViewState();
}

class _TodoFirebaseAuthViewState extends State<TodoFirebaseAuthView> {
  List<TodoA> todos = [];
  bool _loading = false;
  var _form = GlobalKey<FormState>();
  var _txtCtrl = TextEditingController();
  var _scaffCtrl = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  initState() {
    super.initState();
    _loadAll();
  }

  bool get loading {
    return _loading;
  }

  set loading(bool status) {
    if (status == true) {
      showLoadingDialog();
      _loading = true;
    } else {
      hideLoadingDialog();
      _loading = false;
    }
  }

  _loadAll() async {
    try {
      await _handleSignIn();
      await _loadTodos();
    } catch (e) {
      print(e);
    }
    setState(() {});
  }

  _handleSignIn() async {
    try {
      if (loading == true) return;
      loading = true;
      await GoogleAuth.instance.handleSignIn();
      var cred = await GoogleAuth.instance.account.authentication;
      var gProv = GoogleAuthProvider.getCredential(
          idToken: cred.idToken, accessToken: cred.accessToken);
      var tmp = await _auth.signInWithCredential(gProv);

      //     token:
      //         (await GoogleAuth.instance.account.authentication).accessToken);
      print(tmp.user.email);
    } catch (e) {
      print(e);
    }
    loading = false;
    setState(() {});
  }

  _handleSignOut() async {
    try {
      if (loading == true) return;
      loading = true;
      await GoogleAuth.instance.handleSignOut();
      await _auth.signOut();
    } catch (e) {
      print(e);
    }
    todos = [];
    loading = false;
    setState(() {});
  }

  _loadTodos() async {
    if (loading == true) return;
    loading = true;
    todos = [];
    try {
      String id = GoogleAuth.instance.account.id;
      var snap = await Firestore.instance
          .collection("todos/" + id + "/todos")
          .orderBy('created_at')
          .getDocuments();
      todos = snap.documents.map((e) {
        var tmp = TodoA.fromJson(e.data);
        tmp.id = e.documentID;
        return tmp;
      }).toList();
    } catch (e) {
      Utils.instance.defaultToast("Error Loading Todos", bg: Colors.red);
    }
    loading = false;
  }

  Future<bool> _putTodo(TodoA todo) async {
    if (loading == true) return null;
    loading = true;

    try {
      var json = todo.toJson();
      String id = GoogleAuth.instance.account.id;
      if (todo.id != null) {
        // todo = todo.
        // todo.
        // todo.done = todo.done == true ? false : true;
        print(todo.id);
        var doc = await Firestore.instance
            .collection("todos/" + id + "/todos")
            .document(todo.id);
        var json = todo.toJson();

        json['updated_at'] = FieldValue.serverTimestamp();
        json.remove("id");

        await doc.updateData(json);
        var tmpTodo = (await doc.get()).data;
        tmpTodo['id'] = doc.documentID;
        todo = todo.fromJson(tmpTodo);
      } else {
        json['created_at'] = FieldValue.serverTimestamp();
        json['updated_at'] = json['created_at'];
        json['done'] = false;
        json.remove('id');
        var doc = await Firestore.instance
            .collection("todos/" + id + "/todos")
            .add(json);
        if (doc != null) {
          var tmp = TodoA.fromJson((await doc.get()).data);
          tmp.id = doc.documentID;
          todos.add(tmp);
          _txtCtrl.clear();
        }
      }
      loading = false;
      setState(() {});
      return true;
    } catch (e) {
      print(e);
      Utils.instance.defaultToast("Error Putting Todo", bg: Colors.red);
      loading = false;
      setState(() {});
      return false;
    }
  }

  _deleteTodo(TodoA todo) async {
    if (loading == true) return;
    loading = true;
    try {
      String id = GoogleAuth.instance.account.id;
      var doc = await Firestore.instance
          .collection("todos/" + id + "/todos")
          .document(todo.id)
          .delete();
      todos.removeWhere((element) => todo == element);
    } catch (e) {
      Utils.instance.defaultToast("Error Deleting Todos", bg: Colors.red);
    }
    loading = false;
    setState(() {});
  }

  _buildBody() {
    if (GoogleAuth.instance.account == null) {
      return Center(
        child: RaisedButton.icon(
            onPressed: () async {
              await _loadAll();
            },
            icon: Icon(
              Icons.person,
              color: Colors.white,
            ),
            color: Colors.blue,
            label: Text(
              "Sign In",
              style: TextStyle(color: Colors.white, fontSize: 30),
            )),
      );
    } else {
      return Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
            child: Form(
              key: _form,
              child: TextFormField(
                // minLines: 2,
                // maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return "Must have a content";
                  return null;
                },
                controller: _txtCtrl,
                onEditingComplete: () async {
                  if (_form.currentState.validate() == true) {
                    Utils.instance.removeFocus(context);
                    await _putTodo(TodoA(todo: _txtCtrl.text));
                  }
                },
                decoration: InputDecoration(
                  labelText: "Todo",
                ),
              ),
            ),
          ),
          Expanded(
            child: todos.length == 0
                ? Center(
                    child: Text("Empty"),
                  )
                : ListView(
                    children: todos.map((e) {
                      return Dismissible(
                        key: Key(e.id),
                        background: Container(
                          color: Colors.red,
                        ),
                        onDismissed: (v) async {
                          await _deleteTodo(e);
                          _scaffCtrl.currentState.showSnackBar(SnackBar(
                            content: Text("Todo removed"),
                          ));
                        },
                        child: ListTile(
                          title: Text(e.todo),
                          subtitle: Text(e.updatedAt.toDate().toString()),
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              e.done == true
                                  ? Icon(
                                      Icons.done,
                                      color: Colors.green,
                                    )
                                  : Icon(Icons.assignment)
                            ],
                          ),
                          onTap: () {
                            var _tmpTxtCtrl =
                                TextEditingController(text: e.todo);
                            var _tmpForm = GlobalKey<FormState>();
                            var _tmpFocus = FocusNode();
                            _tmpFocus.requestFocus();
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Edit"),
                                  content: Container(
                                    child: Form(
                                      key: _tmpForm,
                                      child: TextFormField(
                                        focusNode: _tmpFocus,
                                        controller: _tmpTxtCtrl,
                                        // initialValue: e.todo,
                                        decoration: InputDecoration(
                                          labelText: "Todo",
                                        ),
                                        onFieldSubmitted: (value) async {
                                          if (_tmpForm.currentState
                                                  .validate() ==
                                              true) {
                                            Utils.instance.removeFocus(context);
                                            Navigator.of(context).pop();
                                            var tmpTodo =
                                                TodoA.fromJson(e.toJson());
                                            tmpTodo.todo = _tmpTxtCtrl.text;

                                            if ((await _putTodo(tmpTodo)) ==
                                                true) {
                                              e.fromJson(tmpTodo.toJson());
                                            }
                                            setState(() {});
                                          }
                                        },
                                        validator: (v) {
                                          if (v == null || v.isEmpty == true) {
                                            return "Must have a content";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: RaisedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        color: Colors.red,
                                        child: Text(
                                          "Close",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              },
                            );
                          },
                          trailing: Checkbox(
                              value: e.done,
                              onChanged: (v) async {
                                var tmpTodo = TodoA.fromJson(e.toJson());
                                print(tmpTodo.id);
                                tmpTodo.done = v;
                                if ((await _putTodo(tmpTodo)) == true) {
                                  e.fromJson(tmpTodo.toJson());
                                }

                                setState(() {});
                              }),
                        ),
                        // CheckboxListTile(
                        //   title: Text(e.todo),
                        //   subtitle: Text(e.updatedAt.toDate().toString()),
                        //   value: e.done,
                        //   onChanged: (v) async {
                        //     await _putTodo(e);
                        //     setState(() {});
                        //   },
                        // ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffCtrl,
      appBar: AppBar(
        title: GoogleAuth.instance.account == null
            ? Text("Todo Firebase Auth")
            : Text(GoogleAuth.instance.account.displayName),
        actions: GoogleAuth.instance.account == null
            ? []
            : [
                IconButton(
                    icon: Icon(Icons.exit_to_app),
                    onPressed: () async {
                      await _handleSignOut();
                    })
              ],
      ),
      body: LoadingProvider(
        themeData: LoadingThemeData(tapDismiss: false),
        child: _buildBody(),
      ),
    );
  }
}
