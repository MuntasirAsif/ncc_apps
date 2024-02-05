import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ncc_apps/Utils/colors.dart';

class GroupView extends StatelessWidget {
  final bool isAdmin;
  final String roomName;
  final String roomKey;
  final String time;
  const GroupView(
      {super.key,
      required this.roomName,
      required this.roomKey,
      required this.time,
      required this.isAdmin});
  @override
  Widget build(BuildContext context) {
    DatabaseReference ref = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: 'https://ncc-apps-47109-default-rtdb.firebaseio.com')
        .ref("Exam Hub/group/$roomName");
    final height = MediaQuery
        .of(context)
        .size
        .height;
    final width = MediaQuery
        .of(context)
        .size
        .width;
    final textTheme = Theme
        .of(context)
        .textTheme;
    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
          color: grey.withOpacity(0.3),
          border: Border.all(),
          borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(roomName),
        subtitle: Text('$time Minutes'),
        trailing: isAdmin?PopupMenuButton(
          icon: const Icon(Icons
              .more_horiz_outlined),
          itemBuilder: (context) =>
          [
            PopupMenuItem(
              value: 1,
              child: InkWell(
                onTap: () {
                  ref.remove();
                  Navigator.pop(context);
                },
                child: SizedBox(
                  height: height * 0.04,
                  width: width * 0.1,
                  child: Text('Delete',
                      style: textTheme
                          .titleSmall!
                          .copyWith(
                          fontWeight:
                          FontWeight
                              .w400)),
                ),
              ),
            ),
          ],
        ):const SizedBox(),
      ),
    );
  }
}
