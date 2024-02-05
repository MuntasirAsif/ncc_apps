import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ncc_apps/Exam%20Room/group_screen.dart';
import 'package:ncc_apps/Exam%20Room/result.dart';
import 'package:ncc_apps/Utils/utils.dart';
import '../Utils/colors.dart';

class NCCAdminExamHub extends StatefulWidget {
  final bool isAdmin;
  bool open;
  NCCAdminExamHub({super.key, required this.isAdmin, required this.open});

  @override
  State<NCCAdminExamHub> createState() => _NCCAdminExamHubState();
}

class _NCCAdminExamHubState extends State<NCCAdminExamHub> {
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
      appBar: AppBar(
        backgroundColor: white,
        title: Text('NCC Exam Hub',
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
          child: Center(
            child: Column(
              children: [
                Text('Welcome To..', style: textTheme.titleMedium),
                Text('NCC Exam Hub',
                    style: textTheme.titleLarge!
                        .copyWith(fontWeight: FontWeight.bold)),
                Gap(height * 0.04),
                Column(
                  children: [
                    widget.isAdmin
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  width: width * 0.4,
                                  child: Row(
                                    children: [
                                      Text(
                                        'Exam is ',
                                        style: textTheme.titleMedium,
                                      ),
                                      widget.open
                                          ? Text(
                                              'Open',
                                              style: textTheme.titleMedium,
                                            )
                                          : Text(
                                              'Closed',
                                              style: textTheme.titleMedium,
                                            ),
                                    ],
                                  )),
                              Gap(width * 0.2),
                              InkWell(
                                onTap: () {
                                  if (widget.open) {
                                    ref.update({'status': 'closed'});
                                    setState(() {
                                      widget.open = false;
                                    });
                                    if (kDebugMode) {
                                      print(widget.open);
                                    }
                                  } else {
                                    ref.update({'status': 'open'});
                                    setState(() {
                                      widget.open = true;
                                    });
                                    if (kDebugMode) {
                                      print(widget.open);
                                    }
                                  }
                                },
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      height: height * 0.025,
                                      width: width * 0.12,
                                      child: Center(
                                        child: Container(
                                          height: height * 0.02,
                                          width: width * 0.1,
                                          decoration: BoxDecoration(
                                              color: black,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                        ),
                                      ),
                                    ),
                                    !widget.open
                                        ? Positioned(
                                            left: 0,
                                            bottom: 0,
                                            top: 0,
                                            child: Container(
                                              height: width * 0.05,
                                              width: width * 0.05,
                                              decoration: BoxDecoration(
                                                color: red,
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                            ))
                                        : Positioned(
                                            right: 0,
                                            bottom: 0,
                                            top: 0,
                                            child: Container(
                                              height: width * 0.05,
                                              width: width * 0.05,
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                            ))
                                  ],
                                ),
                              )
                            ],
                          )
                        : SizedBox(
                            width: width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Exam is ',style: textTheme.titleMedium,),
                                widget.open
                                    ? Text('Open',style: textTheme.titleMedium,)
                                    : Text('Closed',style: textTheme.titleMedium,),
                              ],
                            )),
                    const Divider(
                      thickness: 2,
                    ),
                    Gap(height * 0.05),
                  ],
                ),
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        (widget.open || widget.isAdmin)?Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ExamGroup(
                                      isAdmin: widget.isAdmin,
                                    ))):Utils().toastMessages('Exam is Closed now');
                      },
                      child: Container(
                        padding: EdgeInsets.all(height * 0.01),
                        width: width * 0.8,
                        height: height * 0.25,
                        decoration: BoxDecoration(
                            image: const DecorationImage(
                                image:
                                    AssetImage('assets/images/Background.png'),
                                fit: BoxFit.fill),
                            borderRadius: BorderRadius.circular(10),
                            border: const Border(
                                left: BorderSide(),
                                right: BorderSide(),
                                bottom: BorderSide())),
                        child: Column(
                          children: [
                            Text(
                              'Your question',
                              style: textTheme.titleLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Gap(height * 0.01),
                            Container(
                              padding: EdgeInsets.all(height * 0.01),
                              width: width * 0.6,
                              height: height * 0.18,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: const Border(
                                      left: BorderSide(),
                                      right: BorderSide(),
                                      bottom: BorderSide()),
                                  image: const DecorationImage(
                                      image:
                                          AssetImage('assets/images/exam.jpg'),
                                      fit: BoxFit.cover)),
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
                    )
                  ],
                ),
                Gap(height * 0.1),
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const Result()));
                      },
                      child: Container(
                        padding: EdgeInsets.all(height * 0.01),
                        width: width * 0.8,
                        height: height * 0.25,
                        decoration: BoxDecoration(
                            image: const DecorationImage(
                                image:
                                    AssetImage('assets/images/Background.png'),
                                fit: BoxFit.fill),
                            borderRadius: BorderRadius.circular(10),
                            border: const Border(
                                left: BorderSide(),
                                right: BorderSide(),
                                bottom: BorderSide())),
                        child: Column(
                          children: [
                            Text(
                              'Result',
                              style: textTheme.titleLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Gap(height * 0.01),
                            Container(
                              padding: EdgeInsets.all(height * 0.01),
                              width: width * 0.6,
                              height: height * 0.18,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: const Border(
                                      left: BorderSide(),
                                      right: BorderSide(),
                                      bottom: BorderSide()),
                                  image: const DecorationImage(
                                      image:
                                          AssetImage('assets/images/exam.jpg'),
                                      fit: BoxFit.cover)),
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
                Gap(width * 0.2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
