import 'package:firebase_auth/firebase_auth.dart';

class UserRepository{
  final user = FirebaseAuth.instance.currentUser!;

  Future setDisplayName(String name)async{
    await user.updateDisplayName(name);
  }
  String getDisplayName(){
    if(user != null){
      return user.displayName.toString();
    }else{
      return '';
    }
  }
}