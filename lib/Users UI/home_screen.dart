import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:ncc_apps/Users%20UI/Cards/achevement_view.dart';
import 'package:ncc_apps/Utils/colors.dart';
import 'package:ncc_apps/Utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isExpandable = false;
  static const List<String> sampleImages = [
    "assets/images/0.jpg",
    "assets/images/1.jpg",
    "assets/images/2.jpg",
    "assets/images/3.jpg",
    "assets/images/4.jpeg",
  ];
  DatabaseReference ref = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: 'https://ncc-apps-47109-default-rtdb.firebaseio.com')
      .ref("Achievement");
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
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: white,
          title: SizedBox(
              height: height * 0.05,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Image(
                    image: AssetImage('assets/images/title.png'),
                  ),
                  Gap(width * 0.01),
                  Text('NCC',
                      style: textTheme.displaySmall!
                          .copyWith(fontWeight: FontWeight.bold)),
                ],
              )),
          actions: [
            Gap(width * .05),
            Icon(
              Icons.menu,
              size: 30,
              color: black,
            ),
            Gap(width * .05),
          ],
        ),
        body: SafeArea(
          child: Container(
            height: height,
            width: width,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/Background.png'),
                    fit: BoxFit.fill)),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FanCarouselImageSlider(
                    sliderHeight: height * 0.4,
                    imagesLink: sampleImages,
                    isAssets: true,
                    autoPlay: true,
                    isClickable: true,
                  ),
                  Gap(height * 0.02),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                      child: Column(
                        children: [
                          Text(
                            'Achievement',
                            style: textTheme.headlineLarge!.copyWith(
                                color: black, fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: height*0.47,
                    width: width,
                    child: FirebaseAnimatedList(
                      query: ref,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                        return AchievementView(
                          title: snapshot.child('title').value.toString(),
                          ranking: snapshot.child('rank').value.toString(),
                          image: snapshot.child('image').value.toString(),);
                      },
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                      child: Column(
                        children: [
                          Center(
                              child: Text(
                            'Segment',
                            style: textTheme.headlineLarge!.copyWith(
                                color: black, fontWeight: FontWeight.bold),
                          )),
                        ],
                      )),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: 490,
                    ),
                    child: Container(
                      width: width,
                      decoration: BoxDecoration(
                        color: black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          isExpandable
                              ? const Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        Gap(120),
                                        CircleAvatar(
                                          radius: 35,
                                          backgroundColor: secondaryColor,
                                            backgroundImage: AssetImage('assets/images/app.png')
                                        ),
                                        Text('App'),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        CircleAvatar(
                                          radius: 35,
                                          backgroundColor: secondaryColor,
                                            backgroundImage: AssetImage('assets/images/cp.jpg')
                                        ),
                                        Text('C.P.'),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Gap(120),
                                        CircleAvatar(
                                          radius: 35,
                                          backgroundImage: AssetImage('assets/images/cyber.jpg')
                                        ),
                                        Text('Cyber'),
                                      ],
                                    )
                                  ],
                                )
                              : SizedBox(
                            height: 150,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'To Explore',
                                          style: textTheme.displaySmall,
                                        ),
                                     Row(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       crossAxisAlignment: CrossAxisAlignment.center,
                                       children: [
                                         Text('Our ',style: textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold)),
                                         SizedBox(
                                           height: 100,
                                           width: 200,
                                           child:DefaultTextStyle(
                                             style: const TextStyle(
                                               fontSize: 40.0,
                                               fontWeight: FontWeight.bold,
                                               color: Colors.deepPurple,
                                             ),
                                             child: AnimatedTextKit(
                                               animatedTexts: [
                                                 RotateAnimatedText('NCC Club'),
                                                 RotateAnimatedText('Segments'),
                                               ],
                                               repeatForever: true,
                                             ),
                                           ),
                                         ),
                                       ],
                                     )
                                      ],
                                    ),
                                  ),
                                ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (isExpandable == true) {
                                      isExpandable = false;
                                    } else {
                                      isExpandable = true;
                                    }
                                  });
                                },
                                child: CircleAvatar(
                                  radius: isExpandable?70 : 50,
                                  backgroundColor: white,
                                    backgroundImage: isExpandable? const AssetImage('assets/images/logo.png'):const AssetImage('assets/images/Background.png'),
                                  child: isExpandable? const Text(''): Text('Explore',style: textTheme.titleLarge,),
                                ),
                              ),
                            ],
                          ),
                          isExpandable
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        const Text('Web'),
                                        CircleAvatar(
                                          radius: 35,
                                          backgroundColor: white,
                                            backgroundImage: const AssetImage('assets/images/web.jpg')
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        const Text('Graphic'),
                                        CircleAvatar(
                                          radius: 35,
                                          backgroundColor: white,
                                            backgroundImage: const AssetImage('assets/images/GRAPHICS.jpeg')
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : Column(
                                children: [
                                  const Gap(15),
                                  Text(
                                      'Tap The Button',
                                      style: textTheme.titleMedium,
                                    ),
                                ],
                              ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: InkWell(
          onTap: (){
            Utils().toastMessages('This System come into Next Update');
          },
          child: Container(
            height: height * 0.06,
            width: width * 0.25,
            decoration: BoxDecoration(
              color: bgGreen,
              border: Border.all(),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(
                  FontAwesomeIcons.message,
                  color: black,
                ),
                Gap(width * 0.02),
                const Text('Chat')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
