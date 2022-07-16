import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationDrawer extends StatefulWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
    Drawer(
      child: Material(
        color: Colors.blue,
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            Header(),
            buildMenuItem(
               text: 'Backpack',
              icon: Icons.shopping_bag
            ),
            buildMenuItem(
                text: 'News and Updates',
                icon: Icons.newspaper
            ),
            buildMenuItem(
                text: 'Help Center',
                icon: Icons.question_answer
            ),
            buildMenuItem(
                text: 'Settings',
                icon: Icons.settings
            ),
            const Divider(
              color: Colors.white,
            ),
            buildMenuItem(
                text: 'Logout',
                icon: Icons.exit_to_app
            ),
            buildMenuItem(
                text: 'Delete Account',
                icon: Icons.delete
            )
          ],
        ),
      ),
    )
    );
  }

  buildMenuItem({required String text, required IconData icon}) {
    const color = Colors.white;
    return ListTile(
      leading: Icon(icon, color: color,),
      title: Text(text, style: const TextStyle(color: color),),
    );
  }



}

class Header extends StatefulWidget {
  const Header({Key? key}) : super(key: key);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(30),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/logo_plain.png'),
            ),
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Joe Cristian Jamis', style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 17
                ),),
                Text('jamisjoecristian@gmail.com', style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300
                ),),
                Text('ICCT San Mateo Campus',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300
                  ),),
              ],
            )
          ],
        ),
      ),
    );
  }
}
