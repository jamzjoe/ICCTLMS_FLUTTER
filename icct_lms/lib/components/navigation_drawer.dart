import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icct_lms/home_pages/profile.dart';
import 'package:icct_lms/menu_pages/back_pack.dart';
import 'package:icct_lms/menu_pages/help_center.dart';
import 'package:icct_lms/menu_pages/news_and_updates.dart';
import 'package:icct_lms/services/auth.dart';
import 'package:provider/provider.dart';

class NavigationDrawer extends StatefulWidget {
  const NavigationDrawer(
      {Key? key,
      required this.userType,
      required this.name,
      required this.email,
      required this.uid,
      required this.school})
      : super(key: key);
  final String name;
  final String email;
  final String uid;
  final String school;
  final String userType;
  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<QuerySnapshot?>(context);

    return SafeArea(
        child: Drawer(
      backgroundColor: Colors.blue[900],
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Header(
                name: widget.name,
                school: widget.school,
                uid: widget.uid,
                email: widget.email,
                userType: widget.userType),
            buildMenuItem(
              onClicked: () => selectedItem(context, 0),
              text: 'Backpack',
              icon: Icons.shopping_bag,
            ),
            buildMenuItem(
                onClicked: () => selectedItem(context, 1),
                text: 'News and Updates',
                icon: Icons.newspaper),
            buildMenuItem(
                onClicked: () => selectedItem(context, 2),
                text: 'Help Center',
                icon: Icons.question_answer),
            buildMenuItem(
                onClicked: () => selectedItem(context, 3),
                text: 'Settings',
                icon: Icons.settings),
            const Divider(
              thickness: 1,
              color: Colors.white,
            ),
            buildMenuItem(
                onClicked: () => selectedItem(context, 4),
                text: 'Logout',
                icon: Icons.exit_to_app),
            buildMenuItem(
                onClicked: () async => await selectedItem(context, 5),
                text: 'Delete Account',
                icon: Icons.delete)
          ],
        ),
      ),
    ));
  }

  buildMenuItem(
      {required String text,
      required IconData icon,
      required Function() onClicked}) {
    const color = Colors.white;
    return Container(
      child: ListTile(
        onTap: onClicked,
        selectedTileColor: Colors.cyan,
        leading: Icon(
          icon,
          color: color,
        ),
        title: Text(
          text,
          style: const TextStyle(color: color),
        ),
      ),
    );
  }

  selectedItem(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const BackPack(),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const NewsUpdates(),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const HelpCenter(),
        ));
        break;
      case 3:

      case 4:
        showLogoutAlert();
        break;
      case 5:
        showAlert();
        break;
    }
  }

  Future showAlert() => showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
            title: const Text('Warning!'),
            content: const Text(
                'There is no way to undo the deletion of this account, are you sure you want to delete?'),
            actions: [
              TextButton(
                  onPressed: () async {
                    await _auth.deleteAccount();
                    if (!mounted) {
                      return;
                    }
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/wrap', (route) => false);
                  },
                  child: const Text('Delete')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'))
            ],
          ));

  Future showLogoutAlert() => showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
            title: const Text('Warning'),
            content: const Text('Are you sure you want to sign out?'),
            actions: [
              TextButton(
                  onPressed: () async {
                    await _auth.signOut();
                    if (!mounted) {
                      return;
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('Logout')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
            ],
          ));
}

class Header extends StatefulWidget {
  const Header(
      {Key? key,
      required this.name,
      required this.school,
      required this.uid,
      required this.email,
      required this.userType})
      : super(key: key);
  final String name;
  final String school;
  final String uid;
  final String email;
  final String userType;
  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Profile(
                          name: widget.name,
                          userType: widget.userType,
                          uid: widget.uid,
                          school: widget.school,
                          email: widget.email)));
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                border: Border.all(
                  color: Colors.blue,
                  width: 4.0,
                ),
              ),
              child: CircleAvatar(
                backgroundColor: Colors.blue[900],
                child: Text(
                  widget.name.substring(0, 2).toUpperCase(),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, overflow: TextOverflow.fade),
                ),
                Text(
                  widget.email,
                  style: const TextStyle(fontWeight: FontWeight.w300),
                ),
                Text(
                  widget.school,
                  style: const TextStyle(fontWeight: FontWeight.w300),
                ),
                Text(
                  widget.userType,
                  style: const TextStyle(fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
          buildCopy()
        ],
      ),
    );
  }

  Widget buildCopy() => IconButton(
      onPressed: () async {
        await FlutterClipboard.copy(widget.uid);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You copied ${widget.name} ID:${widget.uid}'),
            duration: const Duration(milliseconds: 1000),
          ),
        );
        Navigator.of(context).pop();
      },
      icon: const Icon(
        Icons.copy_outlined,
        size: 12,
        color: Colors.black54,
      ));
}
