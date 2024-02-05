import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:ncc_apps/Full%20View/notification_screen.dart';
import 'package:ncc_apps/Full%20View/segment_view.dart';
import 'package:ncc_apps/Users%20UI/Cards/achievement_view.dart';
import 'package:ncc_apps/Utils/colors.dart';
import 'package:ncc_apps/Utils/utils.dart';
import 'package:ncc_apps/notifications_services.dart';
import '../Admin UI/member_view.dart';
import '../Full View/event_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isExpandable = false;
  bool haveNotifications = false;
  static const List<String> sampleImages = [
    "assets/images/0.jpg",
    "assets/images/1.jpg",
    "assets/images/2.jpg",
    "assets/images/3.jpg",
    "assets/images/4.jpeg",
  ];
  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationServices.requestNotificationPermission();

    notificationServices.firebaseInit(context);

    notificationServices.setInteractMessage(context);

    notificationServices.getDeviceToken().then((value) {
      if (kDebugMode) {
        print("Device Token  $value");
      }
    });
  }

  DatabaseReference ref = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL: 'https://ncc-apps-47109-default-rtdb.firebaseio.com')
      .ref("Achievement");
  DatabaseReference ref2 = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: 'https://ncc-apps-47109-default-rtdb.firebaseio.com')
      .ref("Event");
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    final User? user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    checkDataExistence(uid.toString());
    return Scaffold(
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
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const NotificationScreen(isAdmin: false,)));
            },
            child:  Stack(
              children: [
                Icon(
                  Icons.notifications,
                  size: 30,
                  color: black,
                ),
                Positioned(
                  right: 0,
                  child: haveNotifications ?const Badge(
                    backgroundColor: Colors.red,
                    smallSize: 10,
                  ):const SizedBox(),
                ),
              ],
            ),
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
                  height: height * 0.47,
                  width: width,
                  child: FirebaseAnimatedList(
                    query: ref,
                    scrollDirection: Axis.horizontal,
                    sort: (DataSnapshot a, DataSnapshot b) {
                      return b.key!.compareTo(a.key!);
                    },
                    itemBuilder: (BuildContext context, DataSnapshot snapshot,
                        Animation<double> animation, int index) {
                      return AchievementView(
                        title: snapshot.child('title').value.toString(),
                        ranking: snapshot.child('rank').value.toString(),
                        image: snapshot.child('image').value.toString(),
                        postContent:
                            snapshot.child('postContent').value.toString(),
                      );
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
                        borderRadius: BorderRadius.circular(30)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        isExpandable
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      const Gap(120),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const SegmentView(
                                                          isAdmin: false,
                                                          segment:
                                                              'App Development',
                                                          photo:
                                                              'assets/images/app.png')));
                                        },
                                        child: const CircleAvatar(
                                            radius: 35,
                                            backgroundColor: secondaryColor,
                                            backgroundImage: AssetImage(
                                                'assets/images/app.png')),
                                      ),
                                      const Text('App'),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => const SegmentView(
                                                  isAdmin: false,
                                                  segment:
                                                      'Competitive Programming',
                                                  photo:
                                                      'assets/images/cp.jpg')));
                                    },
                                    child: const Column(
                                      children: [
                                        CircleAvatar(
                                            radius: 35,
                                            backgroundColor: secondaryColor,
                                            backgroundImage: AssetImage(
                                                'assets/images/cp.jpg')),
                                        Text('C.P.'),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SegmentView(
                                                      isAdmin: false,
                                                      segment: 'Cyber Security',
                                                      photo:
                                                          'assets/images/cyber.jpg')));
                                    },
                                    child: const Column(
                                      children: [
                                        Gap(120),
                                        CircleAvatar(
                                            radius: 35,
                                            backgroundImage: AssetImage(
                                                'assets/images/cyber.jpg')),
                                        Text('Cyber'),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            : SizedBox(
                                height: 150,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'To Explore',
                                        style: textTheme.displaySmall,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text('Our ',
                                              style: textTheme.displaySmall!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                          SizedBox(
                                            height: 100,
                                            width: 200,
                                            child: DefaultTextStyle(
                                              style: const TextStyle(
                                                fontSize: 40.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.deepPurple,
                                              ),
                                              child: AnimatedTextKit(
                                                animatedTexts: [
                                                  RotateAnimatedText(
                                                      'NCC Club'),
                                                  RotateAnimatedText(
                                                      'Segments'),
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
                                radius: isExpandable ? 70 : 50,
                                backgroundColor: white,
                                backgroundImage: isExpandable
                                    ? const AssetImage('assets/images/logo.png')
                                    : const AssetImage(
                                        'assets/images/Background.png'),
                                child: isExpandable
                                    ? const Text('')
                                    : Text(
                                        'Explore',
                                        style: textTheme.titleLarge,
                                      ),
                              ),
                            ),
                          ],
                        ),
                        isExpandable
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      const Text('Web'),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const SegmentView(
                                                          isAdmin: false,
                                                          segment:
                                                              'Web Development',
                                                          photo:
                                                              'assets/images/web.jpg')));
                                        },
                                        child: CircleAvatar(
                                            radius: 35,
                                            backgroundColor: white,
                                            backgroundImage: const AssetImage(
                                                'assets/images/web.jpg')),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const Text('Graphic'),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const SegmentView(
                                                          isAdmin: false,
                                                          segment:
                                                              'Graphic Design',
                                                          photo:
                                                              'assets/images/GRAPHICS.jpeg')));
                                        },
                                        child: CircleAvatar(
                                            radius: 35,
                                            backgroundColor: white,
                                            backgroundImage: const AssetImage(
                                                'assets/images/GRAPHICS.jpeg')),
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
                ),
                Gap(height * 0.01),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: width*0.03),
                  child: Column(
                    children: [
                      Text('Upcoming Event',style: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),),
                      Gap(width*0.02),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const EventScreen( isAdmin: false)));
                        },
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              minHeight: height * 0.09
                          ),
                          child: Container(
                            width: width * 0.95,
                            decoration: BoxDecoration(
                                color: grey.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(20)),
                            child: StreamBuilder(
                              stream: ref2.child('Event').onValue,
                              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.hasData) {
                                  final DataSnapshot data = snapshot.data!.snapshot;
                                  final Map<dynamic, dynamic>? map =
                                  data.value as Map<dynamic, dynamic>?;
                                  return Center(
                                    child: Row(
                                      children: [
                                        Container(
                                          height: height*0.2,
                                          width: width*0.4,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(map?['image']),fit: BoxFit.cover
                                              ),
                                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20))
                                          ),),
                                        Gap(width*0.02),
                                        Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children:[
                                              Text(
                                                map?['title'],
                                                style: textTheme.titleLarge,
                                              ),
                                              SizedBox(
                                                  width: width*0.5,
                                                  height: height*0.15,
                                                  child: Text(map?['details'])),
                                            ]
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return const Text('Something Wrong');
                                }
                              },
                            ),
                          ),
                        ),
                      ),

                      Gap(height * 0.01),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> const Member(isAdmin: false,)));
                        },
                        child: Container(
                          height: height * 0.09,
                          width: width * 0.95,
                          decoration: BoxDecoration(
                              color: grey.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: white,
                                backgroundImage: const AssetImage('assets/images/logo.png'),
                                radius: 30,
                              ),
                              title: Text(
                                'NCC Members',
                                style: textTheme.titleLarge,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () {
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
    );
  }
  Future<void> checkDataExistence(String uid) async {
    DatabaseReference reference = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: 'https://ncc-apps-47109-default-rtdb.firebaseio.com')
        .ref("user/$uid/notifications");

    try {
      DataSnapshot dataSnapshot = await reference.get();

      if (dataSnapshot.value != null) {
        setState(() {
          haveNotifications=true;
        });
        // Data exists
        if (kDebugMode) {
          print("Data exists: ${dataSnapshot.value}");
        }
      } else {
        setState(() {
          haveNotifications=false;
        });
        // Data doesn't exist
        if (kDebugMode) {
          print("Data doesn't exist");
        }
      }
    } catch (error) {
      // Handle any potential errors
      if (kDebugMode) {
        print("Error: $error");
      }
    }
  }
}
