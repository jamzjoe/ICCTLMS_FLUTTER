import 'package:flutter/material.dart';
import 'package:icct_lms/pages/choose_type_user.dart';
import 'package:icct_lms/pages/login.dart';
import 'package:icct_lms/pages/register.dart';
import 'package:icct_lms/wrapper/wrapper.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = false;

  void togglePage(){
    setState(() {
      showSignIn = !showSignIn;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showSignIn){
      return Register(togglePage: togglePage);
    }else{
      return Login(usertype: '', togglePage: togglePage);
    }
  }
}
