import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ncc_apps/Exam%20Room/Card/question_view.dart';
import '../Utils/colors.dart';
import '../Utils/utils.dart';

class SetQuestion extends StatefulWidget {
  final bool isAdmin;
  final String name;
  const SetQuestion({super.key, required this.name, required this.isAdmin});

  @override
  State<SetQuestion> createState() => _SetQuestionState();
}

class _SetQuestionState extends State<SetQuestion> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController questionController = TextEditingController();
  TextEditingController questionNoController = TextEditingController();
  TextEditingController correctAnsController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    DatabaseReference ref = FirebaseDatabase.instanceFor(
            app: Firebase.app(),
            databaseURL: 'https://ncc-apps-47109-default-rtdb.firebaseio.com')
        .ref("Exam Hub/group/${widget.name}/Question");
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        title: Text('Create your question',
            style: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
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
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: height * 0.2,
                    maxHeight: height * 0.62,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                    ),
                    child: FirebaseAnimatedList(
                        query: ref,
                        itemBuilder: (context, snapshot, animation, index) {
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
                ),
                Gap(height * 0.01),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        maxLines: 15,
                        minLines: 1,
                        keyboardType: TextInputType.multiline,
                        controller: questionController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Question';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.question_mark),
                          hintText: 'Question',
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
                      Gap(height * 0.01),
                      TextFormField(
                        maxLines: 15,
                        minLines: 1,
                        keyboardType: TextInputType.multiline,
                        controller: correctAnsController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Name';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.question_answer),
                          hintText: 'Correct Answer',
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
                      Gap(height * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: width * 0.2,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: questionNoController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter Name';
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'Q. No',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: black),
                                    borderRadius: BorderRadius.circular(10)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: black),
                                    borderRadius: BorderRadius.circular(10)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: black),
                                    borderRadius: BorderRadius.circular(10)),
                                disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: black),
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                addQuestion();
                              }
                            },
                            child: Container(
                              height: height * 0.075,
                              width: width * 0.25,
                              decoration: BoxDecoration(
                                color: black,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                  child: Text(
                                'Add',
                                style: textTheme.titleMedium!
                                    .copyWith(color: white),
                              )),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addQuestion() {
    DatabaseReference ref = FirebaseDatabase.instanceFor(
            app: Firebase.app(),
            databaseURL: 'https://ncc-apps-47109-default-rtdb.firebaseio.com')
        .ref("Exam Hub//group/${widget.name}/Question");
    ref.child(questionNoController.text.toString()).set({
      'Question No': questionNoController.text.toString(),
      'Question': questionController.text.toString(),
      'Correct Ans': correctAnsController.text.toString(),
      'Ans': '',
    }).then((value) {
      questionNoController.text = '';
      questionController.text = '';
      correctAnsController.text = '';
      Utils().toastMessages('Question Added');
    }).onError((error, stackTrace) {
      Utils().toastMessages(error.toString());
    });
  }
}
