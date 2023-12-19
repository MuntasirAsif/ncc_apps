import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:ncc_apps/Users%20UI/post_screen.dart';

import '../Users UI/Cards/achevement_view.dart';
import '../Utils/colors.dart';
import '../Utils/utils.dart';

class AdminHomeScreen extends StatefulWidget {
  final bool isAdmin;
  const AdminHomeScreen({Key? key, required this.isAdmin}) : super(key: key);

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  static const List<String> sampleImages = [
    "assets/images/0.jpg",
    "assets/images/1.jpg",
    "assets/images/2.jpg",
    "assets/images/3.jpg",
    "assets/images/4.jpeg",
  ];
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Achievement',
                          style: textTheme.headlineLarge!.copyWith(
                              color: black, fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>PostScreen(isAdmin: widget.isAdmin)));
                          },
                          child: Container(
                            height: height*0.04,
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
                const SizedBox(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        AchievementView(
                          title:
                              'International Contest of Programming Competition organized by NCC',
                          ranking: '3',
                        ),
                        AchievementView(
                          title:
                              'International Contest of Programming Competition organized by NCC',
                          ranking: '3',
                        ),
                        AchievementView(
                          title:
                              'International Contest of Programming Competition organized by NCC',
                          ranking: '3',
                        ),
                      ],
                    ),
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
}
