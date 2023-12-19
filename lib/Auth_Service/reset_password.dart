import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ncc_apps/Utils/colors.dart';
import 'package:ncc_apps/Utils/round_button.dart';

import '../Utils/utils.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final emailController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    super.dispose();
  }
  Future passwordReset() async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
      Utils().toastMessages('Check Your E-mail.');
    }on FirebaseAuthException catch(e){
      Utils().toastMessages(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text(
          'Reset Password',
          style: textTheme.titleLarge,
        ),
        backgroundColor: white,
      ),
      body: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/Background.png'),
                fit: BoxFit.fill)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * .04),
            child: Column(
              children: [
                SizedBox(
                    height: height * 0.35,
                    child: Image.asset('assets/images/Mail Verification.png')),
                SizedBox(
                    width: width * 0.85,
                    child: const Text(
                        'To reset your password, please enter the email address associated with your account below.')),
                Gap(height * 0.02),
                Text('Enter Your Email',style: textTheme.bodyLarge,),
                Gap(height * 0.02),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email_outlined),
                    hintText: 'Enter E-mail',
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
                Gap(height * 0.04),
                InkWell(
                    onTap: (){
                      passwordReset();
                    },
                    child: const RoundButton(inputText: 'Reset Password')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
