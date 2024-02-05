import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ncc_apps/Admin%20UI/registerd_view.dart';

import '../Utils/colors.dart';

class EventRegistrationListScreen extends StatefulWidget {
  const EventRegistrationListScreen({super.key});

  @override
  State<EventRegistrationListScreen> createState() =>
      _EventRegistrationListScreenState();
}

class _EventRegistrationListScreenState
    extends State<EventRegistrationListScreen> {
  DatabaseReference ref = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL: 'https://ncc-apps-47109-default-rtdb.firebaseio.com')
      .ref('Event/Registration');
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
            sort: (DataSnapshot a, DataSnapshot b) {
              return b.key!.compareTo(a.key!);
            },
            itemBuilder: (BuildContext context, DataSnapshot snapshot,
                Animation<double> animation, int index) {
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisteredView(
                                    uid: snapshot.child('uid').value.toString(),
                                  )));
                    },
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: width * 0.95,
                        minHeight: height * 0.09,
                      ),
                      child: Container(
                        width: width * 0.95,
                        decoration: BoxDecoration(
                            color: grey.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: ListTile(
                            title: Text(
                              snapshot.child('name').value.toString(),
                              style: textTheme.titleLarge,
                            ),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ID: ${snapshot.child('id').value.toString()}',
                                  style: textTheme.bodyLarge,
                                ),
                                Text(
                                  snapshot.child('dept').value.toString(),
                                  style: textTheme.bodyLarge,
                                ),
                              ],
                            ),
                            trailing: Text(
                              snapshot.child('status').value.toString(),
                              style: textTheme.bodyMedium!.copyWith(color: red),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Gap(height * 0.01)
                ],
              );
            },
          ),
        ));
  }
}
