import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ncc_apps/Utils/colors.dart';

class AchievementScreen extends StatelessWidget {
  final String image;
  final String title;
  final String postContent;
  const AchievementScreen(
      {Key? key,
      required this.image,
      required this.title,
      required this.postContent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        title: Text(title,style: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w500),),
      ),
      body: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Background.png'),
            fit: BoxFit.fill)
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height*0.4,
                  width: width,
                  child: Image(image: NetworkImage(image),fit: BoxFit.cover,)),
              Gap(height*0.01),
             Padding(
               padding:EdgeInsets.symmetric(horizontal: width*0.03),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(title,style: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),),
                   Gap(height*0.01),
                   Text(postContent,style: textTheme.bodyLarge,textAlign: TextAlign.left,)
                 ],
               ),
             )
            ],
          ),
        ),
      ),
    );
  }
}
