import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:ncc_apps/Auth_Service/verification_screen.dart';
import '../Utils/colors.dart';
import '../Utils/round_button.dart';
import '../Utils/utils.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final batchController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();
  bool isAgree = false;
  var selectedDept = "";
  var rePass;
  DatabaseReference ref = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL: 'https://ncc-apps-47109-default-rtdb.firebaseio.com')
      .ref("user");
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/Background.png'),
                fit: BoxFit.fill)),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.06),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                        height: height * 0.2,
                        width: width * 0.4,
                        child: const Image(
                          image: AssetImage('assets/images/logo.png'),
                          fit: BoxFit.fill,
                        )),
                  ),
                  Text('Sign Up',
                      style: textTheme.headlineLarge!
                          .copyWith(fontWeight: FontWeight.bold)),
                  Gap(height * 0.03),
                  Form(
                      key: _formKey,
                      child: AutofillGroup(
                        child: Column(
                          children: [
                            TextFormField(
                              controller: nameController,
                              autofillHints: const [AutofillHints.name],
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter Name';
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.person),
                                hintText: 'Name',
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
                            Gap(height * 0.02),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              controller: batchController,
                              validator: (value) {
                                String batchText = value.toString();
                                int batch = int.parse(batchText);
                                if (value!.isEmpty) {
                                  return 'Enter Batch No';
                                } else if (batch >= 13 && batch <= 0) {
                                  return 'Batch is not exist';
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.confirmation_num),
                                helperText:
                                    'If you are Teacher then enter -"0"',
                                hintText: 'Batch No',
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
                            Gap(height * 0.02),
                            InkWell(
                              onTap: () {
                                showDepartmentDialog();
                              },
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  children: [
                                    const Gap(10),
                                    const Icon(Icons.home_work_outlined),
                                    const Gap(10),
                                    SizedBox(
                                      width: width * 0.75,
                                      child: Text(
                                        selectedDept == ""
                                            ? 'Select Department'
                                            : selectedDept,
                                        style: textTheme.bodyLarge,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Gap(height * 0.02),
                            TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: const [AutofillHints.email],
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter e-mail';
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.email_outlined),
                                hintText: 'E-mail',
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
                            Gap(height * 0.02),
                            TextFormField(
                              controller: passController,
                              autofillHints: const [AutofillHints.password],
                              validator: (value) {
                                rePass = value;
                                if (value!.isEmpty) {
                                  return 'Enter password';
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock_open),
                                hintText: 'Password',
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
                            Gap(height * 0.02),
                            TextFormField(
                              controller: confirmPassController,
                              autofillHints: const [AutofillHints.password],
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Confirm Password';
                                } else if (value != rePass.toString()) {
                                  return 'Password must be same';
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock_open),
                                hintText: 'Confirm-Password',
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
                            Gap(height * 0.02),
                          ],
                        ),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (isAgree == true) {
                              isAgree = false;
                            } else {
                              isAgree = true;
                            }
                          });
                          if (kDebugMode) {
                            print(isAgree);
                          }
                        },
                        child: Container(
                          height: height * 0.02,
                          width: width * 0.05,
                          decoration: BoxDecoration(border: Border.all()),
                          child: Icon(
                            Icons.check,
                            size: 15,
                            color: isAgree ? black : transparent,
                          ),
                        ),
                      ),
                      Gap(width * 0.02),
                      SizedBox(
                        height: height * 0.05,
                        width: width * 0.80,
                        child: RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: ' I agree all the ',
                              style: textTheme.bodyMedium),
                          TextSpan(
                              text: 'term',
                              style: textTheme.bodyMedium!.copyWith(
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.bold)),
                          TextSpan(text: ' and ', style: textTheme.bodyMedium),
                          TextSpan(
                              text: 'conditions',
                              style: textTheme.bodyMedium!.copyWith(
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: ' of NITER Computer Club',
                              style: textTheme.bodyMedium),
                        ])),
                      )
                    ],
                  ),
                  Gap(height * 0.02),
                  InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          if (selectedDept != "" && isAgree == true) {
                            createUserWithEmailAndPassword(
                                emailController.text.toString(),
                                passController.text.toString());
                            TextInput.finishAutofillContext();
                          }
                        }
                      },
                      child: const RoundButton(
                        inputText: 'Sign Up',
                      )),
                  Gap(height * 0.015),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: textTheme.bodyMedium,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          },
                          child: Text(
                            "Sign-In",
                            style: textTheme.bodyMedium!.copyWith(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                fontStyle: FontStyle.italic),
                          ))
                    ],
                  ),
                  Gap(height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.copyright,
                        size: 20,
                      ),
                      Text(
                        ' Copyright 2024',
                        style: textTheme.bodyMedium,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "All rights received by UCABM",
                        style: textTheme.bodySmall,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  createUserWithEmailAndPassword(String emailAddress, String password) async {
    try {
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      )
          .then((value) {
        Utils().toastMessages('SignUp Successfully');
        addUserInfo();
      }).onError((error, stackTrace) {
        Utils().toastMessages(error.toString());
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Utils().toastMessages(e.toString());
      } else if (e.code == 'email-already-in-use') {
        Utils().toastMessages(e.toString());
      }
    } catch (e) {
      Utils().toastMessages(e.toString());
    }
  }

  Future<void> addUserInfo() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    ref.child(uid!).set({
      'profileImage': '',
      'userType': 'User',
      'uid': uid,
      'userName': nameController.text.toString(),
      'email': emailController.text.toString(),
      'batch': batchController.text.toString(),
      'department': selectedDept.toString(),
      'id': '',
      'position': '',
    }).then((value) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ConfirmScreen()));
    }).onError((error, stackTrace) {
      Utils().toastMessages(error.toString());
    });
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
              height: height * 0.5,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          selectedDept = "Teacher";
                          Navigator.pop(context);
                        });
                      },
                      child: const ListTile(
                        leading: Icon(Icons.person),
                        title: Text('A Teacher'),
                      ),
                    ),
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
}
