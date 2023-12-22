import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:ncc_apps/Auth_Service/reset_password.dart';
import 'package:ncc_apps/Auth_Service/sign_up_screen.dart';
import 'package:ncc_apps/Auth_Service/verification_screen.dart';
import '../Utils/colors.dart';
import '../Utils/round_button.dart';
import '../Utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool seePass = true;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
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
                    Gap(height * 0.02),
                    Center(
                      child: SizedBox(
                          height: height * 0.3,
                          width: width * 0.6,
                          child: const Image(
                            image: AssetImage('assets/images/logo.png'),
                            fit: BoxFit.fill,
                          )),
                    ),
                    Gap(height * 0.005),
                    Text('Log In',
                        style: textTheme.headlineLarge!
                            .copyWith(fontWeight: FontWeight.bold)),
                    Gap(height * 0.03),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
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
                      obscureText: seePass,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_open),
                        suffixIcon: InkWell(
                            onTap: () {
                              if (seePass) {
                                setState(() {
                                  seePass = false;
                                });
                              } else {
                                setState(() {
                                  seePass = true;
                                });
                              }
                            },
                            child: SizedBox(
                              height: 10,
                              width: 10,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 15, right: 15),
                                child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: seePass
                                        ? const FaIcon(
                                            FontAwesomeIcons.solidEye,
                                            size: 18,
                                          )
                                        : const FaIcon(
                                            FontAwesomeIcons.eyeLowVision,
                                            size: 18,
                                          )),
                              ),
                            )),
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
                    Gap(height * 0.005),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const ResetPassword()));
                        },
                        child: Text(
                          'Forget password? ',
                          style: textTheme.bodyMedium!.copyWith(color: Colors.deepPurple,fontStyle: FontStyle.italic ,fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Gap(height * 0.008),
                    InkWell(
                        onTap: () {
                          signInWithEmailAndPassword(
                              emailController.text.toString(),
                              passController.text.toString());
                        },
                        child: const RoundButton(
                          inputText: 'Log In',
                        )),
                    Gap(height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: textTheme.bodyMedium,
                        ),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUpScreen()),
                              );
                            },
                            child: Text(
                              "Sign-Up",
                              style: textTheme.bodyMedium!.copyWith(
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  fontStyle: FontStyle.italic),
                            ))
                      ],
                    ),
                    Gap(height * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                                width: width * 0.3,
                                child: Divider(
                                  thickness: 1,
                                  color: black,
                                ))
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'or',
                              style: textTheme.bodySmall,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(
                                width: width * 0.3,
                                child: Divider(
                                  thickness: 1,
                                  color: black,
                                ))
                          ],
                        ),
                      ],
                    ),
                    Gap(height * 0.02),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: width*0.03),
                        width: width*.8,
                        height: height*0.06,
                        decoration: BoxDecoration(
                          color: black.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(50)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: width * 0.1,
                                height: height*0.04,
                                child: const Image(
                                    image: AssetImage(
                                        'assets/images/google_logo.png'))),
                            Gap(width*0.03),
                            Text('Continue with Google',style: textTheme.titleMedium!.copyWith(color: white),)
                          ],
                        ),
                      ),
                    ),
                    Gap(height * 0.05),
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
      ),
    );
  }

  signInWithEmailAndPassword(String emailAddress, String password) {
    try {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      )
          .then((value) {
        Utils().toastMessages('Login Successfully');
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ConfirmScreen()));
      }).onError((error, stackTrace) {
        Utils().toastMessages(error.toString());
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Utils().toastMessages(e.toString());
      } else if (e.code == 'wrong-password') {
        Utils().toastMessages(e.toString());
      }
    }
  }
}
