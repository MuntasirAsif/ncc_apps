import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ncc_apps/Users%20UI/home_screen.dart';
import 'package:ncc_apps/Users%20UI/news_feed.dart';
import 'package:ncc_apps/Users%20UI/profile_screen.dart';

import '../Utils/colors.dart';

class NotificationScreen extends StatefulWidget {
  final bool isAdmin;
  const NotificationScreen({Key? key, required this.isAdmin}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}
class _NotificationScreenState extends State<NotificationScreen> {
  DatabaseReference ref = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: 'https://ncc-apps-47109-default-rtdb.firebaseio.com')
      .ref("user");
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final uId = user?.uid;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          InkWell(
            onTap: (){
              ref.child(uId.toString()).child('notifications').remove();
            },
              child: const Text('Clear all')),
          Gap(width*0.05)
        ],
      ),
      body: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/Background.png'),
                fit: BoxFit.fill)),
        child: SizedBox(
          height: height,
          width: width,
          child: FirebaseAnimatedList(
              query: ref.child(uId.toString()).child('notifications'),
              sort: (DataSnapshot a, DataSnapshot b) {
                return b.key!.compareTo(a.key!);
              },
              itemBuilder: (context, snapshot, animation, index){
                return InkWell(
                  onTap: (){
                    if(snapshot.child('type').value.toString()=='post'){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsFeed(isAdmin: widget.isAdmin)));
                    }else if(snapshot.child('type').value.toString()=='Achievement'){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomeScreen()));
                    }else if(snapshot.child('type').value.toString()=='comment' || snapshot.child('type').value.toString()=='like'){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen(isAdmin: widget.isAdmin, uid: uId.toString())));
                    }else{
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomeScreen()));
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: width*0.02,vertical: height*0.002),
                    height: height*0.1,
                    width: width,
                    decoration: BoxDecoration(
                    color: grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20)
                  ),
                    child: ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle: Text(snapshot.child('body').value.toString()),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
