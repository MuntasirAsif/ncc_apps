import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../Utils/colors.dart';

class SegmentView extends StatefulWidget {
  const SegmentView({Key? key}) : super(key: key);

  @override
  State<SegmentView> createState() => _SegmentViewState();
}

class _SegmentViewState extends State<SegmentView> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        title: Text('Competitive Programming',
            style: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
      ),
      body: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/Background.png'),
                fit: BoxFit.fill)),
        child: Column(
          children: [
            Container(
                height: height * 0.3,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                        image: AssetImage('assets/images/cp.jpg'),
                        fit: BoxFit.cover))),
            Gap(height*0.02),
            Text('Welcome To Our CP Segment!',style: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),),
            Gap(height*0.02),
            Container(
              padding: EdgeInsets.symmetric(horizontal: width*0.03),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('What is Out Goal?',style: textTheme.bodyLarge,),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
