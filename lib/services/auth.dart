import 'package:firebase_auth/firebase_auth.dart';
import 'package:jasaharum/models/user.dart';

var uidku;
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  //Create user obj based on FirebaseUser
  User _userFromFirebaseUser(
    FirebaseUser user,
  ) {
    return user != null ? User(uid: user.uid) : null;
  }

  //auth change user streams
  Stream<User> get user {
    return _auth.onAuthStateChanged
      .map(_userFromFirebaseUser);
  }

  //Sign In Aplikasi
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      uidku = user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print('Penyebab Error : ' + e.toString());
      return null;
    }
  }

  //Sign Out Aplikasi
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }
  
}
