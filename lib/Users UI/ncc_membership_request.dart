// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ncc_apps/Utils/colors.dart';
import 'package:ncc_apps/Utils/round_button.dart';
import '../pdf/pdf_generate.dart';
import '../Utils/utils.dart';

class NCCMemberRequest extends StatefulWidget {
  String name;
  final String dept;
  String position;
  String photo;
  NCCMemberRequest(
      {Key? key,
      required this.photo,
      required this.name,
      required this.dept,
      required this.position})
      : super(key: key);

  @override
  State<NCCMemberRequest> createState() => _NCCMemberRequestState();
}

class _NCCMemberRequestState extends State<NCCMemberRequest> {
  String photo = '';
  late String url;
  File? image;
  final picker = ImagePicker();
  String gender = 'Select Gender';
  String section = 'Section';
  late bool isEditable;
  String chooseSegment = '';
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController skillController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController goalController = TextEditingController();

  DatabaseReference ref = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL: 'https://ncc-apps-47109-default-rtdb.firebaseio.com')
      .ref("Applications");
  @override
  Widget build(BuildContext context) {
    nameController.text = widget.name;
    final User? user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'NCC Membership',
          style: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
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
                          Gap(height * 0.01),
                          Center(
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  height: height * 0.145,
                                  width: height * 0.145,
                                  decoration: BoxDecoration(
                                      color: white,
                                      border: Border.all(width: 2),
                                      image: DecorationImage(
                                          image: NetworkImage(widget.photo),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(100)),
                                  child: widget.photo == ''
                                      ? const Icon(
                                          Icons.person,
                                          size: 20,
                                        )
                                      : const SizedBox(),
                                ),
                                InkWell(
                                  onTap: () {
                                    getImageGallery();
                                  },
                                  child: CircleAvatar(
                                      radius: 18,
                                      backgroundColor: black.withOpacity(0.7),
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: white,
                                      )),
                                )
                              ],
                            ),
                          ),
                          Gap(height * 0.02),
                          Text(
                            '* To get NCC membership fill-up the form & submit',
                            style: textTheme.bodyMedium,
                          ),
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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        height: height * 0.07,
                                        width: width * 0.45,
                                        child: TextFormField(
                                          controller: ageController,
                                          keyboardType: TextInputType.number,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Enter Age';
                                            } else {
                                              return null;
                                            }
                                          },
                                          decoration: InputDecoration(
                                            hintText: 'Age',
                                            border: OutlineInputBorder(
                                                borderSide:
                                                    BorderSide(color: black),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
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
                                                  child: Text(gender),
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
                                                      gender = 'Male';
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  child: SizedBox(
                                                    height: height * 0.04,
                                                    width: width * 0.3,
                                                    child: Text('Male',
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
                                                      gender = 'Female';
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  child: SizedBox(
                                                    height: height * 0.04,
                                                    width: width * 0.3,
                                                    child: Text('Female',
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
                                  Container(
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
                                    child: Text(widget.dept),
                                  ),
                                  Gap(height * 0.01),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
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
                                    ],
                                  ),
                                  Gap(height * 0.01),
                                  TextFormField(
                                    controller: skillController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter Skill';
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Best Skill',
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
                                  InkWell(
                                    onTap: () {
                                      showSegmentDialog();
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
                                      child: chooseSegment == ''
                                          ? const Text('Choose Segment')
                                          : Text(chooseSegment),
                                    ),
                                  ),
                                  Gap(height * 0.01),
                                  TextFormField(
                                    controller: addressController,
                                    autofillHints: const [
                                      AutofillHints.addressCityAndState
                                    ],
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter Address';
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Present Address',
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(color: black),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: black),
                                          borderRadius:
                                              BorderRadius.circular(20)),
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
                                    maxLines: 3,
                                    controller: noteController,
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'About Your self';
                                      } else if (value.length < 100) {
                                        return 'minimum 100 characters';
                                      } else {
                                        return null;
                                      }
                                    },
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(200),
                                    ],
                                    decoration: InputDecoration(
                                      hintText:
                                          'About your self (200 Characters)',
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(color: black),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: black),
                                          borderRadius:
                                              BorderRadius.circular(20)),
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
                                    maxLines: 3,
                                    controller: goalController,
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Why do you want to join NCC';
                                      } else if (value.length < 100) {
                                        return 'minimum 100 characters';
                                      } else {
                                        return null;
                                      }
                                    },
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(200),
                                    ],
                                    decoration: InputDecoration(
                                      hintText:
                                          'Why do you want to join NCC ? (200 characters)',
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(color: black),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: black),
                                          borderRadius:
                                              BorderRadius.circular(20)),
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
                                ],
                              )),
                          InkWell(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  if (chooseSegment != "" &&
                                      widget.dept.toString() != "") {
                                    addRequestPic(widget.photo);
                                  } else {
                                    if(chooseSegment != ""){
                                      Utils().toastMessages(
                                          'Please Select Your Department From profile');
                                    }else{
                                      Utils().toastMessages(
                                          'Choose Your Segment');
                                    }
                                  }
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
                      ageController.text = map?['age'];
                      idController.text = map?['id'];
                      skillController.text = map?['skill'];
                      gender = map?['gender'];
                      phoneNumberController.text = map?['number'];
                      addressController.text = map?['address'];
                      noteController.text = map?['about'];
                      goalController.text = map?['reason'];
                      return Column(
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
                                                                            .copyWith(fontWeight: FontWeight.bold)),
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
                                                                            .copyWith(fontWeight: FontWeight.bold)),
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
                                                                            .copyWith(fontWeight: FontWeight.bold)),
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
                                                                            .copyWith(fontWeight: FontWeight.bold)),
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
                                                                            .copyWith(fontWeight: FontWeight.bold)),
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
                                                              image:
                                                                  NetworkImage(
                                                                map?['Image'],
                                                              ),
                                                              fit: BoxFit.cover,
                                                            )),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                const Gap(5),
                                                Center(
                                                    child: Text(
                                                  "Applicant Detail's",
                                                  style: textTheme.bodySmall!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                )),
                                                const Gap(5),
                                                Row(
                                                  children: [
                                                    RichText(
                                                        text:
                                                            TextSpan(children: [
                                                      TextSpan(
                                                          text: 'Age: ',
                                                          style: textTheme
                                                              .bodySmall!
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                      TextSpan(
                                                          text: map?['age'],
                                                          style: textTheme
                                                              .bodySmall)
                                                    ])),
                                                    const Gap(50),
                                                    RichText(
                                                        text:
                                                            TextSpan(children: [
                                                      TextSpan(
                                                          text: 'Gender: ',
                                                          style: textTheme
                                                              .bodySmall!
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                      TextSpan(
                                                          text: map?['gender'],
                                                          style: textTheme
                                                              .bodySmall)
                                                    ])),
                                                  ],
                                                ),
                                                RichText(
                                                    text: TextSpan(children: [
                                                  TextSpan(
                                                      text: 'E-mail: ',
                                                      style: textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                  TextSpan(
                                                      text: map?['mail'],
                                                      style:
                                                          textTheme.bodySmall)
                                                ])),
                                                RichText(
                                                    text: TextSpan(children: [
                                                  TextSpan(
                                                      text: 'Mobile Number: ',
                                                      style: textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                  TextSpan(
                                                      text:
                                                          '+88${map?['number']}',
                                                      style:
                                                          textTheme.bodySmall)
                                                ])),
                                                RichText(
                                                    text: TextSpan(children: [
                                                  TextSpan(
                                                      text: 'Address: ',
                                                      style: textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                  TextSpan(
                                                      text: map?['address'],
                                                      style:
                                                          textTheme.bodySmall)
                                                ])),
                                                const Gap(5),
                                                const Divider(),
                                                const Gap(5),
                                                RichText(
                                                    text: TextSpan(children: [
                                                  TextSpan(
                                                      text:
                                                          "About Applicant's: ",
                                                      style: textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                  TextSpan(
                                                      text: map?['about'],
                                                      style:
                                                          textTheme.bodySmall)
                                                ])),
                                                const Gap(5),
                                                const Divider(),
                                                const Gap(5),
                                                RichText(
                                                    text: TextSpan(children: [
                                                  TextSpan(
                                                      text:
                                                          'Reason for joining NCC : ',
                                                      style: textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                  TextSpan(
                                                      text: map?['reason'],
                                                      style:
                                                          textTheme.bodySmall)
                                                ])),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    SizedBox(
                                                      height: 100,
                                                      width: 130,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Divider(),
                                                          Text(
                                                            "Applicant's Signature",
                                                            style: textTheme
                                                                .bodySmall,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 100,
                                                      width: 130,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Divider(),
                                                          Text(
                                                            "Executive's Signature",
                                                            style: textTheme
                                                                .bodySmall,
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                const Gap(20),
                                                Center(
                                                    child: Text(
                                                  "This is an auto-generated application by NCC",
                                                  style: textTheme.labelSmall,
                                                ))
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
                                              text: TextSpan(children: [
                                            TextSpan(
                                                text: 'Date: ',
                                                style: textTheme.labelSmall!
                                                    .copyWith(fontSize: 8)),
                                            TextSpan(
                                                text: map?['date'],
                                                style: textTheme.labelSmall!
                                                    .copyWith(fontSize: 8))
                                          ])),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          ),
                          Gap(height * 0.01),
                          const Text('You already submit this Application'),
                          Gap(height * 0.01),
                          Container(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                  onTap: () {
                                    ref.child(uid!).update({
                                      'dept': '',
                                    });
                                  },
                                  child: const RoundButton(
                                      inputText: 'Edit Application')),
                              InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> GeneratePDF(map: map,)));
                                  },
                                  child: const RoundButton(
                                      inputText: 'Download PDF')),
                            ],
                          ),
                          Gap(height * 0.01),
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

  Future getImageGallery() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
        uploadPic(image!);
      } else {
        Utils().toastMessages('No image Selected');
      }
    });
  }

  uploadPic(File image) async {
    final User? user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    FirebaseStorage storage =
        FirebaseStorage.instanceFor(bucket: 'gs://ncc-apps-47109.appspot.com');
    Reference storageRef =
        storage.ref().child('Application').child("Application_Image $uid");
    UploadTask uploadTask = storageRef.putFile(image);
    Future.value(uploadTask).then((value) async {
      url = await storageRef.getDownloadURL();
      setState(() {
        widget.photo = url;
      });
      addRequestPic(url);
    }).catchError((onError) {
      Utils().toastMessages(onError);
    });
  }

  showSegmentDialog() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Choose your segment'),
            content: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                        onTap: () {
                          setState(() {
                            chooseSegment = "Competitive Programming";
                            Navigator.pop(context);
                          });
                        },
                        child: Container(
                            height: height * 0.05,
                            width: width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all()),
                            child: const Center(
                                child: Text('Competitive Programming')))),
                    Gap(height * 0.02),
                    InkWell(
                        onTap: () {
                          setState(() {
                            chooseSegment = "Cyber Security";
                            Navigator.pop(context);
                          });
                        },
                        child: Container(
                            height: height * 0.05,
                            width: width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all()),
                            child:
                                const Center(child: Text('Cyber Security')))),
                    Gap(height * 0.02),
                    InkWell(
                        onTap: () {
                          setState(() {
                            chooseSegment = "App Development";
                            Navigator.pop(context);
                          });
                        },
                        child: Container(
                            height: height * 0.05,
                            width: width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all()),
                            child:
                                const Center(child: Text('App Development')))),
                    Gap(height * 0.02),
                    InkWell(
                      onTap: () {
                        setState(() {
                          chooseSegment = "Web Development";
                          Navigator.pop(context);
                        });
                      },
                      child: Container(
                          height: height * 0.05,
                          width: width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all()),
                          child: const Center(child: Text('Web Development'))),
                    ),
                    Gap(height * 0.02),
                    InkWell(
                      onTap: () {
                        setState(() {
                          chooseSegment = "Graphic Design";
                          Navigator.pop(context);
                        });
                      },
                      child: Container(
                          height: height * 0.05,
                          width: width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all()),
                          child: const Center(child: Text('Graphic Design'))),
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

  addRequestPic(String url) {
    final User? user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    ref.child(uid!).update({
      'Image': url,
      'name': nameController.text.toString(),
      'age': ageController.text.toString(),
      'gender': gender.toString(),
      'section': section.toString(),
      'dept': widget.dept.toString(),
      'mail': mailController.text.toString(),
      'number': phoneNumberController.text.toString(),
      'id': idController.text.toString(),
      'skill': skillController.text.toString(),
      'segment': chooseSegment.toString(),
      'address': addressController.text.toString(),
      'about': noteController.text.toString(),
      'reason': goalController.text.toString(),
      'uid': uid.toString(),
      'date':
          "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
    }).then((value) {
      Utils().toastMessages('Submitted');
    }).onError((error, stackTrace) {
      Utils().toastMessages(error.toString());
    });
  }
}
