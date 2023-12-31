import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:readmore/readmore.dart';
import '../../Utils/colors.dart';

class CommentView extends StatefulWidget {
  final String userId;
  final String comment;
  const CommentView({Key? key, required this.userId, required this.comment}) : super(key: key);

  @override
  State<CommentView> createState() => _CommentViewState();
}

class _CommentViewState extends State<CommentView> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    DatabaseReference ref = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: 'https://ncc-apps-47109-default-rtdb.firebaseio.com')
        .ref("user/${widget.userId}");
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: height * 0.1,
        minWidth: width * 0.95,
      ),
      child: Container(
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(height*0.01),
            StreamBuilder(
              stream: ref.onValue,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  final DataSnapshot data = snapshot.data!.snapshot;
                  final Map<dynamic, dynamic>? map =
                  data.value as Map<dynamic, dynamic>?;
                  return ListTile(
                    leading: Container(
                      width: width * 0.1,
                      height: width * 0.1,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black87, width: 3)),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: map?['profileImage'].toString() == ""
                              ? const Icon(Icons.person)
                              : Image(
                              fit: BoxFit.cover,
                              image: NetworkImage(map?['profileImage']))),
                    ),
                    title: Text(map?['userName']),
                  );
                } else {
                  return const Text('Wrong Something');
                }
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: width*0.15),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minHeight: 0,
                        ),
                        child: ReadMoreText(
                          widget.comment,
                          trimLines: 2,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: 'Show more',
                          trimExpandedText: 'Show less',
                          moreStyle: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                          lessStyle: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Gap(height*0.01),
          ],
        ),
      ),
    );
  }
}
