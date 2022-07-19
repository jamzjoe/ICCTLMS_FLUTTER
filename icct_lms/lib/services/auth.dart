import 'package:firebase_auth/firebase_auth.dart';
import 'package:icct_lms/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object
  UserModel? _userFromFirebaseUser(User user){
    if (user != null) {
      return UserModel(uid: user.uid);
    } else {
      return null;
    }
  }

  //auth change stream
  Stream<UserModel?> get user{
    return _auth.authStateChanges()
        .map((User? user) => _userFromFirebaseUser(user!));
  }
  //sign in anonymously
  Future signInAnonymously() async {
    try{
      UserCredential result =  await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    }catch(error){
      print(error);
      return null;
    }
  }
  //sign in with email and password
  Future registerWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      return _userFromFirebaseUser(user!);
    }catch(e){
      print(e.toString());
      return null;
    }
  }
  //Sign out
  Future signOut() async {
    try{
      return await _auth.signOut();
    }catch(e){
      print('Error Joe'+ e.toString());
    }
  }
}