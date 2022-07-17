import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icct_lms/models/school_list.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final schoolController = TextEditingController();
  String name = '';
  String email = '';
  String password = '';

  void validateAccount() {
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false,
        arguments: {'user_name': name});
  }

  void goToRegister() {
    Navigator.pushNamed(context, '/user_register',
        arguments: {
          'user_type': data['user_type']
        });
  }
  void goToForgotPassword(){
    Navigator.pushNamed(context, '/forgot_password');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    schoolController.addListener(() {
      setState(() {

      });
    });
    emailController.addListener(() => setState(() {}));
    nameController.addListener(() => setState(() {}));
    passwordController.addListener(() => setState(() {}));
  }

  Map data = {};
  bool isPasswordVisible = true;
  List<SchoolList> schools = [
    SchoolList('Cainta Main Campus', 'assets/logo_plain.png'),
    SchoolList('San Mateo Campus', 'assets/logo_plain.png'),
    SchoolList('Sumulong Campus', 'assets/logo_plain.png'),
    SchoolList('Antipolo Campus', 'assets/logo_plain.png'),
    SchoolList('Agono Campus', 'assets/logo_plain.png'),
    SchoolList('Binangonan Campus', 'assets/logo_plain.png'),
    SchoolList('Cogeo Campus', 'assets/logo_plain.png'),
    SchoolList('Taytay Campus', 'assets/logo_plain.png'),
  ];
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
                    Text('${data['user_type']} Login', style: const TextStyle(
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
                    hintText: '******',
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
                )
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                    child: TextField(
                      readOnly: true,
                      controller: schoolController,
                      onTap: (){
                        chooseCampus();
                      },
                      decoration: InputDecoration(
                        label: const Text('Choose Campus'),
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(CupertinoIcons.house_alt_fill),
                        suffixIcon: IconButton(onPressed: (){
                          chooseCampus();
                        }, icon: Icon
                          (Icons.arrow_drop_down_circle))
                      ),
                    )
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Center(
                      child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blue[900]
                          ),
                          onPressed: () {
                            validateAccount();
                          },
                          icon: const Icon(CupertinoIcons.forward),
                          label: const Text('Login Account')),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 110,
                ),
                SizedBox(
                  width: 180,
                  child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blue[900]
                      ),
                      onPressed: () {
                        goToRegister();
                      },
                      icon: const Icon(Icons.account_circle),
                      label: const Text('No account '
                          'yet?')),
                ),
                SizedBox(
                  width: 180,
                  child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red[800]
                      ),
                      onPressed: () {
                        goToForgotPassword();
                      },
                      icon: const Icon(Icons.password_rounded),
                      label: const Text('Forgot password?')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void chooseCampus() {
    showModalBottomSheet(context: context, builder:
    (context)  => buildSheet()
    );
  }

  Widget buildSheet() => ListView(
    children: [
      Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Text('Choose Campus', style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold
            ),
            ),
            SizedBox(height: 20,),
            Column(
              children: schools.map((e) => newSchools(school: e)).toList(),
            ),
          ],
        ),
      )
    ],
  );

  Widget newSchools({required SchoolList school}) => ListTile(
    contentPadding: EdgeInsets.all(2),
    selectedTileColor: Colors.white24,
    onTap: (){
      Navigator.pop(context);
      setState(() {
        schoolController.text = school.schoolName;
      });
    },
    leading: CircleAvatar(
      backgroundImage: AssetImage(school.logo),
    ),
    title: Text(school.schoolName),
    trailing: Icon(CupertinoIcons.arrow_right_square_fill),
  );
}
