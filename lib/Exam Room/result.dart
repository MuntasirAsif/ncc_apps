import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import '../Utils/colors.dart';
import 'Card/group_result_view.dart';
import 'Card/group_view.dart';

class Result extends StatefulWidget {
  const Result({super.key});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  DatabaseReference ref = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: 'https://ncc-apps-47109-default-rtdb.firebaseio.com')
      .ref("Exam Hub/group");
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    print(height);
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        title: Text('Result',
            style:
            textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
      ),
      body: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/Background.png'),
                fit: BoxFit.fill)),
        child: SingleChildScrollView(
          child: Container(
            height: height-100,
            width: width,
            decoration: BoxDecoration(
              border: Border.all()
            ),
            child: FirebaseAnimatedList(
                query: ref,
                itemBuilder: (context, snapshot, animation, index) {
                  return GroupResultView(
                    roomName: snapshot.child('name').value.toString(),
                    point: snapshot.child('Score').value.toString(),
                    time: snapshot.child('Remaining Time').value.toString(),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
