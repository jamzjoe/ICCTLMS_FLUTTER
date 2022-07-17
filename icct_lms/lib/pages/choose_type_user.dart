import 'package:flutter/material.dart';

class ChooseUser extends StatefulWidget {
  const ChooseUser({Key? key}) : super(key: key);

  @override
  State<ChooseUser> createState() => _ChooseUserState();
}

String userType = '';

class _ChooseUserState extends State<ChooseUser> {
  void goToLogin(userType) {
    Navigator.pushNamed(context, '/user_login',
        arguments: {'user_type': userType});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Center(
                  child: Image(
                image: AssetImage('assets/logo_black_text.png'),
                width: 250,
              )),
              const Center(
                child: Text(
                  'E-learning Management System',
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 10,
                      letterSpacing: 2),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                width: 150,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(primary: Colors.blue[900]),
                  onPressed: () {
                    goToLogin('Student');
                  },
                  label: const Text('Student'),
                  icon: const Icon(Icons.school),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: 150,
                child: ElevatedButton.icon(
                  onPressed: () {
                    goToLogin('Teacher');
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.blue[900]),
                  label: const Text('Teacher'),
                  icon: const Icon(Icons.person_pin_circle_rounded),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: 150,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(primary: Colors.blue[900]),
                  onPressed: () {
                    goToLogin('Parent');
                  },
                  label: const Text('Parent'),
                  icon: const Icon(Icons.person),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
