import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuth {
  static GoogleAuth _instance;
  GoogleSignIn googleSignIn = GoogleSignIn();
  GoogleSignInAccount account;

  static GoogleAuth get instance {
    if (_instance == null) _instance = GoogleAuth();
    return _instance;
  }

  Future<GoogleSignInAccount> handleSignIn() async {
    try {
      account = await googleSignIn.signIn();
    } catch (e) {
      account = null;
      print(e);
    }
    return account;
  }

  handleSignOut() async {
    try {
      await googleSignIn.signOut();
    } catch (e) {
      print(e);
    }
    account = null;
  }

  bool isLogged() {
    return account == null ? false : true;
  }
}
