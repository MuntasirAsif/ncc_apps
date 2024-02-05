import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../Utils/colors.dart';
import '../Utils/round_button.dart';
import '../Utils/utils.dart';

class RegisteredView extends StatefulWidget {
  final String uid;
  const RegisteredView({super.key, required this.uid});

  @override
  State<RegisteredView> createState() => _RegisteredViewState();
}

class _RegisteredViewState extends State<RegisteredView> {
  DatabaseReference ref = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL: 'https://ncc-apps-47109-default-rtdb.firebaseio.com')
      .ref("Event/Registration");
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        title: Text('Registration',
            style: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
      ),
      body: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/Background.png'),
                fit: BoxFit.fill)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.03),
          child: SingleChildScrollView(
            child: Center(
              child: StreamBuilder(
                stream: ref.child(widget.uid.toString()).onValue,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    final DataSnapshot data = snapshot.data!.snapshot;
                    final Map<dynamic, dynamic>? map =
                        data.value as Map<dynamic, dynamic>?;

                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          width: width,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              border: Border.all()),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text: 'Name: ',
                                    style: textTheme.titleMedium),
                                TextSpan(
                                    text: map?['name'],
                                    style: textTheme.bodyLarge)
                              ])),
                              RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text: 'Department: ',
                                    style: textTheme.titleMedium),
                                TextSpan(
                                    text: map?['dept'],
                                    style: textTheme.bodyLarge)
                              ])),
                              RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text: 'ID: ', style: textTheme.titleMedium),
                                TextSpan(
                                    text: map?['id'],
                                    style: textTheme.bodyLarge)
                              ])),
                              RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text: 'Section: ',
                                    style: textTheme.titleMedium),
                                TextSpan(
                                    text: map?['section'],
                                    style: textTheme.bodyLarge)
                              ])),
                              RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text: 'Email: ',
                                    style: textTheme.titleMedium),
                                TextSpan(
                                    text: map?['mail'],
                                    style: textTheme.bodyLarge)
                              ])),
                              RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text: 'Mobile No: ',
                                    style: textTheme.titleMedium),
                                TextSpan(
                                    text: map?['number'],
                                    style: textTheme.bodyLarge)
                              ])),
                              RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text: 'Status: ',
                                    style: textTheme.titleMedium),
                                TextSpan(
                                    text: map?['status'],
                                    style: textTheme.bodyLarge)
                              ])),
                            ],
                          ),
                        ),
                        Gap(height * 0.01),
                        const Text('If he or she is paid the registration fees please accept'),
                        Gap(height * 0.01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                                onTap: () {
                                  ref.child(widget.uid).remove();
                                },
                                child: const RoundButton(inputText: 'Delete')),
                            InkWell(
                                onTap: () {
                                  eidDialog();
                                },
                                child: const RoundButton(inputText: 'Accept')),
                          ],
                        ),
                      ],
                    );
                  } else {
                    return const Center(child: Text('Something Wrong'));
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  eidDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          final height = MediaQuery.of(context).size.height;
          final width = MediaQuery.of(context).size.width;
          final textTheme = Theme.of(context).textTheme;
          return AlertDialog(
            backgroundColor: white,
            title: const Text('Paid!'),
            content: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: 0,
              ),
              child: const Text(' Are you sure he/she paid the fees?'),
            ),
            actions: [
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: textTheme.titleSmall!.copyWith(color: red),
                  )),
              InkWell(
                onTap: () {
                  updatePaidStatus();
                },
                child: Container(
                  height: height * 0.05,
                  width: width * 0.2,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15), color: black),
                  child: Center(
                      child: Text(
                    'Update',
                    style: textTheme.titleMedium!.copyWith(color: white),
                  )),
                ),
              )
            ],
          );
        });
  }

  updatePaidStatus() {
    ref.child(widget.uid.toString()).update({
      'status': 'Paid',
    }).then((value) {
      Navigator.pop(context);
      Utils().toastMessages('Added in paid list');
    }).onError((e, stackTrace) {
      Utils().toastMessages(e.toString());
    });
  }
}
