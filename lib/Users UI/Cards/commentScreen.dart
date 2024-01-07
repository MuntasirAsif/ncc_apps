import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ncc_apps/Users%20UI/Cards/comment_view.dart';

import '../../Utils/colors.dart';
import '../../Utils/utils.dart';

class CommentScreen extends StatefulWidget {
  final String postKey;
  final String token;
  const CommentScreen({Key? key, required this.postKey, required this.token}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController commentController = TextEditingController();
  String body='';
  DatabaseReference ref = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL: 'https://ncc-apps-47109-default-rtdb.firebaseio.com')
      .ref("user");
  DatabaseReference ref2 = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL: 'https://ncc-apps-47109-default-rtdb.firebaseio.com')
      .ref("post");
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Container(
        height: height * 0.6,
        decoration: BoxDecoration(
          color: Colors.transparent,
            image: const DecorationImage(
                image: AssetImage('assets/images/Background.png'),
                fit: BoxFit.fill),
            border: Border.all(),
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: height * 0.05,
                decoration: BoxDecoration(
                    color: black.withOpacity(0.3),
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20))),
                child: Center(
                  child: Icon(
                    Icons.line_weight,
                    color: white,
                  ),
                ),
              ),
              Column(
                children: [
                  Gap(height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: width * 0.7,
                        child: TextFormField(
                          controller: commentController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Write Comment';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Write Comment',
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: black),
                                borderRadius: BorderRadius.circular(20)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: black),
                                borderRadius: BorderRadius.circular(20)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: black),
                                borderRadius: BorderRadius.circular(20)),
                            disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: black),
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                      ),
                      Gap(width * 0.02),
                      InkWell(
                        onTap: () {
                          addComment();
                          commentController.text ='';
                        },
                        child: Container(
                          height: height * 0.08,
                          width: width * 0.22,
                          decoration: BoxDecoration(
                              color: black,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                              child: Text(
                                'Post',
                                style: textTheme.titleMedium!.copyWith(color: white),
                              )),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: height*0.446,
                    child: FirebaseAnimatedList(
                      query: ref2.child(widget.postKey).child('Comment'),
                      sort: (DataSnapshot a, DataSnapshot b) {
                        return b.key!.compareTo(a.key!);
                      },
                      itemBuilder: (BuildContext context, DataSnapshot snapshot,
                          Animation<double> animation, int index) {
                        return SingleChildScrollView(
                          child: CommentView(
                              userId: snapshot.child('uid').value.toString(),
                              comment: snapshot.child('comment').value.toString()),
                        );
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      );
  }

  void addComment() {
    final User? user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    setState(() {
      body = commentController.text.toString();
    });
    try {
      ref2
          .child(widget.postKey)
          .child('Comment')
          .child(DateTime.now().microsecondsSinceEpoch.toString())
          .set(
        {
          'comment': commentController.text.toString(),
          'uid': uid,
        },
      ).then((value) {
        sendNotificationToAllUsers('Commented on your post',body,'comment');
        Utils().toastMessages('Comment Added');
      });
    } catch (e) {
      Utils().toastMessages(e.toString());
    }
  }
  Future<void> sendNotificationToAllUsers(String title, String body,String type) async {
    var data = {
      'to': widget.token,
      'priority': 'high',
      'notification': {
        'title': title,
        'body': body,
      },
      'data':{
        'type': type,
        'id' : DateTime.now().microsecondsSinceEpoch.toString()
      }
    };

    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'key=AAAA0btYFoE:APA91bHKoncgrtKxzGpfG7a-7iLZ-_icwj2ttzA0jEpUZuaFvNN2Xry2uP81Vf7a6iKk4V-4A4zs3is8EaRtci264zTuEkQHmIRVQcse3lf6_ruuB7se26Hhse21mMq2brAi2DGWS7Uo',
        },
      );
      if (kDebugMode) {
        print('Notification sent to all users');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error sending notification to all users: $e');
      }
    }
  }
}
