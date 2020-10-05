import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static GoogleSignIn googleSignIn = GoogleSignIn();
 
 /// Method for signIn with Google
  // ignore: missing_return
  static Future<FirebaseUser> signInGoogle() async {
    try {
      GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn().catchError((error) => print(error));
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      FirebaseUser user = (await auth.signInWithCredential(credential)).user;

      return (googleSignInAccount == null) ? null : user;
    } catch (e) {
      print(e.toString());
    }
  }

/// method for signOut with Google
  static Future<void> signOutGoogle() async {
    googleSignIn.signOut();
  }

  // static Future<FirebaseUser> signInAnonymouse() async {
  //   try {
  //     AuthResult result = await auth.signInAnonymously();
  //     FirebaseUser user = result.user;
  //     return user;
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  // static Future<FirebaseUser> signUpEmail(String email, String password) async {
  //   try {
  //     AuthResult result = await auth.createUserWithEmailAndPassword(
  //         email: email, password: password);
  //     FirebaseUser user = result.user;
  //     return user;
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  // static Future<FirebaseUser> signInEmail(String email, String password) async {
  //   try {
  //     AuthResult result = await auth.signInWithEmailAndPassword(
  //         email: email, password: password);
  //     FirebaseUser user = result.user;

  //     if (user.isEmailVerified) {
  //       return user;
  //     }
  //     return null;
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }


/// method for signOut from firebase auth
  static Future<void> signOut() async {
    auth.signOut();
  }

/// getter firebase user
  static Stream<FirebaseUser> get firebaseUserStream => auth.onAuthStateChanged;
}
