import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:ncc_apps/Admin%20UI/member_request.dart';
import 'package:ncc_apps/Admin%20UI/member_view.dart';
import 'package:ncc_apps/Users%20UI/post_screen.dart';
import '../Users UI/Cards/achievement_view.dart';
import '../Utils/colors.dart';
import '../Utils/utils.dart';

class AdminHomeScreen extends StatefulWidget {
  final bool isAdmin;
  const AdminHomeScreen({Key? key, required this.isAdmin}) : super(key: key);

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  DatabaseReference ref = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: 'https://ncc-apps-47109-default-rtdb.firebaseio.com')
      .ref("Achievement");
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
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
                Text('NCC Admin',
                    style: textTheme.titleLarge!
                        .copyWith(fontWeight: FontWeight.bold)),
              ],
            )),
        actions: [
          Gap(width * .05),
          Icon(
            Icons.notifications,
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
                Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Achievement',
                          style: textTheme.headlineLarge!.copyWith(
                              color: black, fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const PostScreen(isAdmin: true)));
                          },
                          child: Container(
                              height: height * 0.04,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(),
                                color: bgGreen,
                              ),
                              child: Row(
                                children: [
                                  Gap(width * 0.02),
                                  const Icon(Icons.add),
                                  Gap(width * 0.02),
                                  Text(
                                    'Add  ',
                                    style: textTheme.titleMedium,
                                  ),
                                ],
                              )),
                        ),
                      ],
                    )),
                SizedBox(
                  height: height*0.47,
                  width: width,
                  child: FirebaseAnimatedList(
                    query: ref,
                    scrollDirection: Axis.horizontal,
                    sort: (DataSnapshot a, DataSnapshot b) {
                      return b.key!.compareTo(a.key!);
                    },
                    itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                      return AchievementView(
                        title: snapshot.child('title').value.toString(),
                        ranking: snapshot.child('rank').value.toString(),
                        image: snapshot.child('image').value.toString(),
                        postContent: snapshot.child('postContent').value.toString(),);
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: width*0.03),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const MemberRequest()));
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
                                'Member Request',
                                style: textTheme.titleLarge,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Gap(height * 0.01),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Member()));
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
                  )
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
}
