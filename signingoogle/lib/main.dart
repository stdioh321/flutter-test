import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign In Google',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // MyHomePage({Key key, this.title}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  bool isLogged = true;
  String urlImg;

  @override
  initState() {
    super.initState();
    checkLogged();
  }

  singInWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      print((await googleSignInAccount.authentication).accessToken);
      this.urlImg = googleSignInAccount.photoUrl;
      await checkLogged();
    } catch (e) {
      print(e);
    }
    setState(() {});
  }

  checkLogged() async {
    isLogged = await googleSignIn.isSignedIn();
  }

  singOutWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signOut();
      // await googleSignIn.disconnect();
      print(googleSignInAccount.authentication);

      setState(() {
        isLogged = false;
      });
      print("Sign out $isLogged");
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MyHome"),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Container(),
            urlImg == null
                ? Container()
                : Image.network(
                    urlImg,
                    fit: BoxFit.contain,
                  ),
            RaisedButton.icon(
              onPressed: () {
                singInWithGoogle();
              },
              icon: Icon(Icons.input),
              label: Text(
                "Sign In Google",
              ),
            ),
            SizedBox(
              height: 80,
            ),
            RaisedButton.icon(
              onPressed: () {
                singOutWithGoogle();
              },
              color: Colors.red,
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              label: Text(
                "Sing Out",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
