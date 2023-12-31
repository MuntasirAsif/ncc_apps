import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ncc_apps/Admin%20UI/application_view.dart';
import 'package:ncc_apps/Utils/colors.dart';

class MemberRequest extends StatefulWidget {
  const MemberRequest({Key? key}) : super(key: key);

  @override
  State<MemberRequest> createState() => _MemberRequestState();
}

class _MemberRequestState extends State<MemberRequest> {
  DatabaseReference ref = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: 'https://ncc-apps-47109-default-rtdb.firebaseio.com')
      .ref('Applications');
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Member Request'),
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
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ApplicationView(uid: snapshot.child('uid').value.toString(),)));
                    },
                    child: Container(
                      height: height * 0.09,
                      width: width * 0.95,
                      decoration: BoxDecoration(
                          color: grey.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(snapshot.child('Image').value.toString()),
                            radius: 30,
                          ),
                          title: Text(
                            snapshot.child('name').value.toString(),
                            style: textTheme.titleLarge,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Gap(height*0.01)
                ],
              );
            },

          ),
        ));
  }
}
