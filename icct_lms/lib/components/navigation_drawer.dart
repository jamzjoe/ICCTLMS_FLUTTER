import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:icct_lms/menu_pages/back_pack.dart';
import 'package:icct_lms/menu_pages/help_center.dart';
import 'package:icct_lms/menu_pages/news_and_updates.dart';
import 'package:icct_lms/menu_pages/settings.dart';

class NavigationDrawer extends StatefulWidget {
  const NavigationDrawer({Key? key, required this.name, required this.email, required this.uid, required this.school}) : super(key: key);
  final String name;
  final String email;
  final String uid;
  final String school;
  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
    Drawer(
      child: Material(
        color: Colors.blue[900],
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
             Header(name: widget.name, email: widget.email, uid: widget.uid,
                 school: widget.school),

            const Divider(
              thickness: 2,
              color: Colors.white,
            ),
            buildMenuItem(
                onClicked: ()=> selectedItem(context, 0),
               text: 'Backpack',
              icon: Icons.shopping_bag,
            ),
            buildMenuItem(
                onClicked: ()=> selectedItem(context, 1),
                text: 'News and Updates',
                icon: Icons.newspaper
            ),
            buildMenuItem(
                onClicked: ()=> selectedItem(context, 2),
                text: 'Help Center',
                icon: Icons.question_answer
            ),
            buildMenuItem(
                onClicked: ()=> selectedItem(context, 3),
                text: 'Settings',
                icon: Icons.settings
            ),
            const Divider(
              thickness: 2,
              color: Colors.white,
            ),
            buildMenuItem(
                onClicked: ()=> selectedItem(context, 4),
                text: 'Logout',
                icon: Icons.exit_to_app
            ),
            buildMenuItem(
                onClicked: ()=> selectedItem(context, 5),
                text: 'Delete Account',
                icon: Icons.delete
            )
          ],
        ),
      ),
    )
    );
  }

  buildMenuItem({required String text, required IconData icon, required Function() onClicked}) {
    const color = Colors.white;
    return ListTile(
      onTap: onClicked,
      leading: Icon(icon, color: color,),
      title: Text(text, style: const TextStyle(color: color),),
    );
  }

  selectedItem(BuildContext context, int index) {
  switch(index){
    case 0:
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const BackPack(),));
      break;
    case 1:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const NewsUpdates(),));
      break;
    case 2:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const HelpCenter(),));
      break;
    case 3:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const Settings(),));
      break;
    case 4:
      Navigator.pushNamedAndRemoveUntil(context, '/choose_user', (route) =>
      false,);
      break;
    case 5:
      break;
  }
  }



}

class Header extends StatefulWidget {
  const Header({Key? key, required this.name, required this.school, required this.uid, required this.email}) : super(key: key);
  final String name;
  final String school;
  final String uid;
  final String email;
  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[900],
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/logo_plain.png'),
              ),
              const SizedBox(width: 20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.name, style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                    color: Colors.white
                  ),),
                  Text(widget.email, style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                      color: Colors.white
                  ),),
                  Text(widget.school,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: Colors.white
                    ),),
                  Row(
                    children: [
                      Text(widget.uid,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: Colors.white
                        ),),
                        buildCopy(),
                    ],
                  ),


                ],

              )
            ],

          ),


        ),

      ),

    );

  }

  Widget buildCopy() => IconButton(onPressed: () async{
    await FlutterClipboard.copy(widget.uid);
    if(!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar( SnackBar( content: Text
      ('You copied ${widget.uid}'), duration: const Duration(milliseconds:
    300), ), );
    Navigator.of(context).pop();
  }, icon: const Icon(Icons
      .copy_outlined, size: 12, color: Colors.white,));
}
