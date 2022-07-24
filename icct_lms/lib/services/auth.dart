import 'package:firebase_auth/firebase_auth.dart';
import 'package:icct_lms/models/user_model.dart';
import 'package:icct_lms/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String error = '';
  // create user object
  UserModel? _userFromFirebaseUser(User user) {
    if (user != null) {
      return UserModel(uid: user.uid);
    } else {
      return null;
    }
  }

  //auth change stream
  Stream<UserModel?> get user {
    return _auth
        .authStateChanges()
        .map((User? user) => _userFromFirebaseUser(user!));
  }

  //sign in anonymously
  Future signInAnonymously() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } catch (error) {
      return null;
    }
  }

  //Sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      return _userFromFirebaseUser(user!);
    } on FirebaseAuthException catch (e) {
      error = e.message!;
      return null;
    }
  }

  //Register with email and password
  Future registerWithEmailAndPassword(
    String email,
    String password,
    String username,
    String campus,
    String emailAddress,
    String userType,
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      //update user info for new user
      await DatabaseService(uid: user!.uid)
          .updateUserDetails(username, emailAddress, campus, userType);
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      error = e.message.toString();
      return null;
    }
  }

  //Sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      error = e.message.toString();
      return null;
    }
  }

  Future deleteAccount() async {
    final User user = _auth.currentUser!;
    try {
      return await user.delete();
    } on FirebaseAuthException catch (e) {
      error = e.message.toString();
      return null;
    }
  }
}
