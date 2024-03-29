import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icct_lms/services/auth.dart';
import 'package:icct_lms/services/database.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  const Profile(
      {Key? key,
      required this.name,
      required this.userType,
      required this.uid,
      required this.school,
      required this.email})
      : super(key: key);
  final String name;
  final String userType;
  final String uid;
  final String school;
  final String email;
  @override
  State<Profile> createState() => _ProfileState();
}

final String uid = FirebaseAuth.instance.currentUser!.uid;
bool showTextField = false;
bool updateButton = true;
bool submitButton = false;
final nameController = TextEditingController();
final emailController = TextEditingController();
final schoolController = TextEditingController();
final userTypeController = TextEditingController();
final facebookController = TextEditingController();
final instagramController = TextEditingController();
final DatabaseService user = DatabaseService(uid: uid);
final AuthService _auth = AuthService();

String? selectedCampus = '';
var campus = [
  'Cainta Main Campus',
  'San Mateo Campus',
  'Sumulong Campus',
  'Agono Campus',
  'Antipolo Campus',
  'Binangonan Campus',
];
var usertype = ['Teacher', 'Student'];

String? selectedUserType = '';
String? finalName = '';

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    // TODO: implement initState
    selectedCampus = widget.school;
    selectedUserType = widget.userType;
    nameController.text = widget.name;
    emailController.text = widget.email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            buildTop(),
            buildContent(),
          ],
        ),
      ),
    );
  }

  Widget buildCover() => Container(
        height: 170,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.blue, Colors.red])),
      );

  Widget buildProfile() => Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(50.0)),
          border: Border.all(
            color: Colors.white,
            width: 4.0,
          ),
        ),
        child: CircleAvatar(
          backgroundColor: Colors.blue[900],
          radius: 45,
          child: Text(
            widget.name.substring(0, 2).toUpperCase(),
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      );

  buildTop() {
    var top = 123;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
            margin: EdgeInsets.only(bottom: top / 2), child: buildCover()),
        Positioned(top: top.toDouble(), child: buildProfile()),
      ],
    );
  }

  Widget buildContent() => Column(
        children: [
          Text(
            widget.name,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          Text('${widget.userType} @${widget.school}'),
          const SizedBox(
            height: 10,
          ),
          Visibility(
              visible: showTextField,
              child: Form(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('Username'),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        readOnly: true,
                        controller: emailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('Email address'),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5))),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              onChanged: (String? value) {
                                setState(() {
                                  selectedCampus = value!;
                                });
                              },
                              value: selectedCampus,
                              isExpanded: true,
                              icon: const Icon(
                                  Icons.keyboard_arrow_down_outlined),
                              items: campus.map((String each) {
                                return DropdownMenuItem(
                                    value: each, child: Text(each));
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5))),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              onChanged: (String? value) {
                                setState(() {
                                  selectedUserType = value!;
                                });
                              },
                              value: selectedUserType,
                              isExpanded: true,
                              icon: const Icon(
                                  Icons.keyboard_arrow_down_outlined),
                              items: usertype.map((String each) {
                                return DropdownMenuItem(
                                    value: each, child: Text(each));
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              )),
          const SizedBox(
            height: 20,
          ),
          Visibility(
            visible: updateButton,
            child: ElevatedButton.icon(
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.blue[900]),
                onPressed: () {
                  setState(() {
                    showTextField = true;
                    updateButton = false;
                    submitButton = true;
                  });
                },
                icon: const Icon(
                  FontAwesomeIcons.edit,
                  size: 20,
                ),
                label: const Text('Update Profile')),
          ),
          Visibility(
            visible: submitButton,
            child: ElevatedButton.icon(
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.blue[900]),
                onPressed: () {
                  showAlert();
                },
                icon: const Icon(
                  FontAwesomeIcons.fileEdit,
                  size: 20,
                ),
                label: const Text('Submit Changes')),
          ),
        ],
      );

  Widget buildIcon(IconData icon, String link) => CircleAvatar(
        backgroundColor: Colors.white,
        radius: 20,
        child: IconButton(
          icon: Icon(icon),
          onPressed: () async {
            final url = link;
            openBrowserUrl(url, false);
          },
          color: Colors.blue[900],
        ),
      );

  Future showAlert() async => showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
            title: const Text('Note'),
            content: const Text('Changes applied when you restart this app.'),
            actions: [
              TextButton(
                onPressed: () async {
                  await user.updateUserDetails(
                      nameController.text.trim(),
                      emailController.text.trim(),
                      selectedCampus.toString().trim(),
                      selectedUserType.toString().trim(),
                      widget.uid);
                  _auth.signOut();
                  if (!mounted) {
                    return;
                  }
                  setState(() {
                    showTextField = false;
                    updateButton = true;
                    submitButton = false;
                  });
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/wrap', (route) => false);
                },
                child: const Text('Logout'),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      showTextField = false;
                      updateButton = true;
                      submitButton = false;
                    });
                  },
                  child: const Text('Cancel'))
            ],
          ));

  Future openBrowserUrl(String url, bool inApp) async {
    try {
      await launch(url,
          forceWebView: inApp, forceSafariVC: true, enableJavaScript: true);
    } catch (e) {
      return;
    }
  }
}
