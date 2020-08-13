import 'package:boilerplate/services/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginGoogleView extends StatefulWidget {
  @override
  _LoginGoogleViewState createState() => _LoginGoogleViewState();
}

class _LoginGoogleViewState extends State<LoginGoogleView> {
  bool isLogged = false;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  GoogleSignInAccount googleSignInAccount;
  GoogleSignInAuthentication googleSignInAuthentication;
  @override
  initState() {
    super.initState();
    _checkLogged();
  }

  _checkLogged() async {
    try {
      isLogged = await googleSignIn.isSignedIn();
      if (isLogged == true) await signInWithGoogle();
    } catch (e) {
      isLogged = false;

      if (e.code == "network_error") {
        Utils.instance.defaultToast("NetWork Error", bg: Colors.red);
      } else
        Utils.instance.defaultToast("Error");
    }
    setState(() {});
  }

  Widget _buildBody() {
    if (isLogged == false || googleSignInAccount == null) {
      return Column(
        children: [
          Container(),
          RaisedButton.icon(
            onPressed: () {
              signInWithGoogle();
            },
            color: Colors.blue,
            padding: EdgeInsets.all(15),
            icon: Icon(
              Icons.assignment_ind,
              color: Colors.white,
            ),
            label: Text(
              "Sign In with Google",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Container(),
          CircleAvatar(
            radius: 55,
            backgroundColor: Colors.purple,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                googleSignInAccount.photoUrl,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Text(googleSignInAccount.displayName),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Text(googleSignInAccount.email),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Text(googleSignInAccount.id),
          ),
          SizedBox(
            height: 40,
          ),
          RaisedButton.icon(
            onPressed: () {
              signOutGoogle();
            },
            padding: EdgeInsets.all(15),
            color: Colors.red,
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            label: Text(
              "Sign Out Google",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    }
  }

  Future<String> signInWithGoogle() async {
    try {
      googleSignInAccount = await googleSignIn.signIn();
      googleSignInAuthentication = await googleSignInAccount.authentication;
      print("-------------- User Sign In --------------");
      print(googleSignInAccount);
      print(googleSignInAuthentication);
      print("------------------------------------------");
      isLogged = true;
    } catch (e) {
      if (e.code == "network_error") {
        Utils.instance.defaultToast("NetWork Error", bg: Colors.red);
      } else
        Utils.instance.defaultToast("Error");
    }
    setState(() {});
  }

  void signOutGoogle() async {
    try {
      await googleSignIn.signOut();
      googleSignInAccount = null;
      googleSignInAuthentication = null;
      isLogged = false;
      print("-------------- User Sign Out --------------");
    } catch (e) {
      if (e.code == "network_error") {
        Utils.instance.defaultToast(
          "NetWork Error",
          bg: Colors.red,
        );
      } else
        Utils.instance.defaultToast("Error");
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Google"),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: _buildBody(),
      ),
    );
  }
}
