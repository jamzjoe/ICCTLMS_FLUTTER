import 'package:flutter/material.dart';
import 'package:icct_lms/authentication/authenticate.dart';
import 'package:icct_lms/models/user_model.dart';
import 'package:icct_lms/pages/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserModel?>(context);

    if(user == null){
      return const Authenticate();
    }else{
      return const Home();
    }
  }
}
