import 'package:flutter/material.dart';
import 'package:icct_lms/components/navigation_drawer.dart';

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
  final screens = [
    const Center(
      child: const Text('Home'),
    ),
    const Center(
      child: Text('Class'),
    ),
    const Center(
      child: Text('Planner'),
    ),
    const Center(
      child: Text('Message'),
    ),
    const Center(
      child: Text('Notification'),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      drawer: const NavigationDrawer(),
      appBar: AppBar(title: Text('${data['user_name']}'), actions: const [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/logo_plain.png'),
          ),
        )
      ]),
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.white70,
        currentIndex: currentIndex,
        onTap: (index) => setState(() {
          currentIndex = index;
        }),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.blueAccent),
          BottomNavigationBarItem(
              icon: Icon(Icons.class_),
              label: 'Home',
              backgroundColor: Colors.pinkAccent),
          BottomNavigationBarItem(
              icon: Icon(Icons.schedule),
              label: 'Home',
              backgroundColor: Colors.purpleAccent),
          BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: 'Home',
              backgroundColor: Colors.green),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Home',
              backgroundColor: Colors.redAccent)
        ],
      ),
    );
  }
}
