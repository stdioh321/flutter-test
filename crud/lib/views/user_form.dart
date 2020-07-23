import 'dart:js_util';

import 'package:crud/models/user.dart';
import 'package:crud/provider/users.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserForm extends StatefulWidget {
  final _form = GlobalKey<FormState>();
  final Map<String, String> _formData = {};

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  void _loadUser(User user) {
    if (user == null) return;
    widget._formData['name'] = user.name;
    widget._formData['id'] = user.id;
    widget._formData['email'] = user.email;
    widget._formData['url'] = user.avatarUrl;
  }

  @override
  Widget build(BuildContext context) {
    User user = ModalRoute.of(context).settings.arguments;
    _loadUser(user);
    return Scaffold(
      appBar: AppBar(
        title: user != null
            ? Text(
                'Editing User',
              )
            : Text(
                'Adding User',
              ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.save,
            ),
            onPressed: () {
              bool isValid = widget._form.currentState.validate();
              if (isValid) {
                widget._form.currentState.save();
                User u = User(
                  id: widget._formData['id'],
                  name: widget._formData['name'],
                  email: widget._formData['email'],
                  avatarUrl: widget._formData['url'],
                );
                Users users = Provider.of(context, listen: false);
                users.put(u);
                Navigator.pop(context);
                // print(widget._formData);

                // widget._form.currentState.;
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(
          15,
        ),
        child: Form(
          key: widget._form,
          child: Column(
            children: [
              TextFormField(
                initialValue: widget._formData['name'],
                decoration: InputDecoration(
                  labelText: "Nome",
                ),
                onSaved: (v) => widget._formData['name'] = v,
                validator: (String v) {
                  if (v == null || v.trim().isEmpty)
                    return "Necessario algum valor.";
                },
                // onChanged: (value) {
                //   .
                // },
              ),
              TextFormField(
                initialValue: widget._formData['email'],
                decoration: InputDecoration(
                  labelText: "Email",
                ),
                onSaved: (v) => widget._formData['email'] = v,
                validator: (String v) {
                  if (v == null || v.trim().isEmpty)
                    return "Necessario algum valor.";
                },
              ),
              TextFormField(
                initialValue: widget._formData['url'],
                decoration: InputDecoration(
                  labelText: "URL Avatar",
                ),
                onSaved: (v) => widget._formData['url'] = v,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
