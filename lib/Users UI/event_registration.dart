import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../Utils/colors.dart';
import '../Utils/round_button.dart';
import '../Utils/utils.dart';

class EventRegistration extends StatefulWidget {
  const EventRegistration({super.key});

  @override
  State<EventRegistration> createState() => _EventRegistrationState();
}

class _EventRegistrationState extends State<EventRegistration> {
  String section = 'Section';
  String selectedDept = '';
  late bool isEditable;
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController mailController = TextEditingController();

  DatabaseReference ref = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: 'https://ncc-apps-47109-default-rtdb.firebaseio.com')
      .ref("Event/Registration");
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
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
                stream: ref.child(uid.toString()).onValue,
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
                    isEditable =
                    ((map?['dept'] == '') || (map?['dept'] == null));
                    if (isEditable) {
                      return Column(
                        children: [
                          Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Gap(height * 0.01),
                                  TextFormField(
                                    controller: nameController,
                                    decoration: InputDecoration(
                                      hintText: 'Name',
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(color: black),
                                          borderRadius:
                                          BorderRadius.circular(10)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: black),
                                          borderRadius:
                                          BorderRadius.circular(10)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: black),
                                          borderRadius:
                                          BorderRadius.circular(10)),
                                      disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: black),
                                          borderRadius:
                                          BorderRadius.circular(10)),
                                      errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: red),
                                          borderRadius:
                                          BorderRadius.circular(10)),
                                    ),
                                  ),
                                  Gap(height * 0.01),
                                  TextFormField(
                                    controller: mailController,
                                    autofillHints: const [AutofillHints.email],
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter email';
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'E-mail',
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(color: black),
                                          borderRadius:
                                          BorderRadius.circular(10)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: black),
                                          borderRadius:
                                          BorderRadius.circular(10)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: black),
                                          borderRadius:
                                          BorderRadius.circular(10)),
                                      disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: black),
                                          borderRadius:
                                          BorderRadius.circular(10)),
                                      errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: red),
                                          borderRadius:
                                          BorderRadius.circular(10)),
                                    ),
                                  ),
                                  Gap(height * 0.01),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: height * 0.07,
                                        width: width * 0.2,
                                        decoration: BoxDecoration(
                                            border: Border.all(),
                                            borderRadius:
                                            const BorderRadius.only(
                                                topLeft:
                                                Radius.circular(10),
                                                bottomLeft:
                                                Radius.circular(10))),
                                        child:
                                        const Center(child: Text('+88')),
                                      ),
                                      SizedBox(
                                        height: height * 0.07,
                                        width: width * 0.74,
                                        child: TextFormField(
                                          controller: phoneNumberController,
                                          keyboardType: TextInputType.number,
                                          autofillHints: const [
                                            AutofillHints.telephoneNumber
                                          ],
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Enter Name';
                                            } else {
                                              return null;
                                            }
                                          },
                                          decoration: InputDecoration(
                                            hintText: 'Number',
                                            border: OutlineInputBorder(
                                                borderSide:
                                                BorderSide(color: black),
                                                borderRadius:
                                                const BorderRadius.only(
                                                    topRight:
                                                    Radius.circular(10),
                                                    bottomRight:
                                                    Radius.circular(
                                                        10))),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide:
                                                BorderSide(color: black),
                                                borderRadius:
                                                const BorderRadius.only(
                                                    topRight:
                                                    Radius.circular(10),
                                                    bottomRight:
                                                    Radius.circular(
                                                        10))),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide:
                                                BorderSide(color: black),
                                                borderRadius:
                                                const BorderRadius.only(
                                                    topRight:
                                                    Radius.circular(10),
                                                    bottomRight:
                                                    Radius.circular(
                                                        10))),
                                            disabledBorder: OutlineInputBorder(
                                                borderSide:
                                                BorderSide(color: black),
                                                borderRadius:
                                                const BorderRadius.only(
                                                    topRight:
                                                    Radius.circular(10),
                                                    bottomRight:
                                                    Radius.circular(
                                                        10))),
                                            errorBorder: OutlineInputBorder(
                                                borderSide:
                                                BorderSide(color: red),
                                                borderRadius:
                                                BorderRadius.circular(10)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Gap(height * 0.01),
                                  InkWell(
                                    onTap: (){
                                      showDepartmentDialog();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width * .03,
                                          vertical: height * 0.02),
                                      height: height * 0.07,
                                      width: width * 0.95,
                                      decoration: BoxDecoration(
                                          color: white.withOpacity(0.4),
                                          border: Border.all(),
                                          borderRadius:
                                          BorderRadius.circular(10)),
                                      child: selectedDept==''?const Text('Select Department'):Text(selectedDept),
                                    ),
                                  ),
                                  Gap(height * 0.01),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        height: height * 0.07,
                                        width: width * 0.45,
                                        child: TextFormField(
                                          controller: idController,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Enter ID';
                                            } else {
                                              return null;
                                            }
                                          },
                                          decoration: InputDecoration(
                                            hintText: 'ID',
                                            border: OutlineInputBorder(
                                                borderSide:
                                                BorderSide(color: black),
                                                borderRadius:
                                                BorderRadius.circular(20)),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide:
                                                BorderSide(color: black),
                                                borderRadius:
                                                BorderRadius.circular(10)),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide:
                                                BorderSide(color: black),
                                                borderRadius:
                                                BorderRadius.circular(10)),
                                            disabledBorder: OutlineInputBorder(
                                                borderSide:
                                                BorderSide(color: black),
                                                borderRadius:
                                                BorderRadius.circular(10)),
                                            errorBorder: OutlineInputBorder(
                                                borderSide:
                                                BorderSide(color: red),
                                                borderRadius:
                                                BorderRadius.circular(10)),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: width * .03,
                                        ),
                                        height: height * 0.07,
                                        width: width * 0.45,
                                        decoration: BoxDecoration(
                                            border: Border.all(),
                                            borderRadius:
                                            BorderRadius.circular(10)),
                                        child: SizedBox(
                                          child: PopupMenuButton(
                                            icon: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: width * 0.28,
                                                  child: Text(section),
                                                ),
                                                const Icon(Icons
                                                    .arrow_drop_down_sharp),
                                              ],
                                            ),
                                            itemBuilder: (context) => [
                                              PopupMenuItem(
                                                value: 1,
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      section = 'Sec - A';
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  child: SizedBox(
                                                    height: height * 0.04,
                                                    width: width * 0.1,
                                                    child: Text('A',
                                                        style: textTheme
                                                            .titleSmall!
                                                            .copyWith(
                                                            fontWeight:
                                                            FontWeight
                                                                .w400)),
                                                  ),
                                                ),
                                              ),
                                              PopupMenuItem(
                                                value: 1,
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      section = 'Sec - B';
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  child: SizedBox(
                                                    height: height * 0.04,
                                                    width: width * 0.1,
                                                    child: Text('B',
                                                        style: textTheme
                                                            .titleSmall!
                                                            .copyWith(
                                                            fontWeight:
                                                            FontWeight
                                                                .w400)),
                                                  ),
                                                ),
                                              ),
                                              PopupMenuItem(
                                                value: 1,
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      section = 'Sec - C';
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  child: SizedBox(
                                                    height: height * 0.04,
                                                    width: width * 0.1,
                                                    child: Text('C',
                                                        style: textTheme
                                                            .titleSmall!
                                                            .copyWith(
                                                            fontWeight:
                                                            FontWeight
                                                                .w400)),
                                                  ),
                                                ),
                                              ),
                                              PopupMenuItem(
                                                value: 1,
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      section = 'Sec - D';
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  child: SizedBox(
                                                    height: height * 0.04,
                                                    width: width * 0.1,
                                                    child: Text('D',
                                                        style: textTheme
                                                            .titleSmall!
                                                            .copyWith(
                                                            fontWeight:
                                                            FontWeight
                                                                .w400)),
                                                  ),
                                                ),
                                              ),
                                              PopupMenuItem(
                                                value: 1,
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      section = 'Sec - E';
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  child: SizedBox(
                                                    height: height * 0.04,
                                                    width: width * 0.1,
                                                    child: Text('E',
                                                        style: textTheme
                                                            .titleSmall!
                                                            .copyWith(
                                                            fontWeight:
                                                            FontWeight
                                                                .w400)),
                                                  ),
                                                ),
                                              ),
                                              PopupMenuItem(
                                                value: 1,
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      section = 'Sec - F';
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  child: SizedBox(
                                                    height: height * 0.04,
                                                    width: width * 0.1,
                                                    child: Text('F',
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
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Gap(height*0.03),
                          InkWell(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  addRequestPic();
                                  } else {
                                    Utils().toastMessages('');
                                  }
                                },
                              child: const RoundButton(inputText: 'Submit')),
                          Gap(height * 0.01),
                        ],
                      );
                    } else {
                      nameController.text = map?['name'];
                      mailController.text = map?['mail'];
                      section = map?['section'];
                      idController.text = map?['id'];
                      phoneNumberController.text = map?['number'];
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
                                          text: 'ID: ',
                                          style: textTheme.titleMedium),
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
                                          text: map?['status']==""? 'Unpaid':map?['status'],
                                          style: textTheme.bodyLarge)
                                    ])),
                              ],
                            ),
                          ),
                          Gap(height * 0.01),
                          const Text('You already complete your registration'),
                          Gap(height * 0.01),
                          map?['status']==''?InkWell(
                              onTap: () {
                                ref.child(uid!).remove();
                              },
                              child: const RoundButton(
                                  inputText: 'Delete')):const SizedBox(),
                        ],
                      );
                    }
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
  showDepartmentDialog() {
    final height = MediaQuery.of(context).size.height;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(
                  Icons.home_work_outlined,
                ),
                Gap(10),
                SizedBox(child: Text('Select Department'))
              ],
            ),
            content: SizedBox(
              height: height * 0.4,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    InkWell(
                        onTap: () {
                          setState(() {
                            selectedDept =
                            "Computer Science & Engineering-(CSE)";
                            Navigator.pop(context);
                          });
                        },
                        child: const ListTile(
                          leading: Icon(Icons.computer),
                          title: Text('Computer Science & Engineering-(CSE)'),
                        )),
                    InkWell(
                      onTap: () {
                        setState(() {
                          selectedDept =
                          "Electrical & Electronics Engineering-(EEE)";
                          Navigator.pop(context);
                        });
                      },
                      child: const ListTile(
                        leading: Icon(Icons.electrical_services),
                        title:
                        Text('Electrical & Electronics Engineering-(EEE)'),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          selectedDept = "Textile Engineering-(TE)";
                          Navigator.pop(context);
                        });
                      },
                      child: const ListTile(
                        leading: Icon(Icons.paragliding),
                        title: Text('Textile Engineering-(TE)'),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          selectedDept =
                          "Industrial & Production Engineering-(IPE)";
                          Navigator.pop(context);
                        });
                      },
                      child: const ListTile(
                        leading: Icon(Icons.production_quantity_limits),
                        title:
                        Text('Industrial & Production Engineering-(IPE)'),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          selectedDept =
                          "Fashion Design & Apparel Engineering-(FDAE)";
                          Navigator.pop(context);
                        });
                      },
                      child: const ListTile(
                        leading: Icon(Icons.color_lens),
                        title:
                        Text('Fashion Design & Apparel Engineering-(FDAE)'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
            ],
          );
        });
  }
  addRequestPic() {
    final User? user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    ref.child(uid!).update({
      'name': nameController.text.toString(),
      'section': section.toString(),
      'dept': selectedDept,
      'mail': mailController.text.toString(),
      'number': phoneNumberController.text.toString(),
      'id': idController.text.toString(),
      'uid': uid.toString(),
      'status': '',
    }).then((value) {
      Utils().toastMessages('Submitted');
    }).onError((error, stackTrace) {
      Utils().toastMessages(error.toString());
    });
  }
}
