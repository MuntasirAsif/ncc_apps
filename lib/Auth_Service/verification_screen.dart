import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ncc_apps/bottom_Bar.dart';
import 'package:ncc_apps/Utils/utils.dart';

import '../Utils/colors.dart';
import '../Utils/round_button.dart';

class ConfirmScreen extends StatefulWidget {
  const ConfirmScreen({Key? key}) : super(key: key);

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) {
      timer?.cancel();
    }
  }

  Future sendVerificationEmail() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      await user
          ?.sendEmailVerification();
      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => canResendEmail = true);// Use sendEmailVerification instead of sendVerificationEmail
    } catch (e) {
      Utils().toastMessages(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return isEmailVerified? const BottomBar() : Scaffold(
      appBar: AppBar(
        title: const Text('E--mail Verification'),
      ),
      body: SingleChildScrollView(
        child: Container(
            height: height,
            width: width,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/Background.png'),
                    fit: BoxFit.fill)),
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(color: black.withOpacity(0.3)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                child: Column(
                  children: [
                    SizedBox(
                        height: height * 0.35,
                        child:
                            Image.asset('assets/images/Mail Verification.png')),
                    Text(
                      "Verify your e-mail",
                      style: textTheme.displaySmall!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "An email has been sent to your provided email"
                      " account. A verification link has been sent"
                      " to the mail. Verify your account by clicking "
                      "on that link.",
                      style: textTheme.bodyMedium!
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                    Gap(height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Didn't get mail",
                          style: textTheme.bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Icon(
                          Icons.arrow_right_alt_sharp,
                          size: 24,
                        ),
                        InkWell(
                          onTap: (){
                            if(canResendEmail){
                              sendVerificationEmail();
                              Utils().toastMessages('Resend Email');
                            }
                            else{
                              Utils().toastMessages('Resend after 5 seconds');
                            }
                          },
                            child: const RoundButton(inputText: 'Resent')),
                      ],
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
