import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ncc_apps/Utils/round_button.dart';
import '../Utils/colors.dart';
import '../Utils/utils.dart';
import 'Card/question_view.dart';
import 'dart:core';

class UsersQuestionSet extends StatefulWidget {
  final bool isAdmin;
  final String name;
  final String time;
  const UsersQuestionSet(
      {super.key,
      required this.isAdmin,
      required this.name,
      required this.time,
      });

  @override
  State<UsersQuestionSet> createState() => _UsersQuestionSetState();
}

class _UsersQuestionSetState extends State<UsersQuestionSet> {
  int timesCount = 0;
  int timeSecond = 59;
  int times = 0;
  int k=0;
  var score=<int,int>{};
  bool canPop=false;
  Future<void> startCountdown() async {
    for(int j = timesCount; j >= 0; j--){
      if(j<1){
        setState(() {
          timeSecond = 59;
        });
      }
      setState(() {
        times =j;
      });

      for (int i = 59; i >= 0; i--) {
        await Future.delayed(const Duration(seconds: 1));
        setState(() {
          timeSecond = i;
        });
        if (kDebugMode) {
          print(times);
        }
      }
    }
    canPop=true;
    submission();
  }
  int getTime(){
    k++;
    int time = int.parse(widget.time)-1;
    return time;
  }
  @override
  Widget build(BuildContext context) {
    if(k==0){
      timesCount=getTime();
      startCountdown();
    }
    DatabaseReference ref = FirebaseDatabase.instanceFor(
            app: Firebase.app(),
            databaseURL: 'https://ncc-apps-47109-default-rtdb.firebaseio.com')
        .ref("Exam Hub/group/${widget.name}/Question");
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return PopScope(
      canPop: canPop,// prevent back
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: white,
          title: Text(widget.name,
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
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.02, vertical: height * 0.01),
              child: Column(
                children: [
                  Center(child:Text('Remaining Time: $times m $timeSecond s',style:
              textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),),
                  Container(
                    height: height * 0.75,
                    width: width,
                    decoration: BoxDecoration(
                      border: Border.all(),
                    ),
                    child: FirebaseAnimatedList(
                        query: ref,
                        itemBuilder: (context, snapshot, animation, index) {
                          if(snapshot.child('Correct Ans').value.toString().toLowerCase()==snapshot.child('Ans').value.toString().toLowerCase()){
                            score[index]=1;
                          }else{
                            score[index]=0;
                          }
                          if (kDebugMode) {
                            print(score);
                          }
                          return QuestionView(
                            question:
                                snapshot.child('Question').value.toString(),
                            correctAns:
                                snapshot.child('Correct Ans').value.toString(),
                            questionNo:
                                snapshot.child('Question No').value.toString(),
                            ans: snapshot.child('Ans').value.toString(),
                            name: widget.name,
                          );
                        }),
                  ),
                  Gap(height*0.01),
                  InkWell(
                    onTap: (){
                      submission();
                    },
                      child: const RoundButton(inputText: 'Submit')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  submission(){
    DatabaseReference ref2 = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: 'https://ncc-apps-47109-default-rtdb.firebaseio.com')
        .ref("Exam Hub/group");
    int point=0;
    for(int i=0; i<score.length;i++){
      if(score[i]==1){
        point++;
      }
    }
    ref2.child(widget.name).update({
      'Score':point.toString(),
      'Remaining Time': '$times.$timeSecond'
    }).then((value) {
      canPop=true;
      Utils().toastMessages('Submitted');
      Navigator.pop(context);
    }).onError((error, stackTrace) {
      Utils().toastMessages(error.toString());
    });
  }
}
