import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ncc_apps/Users%20UI/Segment/segment_view.dart';
import '../Utils/colors.dart';

class SegmentScreen extends StatefulWidget {
  const SegmentScreen({Key? key}) : super(key: key);

  @override
  State<SegmentScreen> createState() => _SegmentScreenState();
}

class _SegmentScreenState extends State<SegmentScreen> {
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
              Gap(height*0.01),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SegmentView()));
                },
                child: Container(
                  height: height*0.09,
                  width: width*0.95,
                  decoration: BoxDecoration(
                    color: grey.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Center(
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundImage: AssetImage('assets/images/cp.jpg'),
                        radius: 30,
                      ),
                      title: Text('Competitive Programming',style: textTheme.titleLarge,),
                    ),
                  ),
                ),
              ),
              Gap(height*0.01),
              Container(
                height: height*0.09,
                width: width*0.95,
                decoration: BoxDecoration(
                    color: grey.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Center(
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/cyber.jpg'),
                      radius: 30,
                    ),
                    title: Text('Cyber Security',style: textTheme.titleLarge,),
                  ),
                ),
              ),
              Gap(height*0.01),
              Container(
                height: height*0.09,
                width: width*0.95,
                decoration: BoxDecoration(
                    color: grey.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Center(
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/app.png'),
                      radius: 30,
                    ),
                    title: Text('App Development',style: textTheme.titleLarge,),
                  ),
                ),
              ),
              Gap(height*0.01),
              Container(
                height: height*0.09,
                width: width*0.95,
                decoration: BoxDecoration(
                    color: grey.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Center(
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/web.jpg'),
                      radius: 30,
                    ),
                    title: Text('Web Development',style: textTheme.titleLarge,),
                  ),
                ),
              ),
              Gap(height*0.01),
              Container(
                height: height*0.09,
                width: width*0.95,
                decoration: BoxDecoration(
                    color: grey.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Center(
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/GRAPHICS.jpeg'),
                      radius: 30,
                    ),
                    title: Text('Graphic Design',style: textTheme.titleLarge,),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
