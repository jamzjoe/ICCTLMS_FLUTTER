import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icct_lms/components/loading.dart';
import 'package:icct_lms/models/school_list.dart';
import 'package:icct_lms/services/auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key, required this.usertype, required this.togglePage})
      : super(key: key);
  final String usertype;
  final Function togglePage;
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final schoolController = TextEditingController();
  String name = '';
  String email = '';
  String password = '';
  String error = '';
  bool loading = false;

  void goToForgotPassword() {
    Navigator.pushNamed(context, '/forgot_password');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    schoolController.addListener(() {
      setState(() {});
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
    return loading
        ? const Loading()
        : Scaffold(
            body: SafeArea(
                child: Container(
              padding: const EdgeInsets.only(bottom: 40),
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(40),
                  children: [
                    const Center(
                        child: Hero(
                      tag: 'assets/logo_black_text.png',
                      child: Image(
                        image: AssetImage('assets/logo_black_text.png'),
                        width: 250,
                      ),
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
                      height: 50,
                    ),
                    const Text(
                      'Login your account',
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Center(
                                child: TextFormField(
                              autofillHints: AutofillHints.email.characters,
                              validator: (value) =>
                                  value!.isEmpty && !value.contains('@')
                                      ? 'Email must be contains @'
                                          ' and 6+ chars long'
                                      : null,
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
                                        onPressed: () =>
                                            emailController.clear(),
                                        icon: const Icon(Icons.close)),
                              ),
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                            )),
                            const SizedBox(
                              height: 10,
                            ),
                            Center(
                                child: TextFormField(
                              autofillHints: AutofillHints.password.characters,
                              validator: (value) => value!.length < 6
                                  ? 'Passwo'
                                      'rd must be 6+ chars long.'
                                  : null,
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
                            )),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Center(
                          child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blue[900]),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  dynamic result =
                                      await _auth.signInWithEmailAndPassword(
                                          emailController.text.trim(),
                                          passwordController.text.trim());
                                  if (result == null) {
                                    setState(() {
                                      loading = false;
                                      showCupertinoDialog(
                                          context: context,
                                          builder: createDialog);
                                    });
                                  }

                                }
                              },
                              icon: const Icon(CupertinoIcons.forward),
                              label: const Text('Login Account')),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 110,
                    ),
                  ],
                ),
              ),
            )),
            bottomSheet: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              child: Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          widget.togglePage();
                        },
                        child: const Text('No account yet?')),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/forgot_password',
                              arguments: {'user_type': data['user_type']});
                        },
                        child: const Text('Forgot Password?')),
                  ],
                ),
              ),
            ),
          );
  }

  void chooseCampus() {
    showModalBottomSheet(context: context, builder: (context) => buildSheet());
  }

  Widget buildSheet() => ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                const Text(
                  'Choose Campus',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: schools.map((e) => newSchools(school: e)).toList(),
                ),
              ],
            ),
          )
        ],
      );

  Widget newSchools({required SchoolList school}) => ListTile(
        contentPadding: const EdgeInsets.all(2),
        selectedTileColor: Colors.white24,
        onTap: () {
          Navigator.pop(context);
          setState(() {
            schoolController.text = school.schoolName;
          });
        },
        leading: CircleAvatar(
          backgroundImage: AssetImage(school.logo),
        ),
        title: Text(school.schoolName),
        trailing: const Icon(CupertinoIcons.arrow_right_square_fill),
      );

  Widget createDialog(BuildContext context) => CupertinoAlertDialog(
        title: const Text('Error'),
        content: Text(_auth.error),
        actions: [
          CupertinoDialogAction(
              onPressed: () => Navigator.pop(context), child: const Text('OK'))
        ],
      );
}
