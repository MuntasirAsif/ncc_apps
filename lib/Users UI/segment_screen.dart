import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ncc_apps/Exam%20Room/exam_hub.dart';
import '../Full View/segment_view.dart';
import '../Utils/colors.dart';
import '../Utils/utils.dart';

class SegmentScreen extends StatefulWidget {
  final bool isAdmin;
  const SegmentScreen({Key? key, required this.isAdmin}) : super(key: key);

  @override
  State<SegmentScreen> createState() => _SegmentScreenState();
}

class _SegmentScreenState extends State<SegmentScreen> {
  late bool open ;
  DatabaseReference ref = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: 'https://ncc-apps-47109-default-rtdb.firebaseio.com')
      .ref("Exam Hub");
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: white,
        title: Text('Segments',
            style: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
      ),
      body: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/Background.png'),
                fit: BoxFit.fill)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder(
                stream: ref.onValue,
                builder: (BuildContext context,
                    AsyncSnapshot<dynamic> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    final DataSnapshot data = snapshot.data!.snapshot;
                    final Map<dynamic, dynamic>? map =
                    data.value as Map<dynamic, dynamic>?;
                    open = map?['status'] == 'open' ? true : false;
                    return const SizedBox();
                  } else {
                    return const Text('Something Wrong');
                  }
                },
              ),
              Gap(height * 0.01),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SegmentView(
                                isAdmin: widget.isAdmin,
                                segment: 'Competitive Programming',
                                photo: 'assets/images/cp.jpg',
                              )));
                },
                child: Container(
                  height: height * 0.09,
                  width: width * 0.95,
                  decoration: BoxDecoration(
                      color: grey.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundImage: AssetImage('assets/images/cp.jpg'),
                        radius: 30,
                      ),
                      title: Text(
                        'Competitive Programming',
                        style: textTheme.titleLarge,
                      ),
                    ),
                  ),
                ),
              ),
              Gap(height * 0.01),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SegmentView(
                              isAdmin: widget.isAdmin,
                              segment: 'Cyber Security',
                              photo: 'assets/images/cyber.jpg')));
                },
                child: Container(
                  height: height * 0.09,
                  width: width * 0.95,
                  decoration: BoxDecoration(
                      color: grey.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundImage: AssetImage('assets/images/cyber.jpg'),
                        radius: 30,
                      ),
                      title: Text(
                        'Cyber Security',
                        style: textTheme.titleLarge,
                      ),
                    ),
                  ),
                ),
              ),
              Gap(height * 0.01),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SegmentView(
                              isAdmin: widget.isAdmin,
                              segment: 'App Development',
                              photo: 'assets/images/app.png')));
                },
                child: Container(
                  height: height * 0.09,
                  width: width * 0.95,
                  decoration: BoxDecoration(
                      color: grey.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundImage: AssetImage('assets/images/app.png'),
                        radius: 30,
                      ),
                      title: Text(
                        'App Development',
                        style: textTheme.titleLarge,
                      ),
                    ),
                  ),
                ),
              ),
              Gap(height * 0.01),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SegmentView(
                              isAdmin: widget.isAdmin,
                              segment: 'Web Development',
                              photo: 'assets/images/web.jpg')));
                },
                child: Container(
                  height: height * 0.09,
                  width: width * 0.95,
                  decoration: BoxDecoration(
                      color: grey.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundImage: AssetImage('assets/images/web.jpg'),
                        radius: 30,
                      ),
                      title: Text(
                        'Web Development',
                        style: textTheme.titleLarge,
                      ),
                    ),
                  ),
                ),
              ),
              Gap(height * 0.01),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SegmentView(
                              isAdmin: widget.isAdmin,
                              segment: 'Graphic Design',
                              photo: 'assets/images/GRAPHICS.jpeg')));
                },
                child: Container(
                  height: height * 0.09,
                  width: width * 0.95,
                  decoration: BoxDecoration(
                      color: grey.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/images/GRAPHICS.jpeg'),
                        radius: 30,
                      ),
                      title: Text(
                        'Graphic Design',
                        style: textTheme.titleLarge,
                      ),
                    ),
                  ),
                ),
              ),
              Gap(height * 0.01),
              SizedBox(
                width: width * 0.87,
                child: Divider(
                  thickness: 2,
                  color: black,
                ),
              ),
              Gap(height * 0.01),
              InkWell(
                onTap: (){
                  (open || widget.isAdmin)?Navigator.push(context, MaterialPageRoute(builder: (context)=>NCCAdminExamHub(isAdmin: widget.isAdmin, open: open,))):Utils().toastMessages('Exam is Closed now');
                },
                child: Container(
                  padding: EdgeInsets.all(height*0.01),
                  width: width * 0.8,
                  height: height * 0.25,
                  decoration: BoxDecoration(
                      image: const DecorationImage(
                          image: AssetImage('assets/images/Background.png'),
                          fit: BoxFit.fill),
                      borderRadius: BorderRadius.circular(10),
                      border: const Border(
                          left: BorderSide(),
                          right: BorderSide(),
                          bottom: BorderSide())),
                  child: Column(
                    children: [
                      Text(
                        'NCC Exam Hub',
                        style: textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gap(height*0.01),
                      Container(
                        padding:  EdgeInsets.all(height*0.01),
                        width: width * 0.6,
                        height: height * 0.18,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: const Border(
                                left: BorderSide(),
                                right: BorderSide(),
                                bottom: BorderSide()),
                          image: const DecorationImage(image: AssetImage('assets/images/exam.jpg'),fit: BoxFit.cover)
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: width * 0.75,
                height: height * 0.002,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: const Border(
                      left: BorderSide(),
                      right: BorderSide(),
                      bottom: BorderSide()),
                ),
              ),
              Container(
                width: width * 0.73,
                height: height * 0.002,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: const Border(
                      left: BorderSide(),
                      right: BorderSide(),
                      bottom: BorderSide()),
                ),
              ),
              Container(
                width: width * 0.71,
                height: height * 0.002,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: const Border(
                      left: BorderSide(),
                      right: BorderSide(),
                      bottom: BorderSide()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
