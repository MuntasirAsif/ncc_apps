import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../Utils/colors.dart';
import '../Utils/round_button.dart';
import '../Utils/utils.dart';

class ApplicationView extends StatefulWidget {
  final String uid;
  const ApplicationView({Key? key, required this.uid}) : super(key: key);

  @override
  State<ApplicationView> createState() => _ApplicationViewState();
}

class _ApplicationViewState extends State<ApplicationView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController positionController = TextEditingController();
  DatabaseReference ref = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL: 'https://ncc-apps-47109-default-rtdb.firebaseio.com')
      .ref("Applications");
  DatabaseReference ref2 = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: 'https://ncc-apps-47109-default-rtdb.firebaseio.com')
      .ref("user");
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/Background.png'),
                fit: BoxFit.fill)),
        child: SingleChildScrollView(
          child: SizedBox(
            height: height,
            width: width,
            child: StreamBuilder(
            stream: ref.child(widget.uid.toString()).onValue,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
              if(!snapshot.hasData){
                return const Center(child: CircularProgressIndicator());
              }else if(snapshot.hasData){
                final DataSnapshot data = snapshot.data!.snapshot;
                final Map<dynamic, dynamic>? map =
                data.value as Map<dynamic, dynamic>?;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        width: width,
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            border: Border.all()),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Stack(
                            children: [
                              Container(
                                width: 400,
                                height: 650,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(),
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      width: 80,
                                      height: 80,
                                      child: Image(
                                        image: AssetImage(
                                            'assets/images/logo.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Text(
                                      'Member Recruitment Form',
                                      style: textTheme.titleMedium,
                                    ),
                                    const Gap(5),
                                    SizedBox(
                                      width: 400,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .start,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        SizedBox(
                                                          width: 250,
                                                          child: RichText(
                                                              text: TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                        text:
                                                                        'Name: ',
                                                                        style: textTheme
                                                                            .bodySmall!
                                                                            .copyWith(
                                                                            fontWeight: FontWeight.bold)),
                                                                    TextSpan(
                                                                        text: map?[
                                                                        'name'],
                                                                        style: textTheme
                                                                            .bodySmall)
                                                                  ])),
                                                        )
                                                      ],
                                                    ),
                                                    const Gap(5),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .start,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        SizedBox(
                                                          width: 250,
                                                          child: RichText(
                                                              text: TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                        text:
                                                                        'ID: ',
                                                                        style: textTheme
                                                                            .bodySmall!
                                                                            .copyWith(
                                                                            fontWeight: FontWeight.bold)),
                                                                    TextSpan(
                                                                        text: map?[
                                                                        'id'],
                                                                        style: textTheme
                                                                            .bodySmall)
                                                                  ])),
                                                        )
                                                      ],
                                                    ),
                                                    const Gap(5),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .start,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        SizedBox(
                                                          width: 250,
                                                          child: RichText(
                                                              text: TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                        text:
                                                                        'Section: ',
                                                                        style: textTheme
                                                                            .bodySmall!
                                                                            .copyWith(
                                                                            fontWeight: FontWeight.bold)),
                                                                    TextSpan(
                                                                        text: map?[
                                                                        'section'],
                                                                        style: textTheme
                                                                            .bodySmall)
                                                                  ])),
                                                        )
                                                      ],
                                                    ),
                                                    const Gap(5),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .start,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        SizedBox(
                                                          width: 250,
                                                          child: RichText(
                                                              text: TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                        text:
                                                                        'Department: ',
                                                                        style: textTheme
                                                                            .bodySmall!
                                                                            .copyWith(
                                                                            fontWeight: FontWeight.bold)),
                                                                    TextSpan(
                                                                        text: map?[
                                                                        'dept'],
                                                                        style: textTheme
                                                                            .bodySmall)
                                                                  ])),
                                                        )
                                                      ],
                                                    ),
                                                    const Gap(5),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .start,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        SizedBox(
                                                          width: 250,
                                                          child: RichText(
                                                              text: TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                        text:
                                                                        'Apply for: ',
                                                                        style: textTheme
                                                                            .bodySmall!
                                                                            .copyWith(
                                                                            fontWeight: FontWeight.bold)),
                                                                    TextSpan(
                                                                        text: map?[
                                                                        'segment'],
                                                                        style: textTheme
                                                                            .bodySmall)
                                                                  ])),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Container(
                                                        height: 110,
                                                        width: 110,
                                                        padding:
                                                        const EdgeInsets
                                                            .all(2),
                                                        decoration:
                                                        BoxDecoration(
                                                            border: Border
                                                                .all()),
                                                        child: Image(
                                                          image: NetworkImage(
                                                            map?['Image'],
                                                          ),
                                                          fit: BoxFit.cover,
                                                        )),
                                                  ],
                                                )
                                              ],
                                            ),
                                            const Gap(5),
                                            Center(child: Text("Applicant Detail's",style: textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),)),
                                            const Gap(5),
                                            Row(
                                              children: [
                                                RichText(
                                                    text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                              text:
                                                              'Age: ',
                                                              style: textTheme
                                                                  .bodySmall!
                                                                  .copyWith(
                                                                  fontWeight: FontWeight.bold)),
                                                          TextSpan(
                                                              text: map?[
                                                              'age'],
                                                              style: textTheme
                                                                  .bodySmall)
                                                        ])),
                                                const Gap(50),
                                                RichText(
                                                    text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                              text:
                                                              'Gender: ',
                                                              style: textTheme
                                                                  .bodySmall!
                                                                  .copyWith(
                                                                  fontWeight: FontWeight.bold)),
                                                          TextSpan(
                                                              text: map?[
                                                              'gender'],
                                                              style: textTheme
                                                                  .bodySmall)
                                                        ])),
                                              ],
                                            ),
                                            RichText(
                                                text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                          text:
                                                          'E-mail: ',
                                                          style: textTheme
                                                              .bodySmall!
                                                              .copyWith(
                                                              fontWeight: FontWeight.bold)),
                                                      TextSpan(
                                                          text: map?[
                                                          'mail'],
                                                          style: textTheme
                                                              .bodySmall)
                                                    ])),
                                            RichText(
                                                text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                          text:
                                                          'Mobile Number: ',
                                                          style: textTheme
                                                              .bodySmall!
                                                              .copyWith(
                                                              fontWeight: FontWeight.bold)),
                                                      TextSpan(
                                                          text: '+880${map?['number']}',
                                                          style: textTheme
                                                              .bodySmall)
                                                    ])),
                                            RichText(
                                                text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                          text:
                                                          'Address: ',
                                                          style: textTheme
                                                              .bodySmall!
                                                              .copyWith(
                                                              fontWeight: FontWeight.bold)),
                                                      TextSpan(
                                                          text: map?['address'],
                                                          style: textTheme
                                                              .bodySmall)
                                                    ])),
                                            const Gap(5),
                                            const Divider(),
                                            const Gap(5),
                                            RichText(
                                                text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                          text:
                                                          "About Applicant's: ",
                                                          style: textTheme
                                                              .bodySmall!
                                                              .copyWith(
                                                              fontWeight: FontWeight.bold)),
                                                      TextSpan(
                                                          text: map?['about'],
                                                          style: textTheme
                                                              .bodySmall)
                                                    ])),
                                            const Gap(5),
                                            const Divider(),
                                            const Gap(5),
                                            RichText(
                                                text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                          text:
                                                          'Reason for joining NCC : ',
                                                          style: textTheme
                                                              .bodySmall!
                                                              .copyWith(
                                                              fontWeight: FontWeight.bold)),
                                                      TextSpan(
                                                          text: map?['reason'],
                                                          style: textTheme
                                                              .bodySmall)
                                                    ])),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                SizedBox(
                                                  height: 100,
                                                  width: 130,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      const Divider(),
                                                      Text("Applicant's Signature",style: textTheme.bodySmall,)
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 100,
                                                  width: 130,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      const Divider(),
                                                      Text("Executive's Signature",style: textTheme.bodySmall,)
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            const Gap(20),
                                            Center(child: Text("This is an auto-generated application by NCC",style: textTheme.labelSmall,))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                  left: 10,
                                  bottom: 6,
                                  child: Column(
                                    children: [
                                      RichText(
                                          text: TextSpan(
                                              children: [
                                                TextSpan(
                                                    text:
                                                    'Date: ',
                                                    style: textTheme
                                                        .labelSmall!.copyWith(fontSize: 8)),
                                                TextSpan(
                                                    text: map?[
                                                    'date'],
                                                    style: textTheme
                                                        .labelSmall!.copyWith(fontSize: 8))
                                              ])),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ),
                      Gap(height*0.01),
                  
                      Container(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                              onTap: () {
                                ref.child(widget.uid).remove();
                                Navigator.pop(context);
                              },
                              child: const RoundButton(
                                  inputText: 'Remove')),
                          InkWell(
                              onTap: () {
                                eidDialog();
                              },
                              child: const RoundButton(
                                  inputText: 'Accept')),
                        ],
                      ),
                      Gap(height*0.01),
                    ],
                  ),
                );
              } else{
                return const Text('Something Wrong');
              }
            }
            )
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
            title: const Text('Edit profile'),
            content: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: 0,
              ),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: positionController,
                  decoration: InputDecoration(
                    labelText: 'Position',
                    hintText: 'Position',
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
                  if(positionController.text.toString().length>1){
                    updateProfile();
                  }
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
  updateProfile() {
    ref2.child(widget.uid.toString()).update({
      'position': positionController.text.toString()
    }).then((value) {
      Navigator.pop(context);
      Navigator.pop(context);
      ref.child(widget.uid).remove();
      Utils().toastMessages('Member is Added');
    }).onError((e, stackTrace) {
      Utils().toastMessages(e.toString());
    });
  }
}
