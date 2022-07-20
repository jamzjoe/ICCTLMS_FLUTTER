import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icct_lms/components/loading.dart';
import 'package:icct_lms/models/school_list.dart';
import 'package:icct_lms/services/auth.dart';

class Register extends StatefulWidget {
  const Register({Key? key, required this.togglePage}) : super(key: key);
  final Function togglePage;
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final schoolController = TextEditingController();
  final userTypeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String name = '';
  final AuthService _auth = AuthService();
  String email = '';
  String password = '';
  String error = '';
  bool loading = false;

  void backToLogin() {
    widget.togglePage();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    schoolController.addListener(() {
      setState(() {});
    });
    userTypeController.addListener(() {
      setState(() {

      });
    });
    emailController.addListener(() => setState(() {}));
    nameController.addListener(() => setState(() {}));
    passwordController.addListener(() => setState(() {}));
  }

  bool isPasswordVisible = false;
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
  final option = ['Student', 'Teacher', 'Parent'];

  @override
  Widget build(BuildContext context) {
    return loading ? const Loading() : Scaffold(
      body: Container(
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
              const SizedBox(height: 50,),const
              Text('Create a new account', style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w700
              ),),

              const SizedBox(
                height: 20,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        autofillHints: AutofillHints.name.characters,
                        validator: (value) => value!.length < 5 && value
                            .isEmpty ? 'Username required 5+ chars long':
                        null,
                        onChanged: (value) =>
                            setState(() {
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
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                          child: TextFormField(
                            autofillHints: AutofillHints.email.characters,
                            validator: (value) =>
                            value!.isEmpty && !value
                                .contains('@') ? 'Username must be contains @'
                                ' and 6+ chars long' :
                            null,
                            onChanged: (value) =>
                                setState(() {
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
                          child: TextFormField(
                            autofillHints: AutofillHints.password.characters,
                            validator: (value) =>
                            value!.length < 6 ? 'Passwo'
                                'rd must be 6+ chars long.' : null,
                            onChanged: (value) =>
                                setState(() {
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
                          child: TextFormField(
                            validator: (value) => value!.isEmpty ? 'Choose '
                                'campus': null,
                            readOnly: true,
                            controller: schoolController,
                            onTap: () {
                              chooseCampus();
                            },
                            decoration: InputDecoration(
                                label: const Text('Choose Campus'),
                                border: const OutlineInputBorder(),
                                prefixIcon: const Icon(CupertinoIcons
                                    .house_alt_fill),
                                suffixIcon: IconButton(onPressed: () {
                                  chooseCampus();
                                }, icon: const Icon
                                  (Icons.arrow_drop_down_circle))
                            ),
                          )
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                          child: TextFormField(
                            validator: (value) => value!.isEmpty ? 'Choose '
                                'campus': null,
                            readOnly: true,
                            controller: userTypeController,
                            onTap: () {
                              chooseUser();
                            },
                            decoration: InputDecoration(
                                label: const Text('User Type'),
                                border: const OutlineInputBorder(),
                                prefixIcon: const Icon(CupertinoIcons
                                    .person_2_fill),
                                suffixIcon: IconButton(onPressed: () {
                                  chooseUser();
                                }, icon: const Icon
                                  (Icons.arrow_drop_down_circle))
                            ),
                          )
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
                            primary: Colors.blue[900]
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });
                            dynamic result = await _auth
                                .registerWithEmailAndPassword(emailController
                                .text.trim(),
                                passwordController.text.trim(),
                                nameController.text.trim(), schoolController
                                    .text.trim(), emailController.text.trim()
                              , userTypeController.text.trim());
                            if (result == null) {
                              setState(() {
                                loading = false;
                                error = 'Unable to create account, please '
                                    'check your internet connection or this '
                                    'account might be existed.';
                              showCupertinoDialog(context: context, builder:
                              createDialog);
                              }
                              );
                            }
                          }
                        },
                        icon: const Icon(CupertinoIcons.create),
                        label: const Text('Register Account')),
                  ),
                ],
              ),
              const SizedBox(
                height: 110,
              ),

            ],
          ),
        ),
      ),
      bottomSheet: Container(
        height: 50,
        color: Colors.white,
        child: Center(
          child: TextButton(onPressed: () {
            backToLogin();
          }, child: const Text('Back to login')),
        ),
      ),
    );
  }

  void chooseCampus() {
    showModalBottomSheet(context: context, builder:
        (context) => buildSheet()
    );
  }

  Widget buildSheet() =>
      ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                const Text('Choose Campus', style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                ),
                ),
                const SizedBox(height: 20,),
                Column(
                  children: schools.map((e) => newSchools(school: e)).toList(),
                ),
              ],
            ),
          )
        ],
      );

  Widget newSchools({required SchoolList school}) =>
      ListTile(
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


  void chooseUser() {
    showModalBottomSheet(context: context, builder:
        (context) => buildSheetForUserType()
    );
  }

  Widget buildSheetForUserType() =>
      ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                const Text('Choose User Type', style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                ),
                ),
                const SizedBox(height: 20,),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: option.map((e) => userTypes(items: e)).toList(),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      );

  Widget userTypes({required String items}) =>
      ListTile(
        contentPadding: const EdgeInsets.all(2),
        selectedTileColor: Colors.white24,
        onTap: () {
          userTypeController.text = items;
          Navigator.pop(context);
        },
        title: Text(items),
        trailing: const Icon(CupertinoIcons.arrow_right_square_fill),
      );

  Widget createDialog(BuildContext context)  => CupertinoAlertDialog(
    title: const Text('Error'),
    content: Text(error),
    actions: [
      CupertinoDialogAction(child: const Text('OK'),
        onPressed: ()=> Navigator.pop(context),
      ),
    ],

  );
}
