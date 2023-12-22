import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ncc_apps/Splash%20Service/splash_service.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashScreen = SplashServices();
  @override
  void initState(){
    super.initState();
    splashScreen.isLogin(context);
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
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
                  image: AssetImage('assets/images/Background.png'),fit: BoxFit.fill
              )
          ),
          child: const Center(
            child: Image(image: AssetImage('assets/images/logo.png')),
          ),
        ),
      ),
    );
  }
}

