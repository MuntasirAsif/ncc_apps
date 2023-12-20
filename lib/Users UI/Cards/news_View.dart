import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ncc_apps/Users%20UI/Cards/commentScreen.dart';
import 'package:ncc_apps/Utils/colors.dart';
import 'package:readmore/readmore.dart';

import '../../Utils/utils.dart';

class NewsView extends StatefulWidget {
  final String time;
  final String image;
  final String postContent;
  final String userId;
  final String postKey;
  final String like;
  final bool isLiked;
  const NewsView({
    Key? key,
    required this.time,
    required this.image,
    required this.postContent,
    required this.userId,
    required this.postKey,
    required this.like,
    required this.isLiked,
  }) : super(key: key);

  @override
  State<NewsView> createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    DatabaseReference ref = FirebaseDatabase.instanceFor(
            app: Firebase.app(),
            databaseURL: 'https://ncc-apps-47109-default-rtdb.firebaseio.com')
        .ref("user/${widget.userId}");
    DatabaseReference ref2 = FirebaseDatabase.instanceFor(
            app: Firebase.app(),
            databaseURL: 'https://ncc-apps-47109-default-rtdb.firebaseio.com')
        .ref("post/${widget.postKey}");
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: height * 0.1,
        minWidth: width * 0.95,
      ),
      child: Container(
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          border: Border.all(),
          color: white.withOpacity(0.4),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                      width: width * 0.13,
                      height: height * 0.07,
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
                    subtitle: Text(
                        '${widget.time.substring(0, 11)} at ${widget.time.substring(11, 16)}'),
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
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        minHeight: 0,
                      ),
                      child: ReadMoreText(
                        widget.postContent,
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
                    widget.image != ''
                        ? Image(image: NetworkImage(widget.image))
                        : const Gap(0.0001),
                    Gap(height * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            final User? user =
                                FirebaseAuth.instance.currentUser;
                            final uid = user?.uid;
                            if (widget.isLiked) {
                              ref2.child('like').child(uid!).remove();
                            } else {
                              ref2.child('like').update({
                                uid.toString(): uid,
                              }).then((value) {
                                Utils().toastMessages('Liked');
                              }).onError((error, stackTrace) {
                                Utils().toastMessages(error.toString());
                              });
                            }
                          },
                          child: SizedBox(
                              child: Row(
                            children: [
                              widget.isLiked
                                  ? Icon(
                                      Icons.thumb_up_alt_sharp,
                                      color: deepGreen,
                                    )
                                  : Icon(
                                      Icons.thumb_up_alt_sharp,
                                      color: black,
                                    ),
                              Gap(width * 0.03),
                              Text(widget.like.toString()),
                            ],
                          )),
                        ),
                        const Gap(2),
                        InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>CommentScreen(postKey: widget.postKey)));
                            },
                            child: const Icon(Icons.mode_comment)),
                      ],
                    ),
                    Gap(height * 0.01),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
