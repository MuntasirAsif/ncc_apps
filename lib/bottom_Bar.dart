import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ncc_apps/Users%20UI/profile_screen.dart';
import 'package:ncc_apps/Users%20UI/segment_screen.dart';
import 'package:ncc_apps/Users%20UI/home_screen.dart';
import 'package:ncc_apps/Users%20UI/news_feed.dart';
import 'package:ncc_apps/Utils/colors.dart';
import 'Admin UI/admin_home.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;
  bool isAdmin = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  DatabaseReference ref = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL: 'https://ncc-apps-47109-default-rtdb.firebaseio.com')
      .ref("user");
  @override

  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    final List<Widget> widgetOptins = <Widget>[
      const HomeScreen(),
      NewsFeed(isAdmin: isAdmin),
      SegmentScreen(isAdmin: isAdmin),
      ProfileScreen(isAdmin: isAdmin, uid: uid.toString(),),
    ];
    final List<Widget> adminWidgetOptins = <Widget>[
      AdminHomeScreen(isAdmin: isAdmin),
      NewsFeed(isAdmin: isAdmin),
      SegmentScreen(isAdmin: isAdmin),
      ProfileScreen(isAdmin: isAdmin, uid: uid.toString(),),
    ];
    return PopScope(
      canPop: false, // prevent back
      onPopInvoked: (_) async {
        // This can be async and you can check your condition
        if(_selectedIndex>0){
          setState(() {
            _selectedIndex=0;
          });
        }else{
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        //backgroundColor: Colors.black54,
        body: StreamBuilder(
          stream: ref.child(uid.toString()).onValue,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              final DataSnapshot data = snapshot.data!.snapshot;
              final Map<dynamic, dynamic>? map =
              data.value as Map<dynamic, dynamic>?;
              isAdmin = map?['userType']=='Admin';
              return !isAdmin? Center(
                child: widgetOptins[_selectedIndex]): Center(child: adminWidgetOptins[_selectedIndex]);
          }else {
              return const Text('Wrong Something');
            }
          },
          ),
        bottomNavigationBar:
               BottomNavigationBar(
                  currentIndex: _selectedIndex,
                  onTap: _onItemTapped,
                  iconSize: 27,
                  showSelectedLabels: true,
                  showUnselectedLabels: false,
                  selectedItemColor: deepGreen,
                  unselectedItemColor: black,
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: white,
                  items: const [
                    BottomNavigationBarItem(
                        icon: FaIcon(FontAwesomeIcons.house), label: 'Home'),
                    BottomNavigationBarItem(
                        icon: FaIcon(FontAwesomeIcons.newspaper),
                        label: 'News Feed'),
                    BottomNavigationBarItem(
                        icon: FaIcon(FontAwesomeIcons.gripfire),
                        label: 'Segment'),
                    BottomNavigationBarItem(
                        icon: FaIcon(FontAwesomeIcons.user), label: 'Profile'),
                  ],
                ),
      ),
    );
  }
}
