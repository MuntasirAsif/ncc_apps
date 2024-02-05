import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ncc_apps/Exam%20Room/Card/group_view.dart';
import 'package:ncc_apps/Exam%20Room/set_question.dart';
import 'package:ncc_apps/Exam%20Room/user_question_set.dart';
import 'package:ncc_apps/Utils/utils.dart';
import '../Utils/colors.dart';

class ExamGroup extends StatefulWidget {
  final bool isAdmin;
  const ExamGroup({super.key, required this.isAdmin});

  @override
  State<ExamGroup> createState() => _ExamGroupState();
}

class _ExamGroupState extends State<ExamGroup> {
  TextEditingController checkKeyController = TextEditingController();
  TextEditingController groupNameController = TextEditingController();
  TextEditingController keyController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DatabaseReference ref = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL: 'https://ncc-apps-47109-default-rtdb.firebaseio.com')
      .ref("Exam Hub/group");
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        title: Text('Exam Group',
            style: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
        actions: [
          widget.isAdmin
              ? InkWell(
                  onTap: () {
                    addGroup();
                  },
                  child: Icon(
                    Icons.group_add,
                    color: black,
                  ))
              : const SizedBox(),
          Gap(width * 0.05)
        ],
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
            child: Container(
              height: height - 120,
              width: width,
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              child: FirebaseAnimatedList(
                  query: ref,
                  itemBuilder: (context, snapshot, animation, index) {
                    return InkWell(
                      onTap: () {
                        if((snapshot.child('Remaining Time').exists==false)||widget.isAdmin){
                          checkGroup(
                            snapshot.child('name').value.toString(),
                            snapshot.child('key').value.toString(),
                            snapshot.child('time').value.toString(),
                          );
                        }else{
                          Utils().toastMessages('Already Submitted Answer');
                        }
                      },
                      child: GroupView(
                        roomName: snapshot.child('name').value.toString(),
                        roomKey: snapshot.child('key').value.toString(),
                        time: snapshot.child('time').value.toString(),
                        isAdmin: widget.isAdmin,
                      ),
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }

  checkGroup(String groupName, String groupKey, String time) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [SizedBox(child: Text(groupName))],
            ),
            content: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 0, maxWidth: 0),
              child: SizedBox(
                height: height * 0.18,
                child: Column(
                  children: [
                    TextFormField(
                      controller: checkKeyController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.password),
                        hintText: 'Group Key',
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            margin: EdgeInsets.all(width * 0.02),
                            height: height * 0.05,
                            width: width * 0.2,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all()),
                            child: Center(
                                child: Text(
                              'Cancel',
                              style: textTheme.titleMedium,
                            )),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (checkKeyController.text == groupKey) {
                              Navigator.pop(context);
                              if (widget.isAdmin) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SetQuestion(
                                              name: groupName,
                                              isAdmin: widget.isAdmin,
                                            )));
                              } else {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>UsersQuestionSet(
                                  name: groupName,
                                  isAdmin: widget.isAdmin,
                                  time: time,
                                )));
                              }
                            } else {
                              Utils().toastMessages('Enter Correct Key');
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.all(width * 0.02),
                            height: height * 0.05,
                            width: width * 0.2,
                            decoration: BoxDecoration(
                              color: black,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                                child: Text(
                              'Enter',
                              style:
                                  textTheme.titleMedium!.copyWith(color: white),
                            )),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  addGroup() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(
                  Icons.group,
                ),
                Gap(10),
                SizedBox(child: Text('Add Group'))
              ],
            ),
            content: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 0, maxWidth: 0),
              child: SizedBox(
                height: height * 0.33,
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: groupNameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter Name';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.group),
                            hintText: 'Group Name',
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
                          controller: keyController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter Name';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.password),
                            hintText: 'Group Key',
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
                          controller: timeController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter Name';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock_clock),
                            hintText: 'Exam time duration',
                            labelText: 'Minutes',
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
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                //addQuestion();
                                Navigator.pop(context);
                              },
                              child: Container(
                                margin: EdgeInsets.all(width * 0.02),
                                height: height * 0.05,
                                width: width * 0.2,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all()),
                                child: Center(
                                    child: Text(
                                  'Cancel',
                                  style: textTheme.titleMedium,
                                )),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  addGroupInfo();
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.all(width * 0.02),
                                height: height * 0.05,
                                width: width * 0.2,
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
                ),
              ),
            ),
          );
        });
  }

  void addGroupInfo() {
    ref.child(groupNameController.text.toString()).set({
      'name': groupNameController.text.toString(),
      'key': keyController.text.toString(),
      'time': timeController.text.toString(),
      'Score': '',
    }).then((value) {
      groupNameController.text = '';
      keyController.text = '';
      Navigator.pop(context);
      Utils().toastMessages('Group Created');
    }).onError((error, stackTrace) {
      Utils().toastMessages(error.toString());
    });
  }
}
