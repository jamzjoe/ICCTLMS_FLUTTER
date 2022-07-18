import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icct_lms/components/navigation_drawer.dart';
import 'package:icct_lms/home_pages/class.dart';
import 'package:icct_lms/home_pages/edit_profile.dart';
import 'package:icct_lms/home_pages/home.dart';
import 'package:icct_lms/home_pages/message.dart';
import 'package:icct_lms/home_pages/notifications.dart';
import 'package:icct_lms/home_pages/planner.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Map data = {};
  int currentIndex = 0;


  @override
  Widget build(BuildContext context) {
    data = ModalRoute
        .of(context)!
        .settings
        .arguments as Map;


    String name = 'Name data from main';
    String email = 'Email data';
    String school = 'School data';
    String uid = 'School uid';

    final screens = [
      HomeScreen(uid: uid),
      ClassScreen(uid: uid),
      PlannerScreen(uid: uid),
      MessageScreen(uid: uid),
      NotificationScreen(uid: uid),

    ];
    return DefaultTabController(
      length: 5,
      initialIndex: currentIndex,
      child: Scaffold(
        drawer: NavigationDrawer(
          name: name,
          email: email,
          school: school,
          uid: uid),
        appBar: AppBar(
            flexibleSpace: Container(
              color: Colors.blue[900]
            ),
            bottom: TabBar(
              indicatorColor: Colors.red,
              indicatorWeight: 3,
              tabs: [
                Tab(icon: Icon(CupertinoIcons.home), text: 'Home',),
                Tab(icon: Icon(CupertinoIcons.device_desktop), text: 'Class',),
                Tab(icon: Icon(CupertinoIcons.calendar), text: 'Planner',),
                Tab(icon: Badge(
                    badgeContent: Text('2'),
                    showBadge: true,
                    child: Icon(CupertinoIcons.chat_bubble)), text: 'Messages',),
                Tab(icon: Badge(
                  showBadge: true,
                    badgeContent: Text('10'),
                    child: Icon(CupertinoIcons.bell)), text: 'Not'
                    'ifications',),
              ],
            ),
            backgroundColor: Colors.blue,
            title: Text('${data['user_name']}'),
            actions:[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                child: InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>  EditProfile(uid: uid)));
                  },
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/logo_plain.png'),
                  ),
                ),
              ),
            ]),
        body: TabBarView(
          children: screens,
        ),
        // bottomNavigationBar: buildBottomNavigationDrawer(),
      ),
    );
  }
}
