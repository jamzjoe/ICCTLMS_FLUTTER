import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icct_lms/components/navigation_drawer.dart';
import 'package:icct_lms/components/shimmer_loading.dart';
import 'package:icct_lms/home_pages/class.dart';
import 'package:icct_lms/home_pages/home.dart';
import 'package:icct_lms/home_pages/message.dart';
import 'package:icct_lms/home_pages/notifications.dart';
import 'package:icct_lms/home_pages/planner.dart';
import 'package:icct_lms/services/user.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  int currentIndex = 0;
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    String uid = user.uid;

    return DefaultTabController(
      animationDuration: const Duration(seconds: 1),
      length: 5,
      initialIndex: currentIndex,
      child: FutureBuilder<UserProfile?>(
          future: readUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final user = snapshot.data;
              return user == null
                  ? const Center(
                      child: Text('No user'),
                    )
                  : buildUser(user, uid);
            } else {
              return const ShimmerLoading();
            }
          }),
    );
  }

  Future<UserProfile?> readUser() async {
    final docUser =
        FirebaseFirestore.instance.collection('Users').doc(user.uid);
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return UserProfile.fromJson(snapshot.data()!);
    }
    return null;
  }

  Widget buildUser(UserProfile user, String uid) => Scaffold(
        drawer: NavigationDrawer(
          userType: user.userType,
          name: user.name,
          email: user.email,
          school: user.campus,
          uid: uid,
        ),
        appBar: AppBar(
            automaticallyImplyLeading: true,
            leadingWidth: 300,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) =>  EditProfile(user: user.)
                  // )
                  // );
                },
                child: const Image(
                  image: AssetImage('assets/logo_black_text.png'),
                ),
              ),
            ),
            flexibleSpace: Container(color: Colors.white),
            bottom: TabBar(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black54,
              indicatorColor: Colors.blue[900],
              indicatorWeight: 3,
              tabs: [
                const Tab(icon: Icon(CupertinoIcons.home)),
                const Tab(icon: Icon(CupertinoIcons.device_desktop)),
                const Tab(icon: Icon(CupertinoIcons.calendar)),
                Tab(
                  icon: Badge(
                      badgeContent: const Text('2'),
                      showBadge: true,
                      child: const Icon(CupertinoIcons.chat_bubble)),
                ),
                Tab(
                    icon: Badge(
                        showBadge: true,
                        badgeContent: const Text('10'),
                        child: const Icon(CupertinoIcons.bell))),
              ],
            ),
            backgroundColor: Colors.blue,
            actions: [
              Builder(
                builder: (BuildContext context) {
                  return IconButton(
                      onPressed: () {
                        showSearch(
                            context: context, delegate: CustomSearchDelegate());
                      },
                      icon: const Icon(
                        Icons.search,
                        color: Colors.black54,
                      ));
                },
              ),
              Builder(
                builder: (BuildContext context) {
                  return IconButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.black54,
                      ));
                },
              ),
            ]),
        body: TabBarView(
          children: [
            HomeScreen(
                uid: uid,
                userType: user.userType,
                userName: user.name,
                userEmail: user.email,
                userCampus: user.campus),
            ClassScreen(
                uid: uid,
                userType: user.userType,
                userName: user.name,
                userEmail: user.email,
                userCampus: user.campus,
            ),
            PlannerScreen(uid: uid),
            MessageScreen(uid: uid),
            NotificationScreen(uid: uid),
          ],
        ),
        // bottomNavigationBar: buildBottomNavigationDrawer(),
      );
}

class CustomSearchDelegate extends SearchDelegate {
  List<String> searchItems = [
    'I miss you',
    'I am still inlove with you',
    'I am glad.',
    'I am your forever',
    'Nobita'
  ];
  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back_ios));
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    List<String> matchQuery = [];
    for (var each in searchItems) {
      if (each.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(each);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];

        return ListTile(
          title: Text(result),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    List<String> matchQuery = [];
    for (var each in searchItems) {
      if (each.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(each);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];

        return ListTile(
          title: Text(result),
        );
      },
    );
  }
}
