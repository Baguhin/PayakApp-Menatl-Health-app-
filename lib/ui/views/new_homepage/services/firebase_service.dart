import 'package:firebase_auth/firebase_auth.dart';

import 'package:tangullo/ui/views/new_homepage/services/user_model.dart';
import 'package:tangullo/ui/views/new_homepage/utils/google_sign_button.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    buttonText: '',
  );

  FirebaseService();

  Future<UserModel> getUser() async {
    var firebaseUser = _auth.currentUser!;
    return UserModel(firebaseUser.uid, displayName: firebaseUser.email!);
  }

  Future<UserModel> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    var authresult = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    return UserModel(authresult.user!.uid,
        displayName: authresult.user!.displayName.toString());
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
