import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ncc_apps/Auth_Service/verification_screen.dart';
import '../Auth_Service/login_screen.dart';


class SplashServices{
  void isLogin(BuildContext context){
    FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
      if(user==null){
        Timer(
            const Duration(seconds: 3),
                () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginScreen())));
      }
      else{
        Timer(
            const Duration(seconds: 3),
                () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ConfirmScreen())));
      }
}}