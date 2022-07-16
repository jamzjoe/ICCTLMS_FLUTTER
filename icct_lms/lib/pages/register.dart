import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  String name = '';
  String email = '';
  String password = '';

  void backToLogin(){
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController.addListener(() => setState(() {}));
    nameController.addListener(() => setState(() {}));
    passwordController.addListener(() => setState(() {}));
  }

  Map data = {};
  bool isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Image(
                      image: AssetImage('assets/logo_black_text.png'),
                      width: 250,
                    ),
                    const SizedBox(height: 10,),
                    Text('${data['user_type']} Register', style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w700
                    ),),
                    const Text("*Please make sure you input a correct data.",
                      style: TextStyle(
                          fontWeight: FontWeight.w300
                      ),),
                    const SizedBox(
                      height: 50,
                    ),
                    TextField(
                      onChanged: (value) => setState(() {
                        name = value;
                      }),
                      decoration: InputDecoration(
                        label: const Text('Username'),
                        hintText: 'Juan Dela Cruz',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.person),
                        suffixIcon: nameController.text.isEmpty
                            ? Container(
                          width: 0,
                        )
                            : IconButton(
                            onPressed: () => nameController.clear(),
                            icon: const Icon(Icons.close)),
                      ),
                      controller: nameController,
                      keyboardType: TextInputType.name,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                    child: TextField(
                      onChanged: (value) => setState(() {
                        email = value;
                      }),
                      decoration: InputDecoration(
                        label: const Text('Email address'),
                        hintText: 'email@example.com',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.mail),
                        suffixIcon: emailController.text.isEmpty
                            ? Container(
                          width: 0,
                        )
                            : IconButton(
                            onPressed: () => emailController.clear(),
                            icon: const Icon(Icons.close)),
                      ),
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                    )),
                const SizedBox(
                  height: 10,
                ),
                Center(
                    child: TextField(
                      onChanged: (value) => setState(() {
                        password = value;
                      }),
                      decoration: InputDecoration(
                        label: const Text('Password'),
                        hintText: '123456',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.password),
                        suffixIcon: IconButton(
                          icon: isPasswordVisible
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: isPasswordVisible,
                      controller: passwordController,
                    )),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Center(
                      child: ElevatedButton.icon(
                          onPressed: () {
                            // validateAccount();
                          },
                          icon: const Icon(Icons.send),
                          label: const Text('Register Account')),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 110,
                ),
                SizedBox(
                  width: 180,
                  child: ElevatedButton.icon(
                      onPressed: () {
                        backToLogin();
                      },
                      icon: const Icon(Icons.account_circle),
                      label: const Text('Back to Login')),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
