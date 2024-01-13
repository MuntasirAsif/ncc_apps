import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ncc_apps/Users%20UI/profile_screen.dart';

import '../Utils/colors.dart';

class Member extends StatefulWidget {
  final bool isAdmin;
  const Member({Key? key, required this.isAdmin}) : super(key: key);

  @override
  State<Member> createState() => _MemberState();
}

class _MemberState extends State<Member> {
  DatabaseReference ref = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: 'https://ncc-apps-47109-default-rtdb.firebaseio.com')
      .ref("user");
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(appBar: AppBar(
      title: const Text('Members'),
      backgroundColor: white,
    ),
        body: Container(
          height: height,
          width: width,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/Background.png'),
                  fit: BoxFit.fill)),
          child: FirebaseAnimatedList(
            query: ref,
            itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
              return snapshot.child('position').value.toString()!=''?Column(
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen(isAdmin: widget.isAdmin, uid: snapshot.child('uid').value.toString())));
                    },
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: height * 0.09,
                        minWidth: width * 0.95
                      ),
                      child: Container(
                        width: width * 0.95,
                        decoration: BoxDecoration(
                            color: grey.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(snapshot.child('profileImage').value.toString()),
                              radius: 30,
                            ),
                            title: Text(
                              snapshot.child('userName').value.toString(),
                              style: textTheme.titleLarge,
                            ),
                            subtitle: Text(
                              snapshot.child('position').value.toString(),
                              style: textTheme.bodySmall,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Gap(height*0.01)
                ],
              ):const SizedBox();
            },

          ),
        ));
  }
}
