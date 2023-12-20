import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../Utils/colors.dart';
import '../Utils/utils.dart';

class SegmentView extends StatefulWidget {
  final bool isAdmin;
  final String segment;
  final String photo;
  const SegmentView({Key? key, required this.isAdmin, required this.segment, required this.photo}) : super(key: key);
  @override
  State<SegmentView> createState() => _SegmentViewState();
}

class _SegmentViewState extends State<SegmentView> {
  bool isEditable= false;
  TextEditingController detailsController = TextEditingController();
  TextEditingController goalController = TextEditingController();
  TextEditingController workController = TextEditingController();

  updateSegment(){
    ref.child(widget.segment).set({
      'details' : detailsController.text.toString(),
      'goal' : goalController.text.toString(),
      'work' : workController.text.toString(),
    }).then((value) {
      setState(() {
        isEditable=false;
      });
      Utils().toastMessages('Updated');
    }).onError((error, stackTrace) {
      Utils().toastMessages(error.toString());
    });
  }
  DatabaseReference ref = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: 'https://ncc-apps-47109-default-rtdb.firebaseio.com')
      .ref("Segment");
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        title: Text(widget.segment,
            style: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
        actions: [
          widget.isAdmin?InkWell(
            onTap: (){
              setState(() {
                if(isEditable){
                  isEditable = false;
                }else{
                  isEditable = true;
                }
              });
            },
              child: isEditable? InkWell(
                onTap: (){
                  updateSegment();
                },
                child: Container(
                  height: height*0.04,
                  width: width*0.15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: black
                  ),
                  child: Center(child: Text('Save',style: textTheme.titleMedium!.copyWith(color: white),)),
                ),
              ):const Icon(Icons.edit)):const SizedBox(),
          Gap(width*.03),
        ],
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
              Container(
                  height: height * 0.3,
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                          image: AssetImage(widget.photo),
                          fit: BoxFit.cover))),
              Gap(height*0.02),
              SizedBox(child: Center(child: Text('Welcome To ',style: textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),))),
              SizedBox(child: Center(child: Text(widget.segment,style: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),))),
              Gap(height*0.02),
              StreamBuilder(
                stream: ref.child(widget.segment).onValue,
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if(!snapshot.hasData){
                    return const Center(child: CircularProgressIndicator(),);
                  }else if(snapshot.hasData){
                    final DataSnapshot data = snapshot.data!.snapshot;
                    final Map<dynamic, dynamic>? map =
                    data.value as Map<dynamic, dynamic>?;
                    detailsController.text=map?['details'];
                    return Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.symmetric(horizontal: width*0.03),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Segment Details',style: textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),),
                          isEditable?TextFormField(
                            controller: detailsController,
                            maxLines: 5,
                            minLines: 1,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              hintText: 'Write Here...',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: black),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: black),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: black),
                              ),
                            ),
                          ):SizedBox(
                            width: width,
                            child: Text(map?['details']),
                          ),
                          Text('What is our Goal?',style: textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),),
                          isEditable?TextFormField(
                            controller: goalController,
                            maxLines: 5,
                            minLines: 1,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              hintText: 'Write Here...',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: black),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: black),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: black),
                              ),
                            ),
                          ):SizedBox(
                            width: width,
                            child: Text(map?['goal']),
                          ),
                          Text('What we are doing?',style: textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),),
                          isEditable?TextFormField(
                            controller: workController,
                            maxLines: 5,
                            minLines: 1,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              hintText: 'Write Here...',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: black),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: black),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: black),
                              ),
                            ),
                          ):SizedBox(
                            width: width,
                            child: Text(map?['work']),
                          ),
                        ],
                      ),
                    );
                  }else{
                    return const Text('Something Wrong');
                  }
                },

              )
            ],
          ),
        ),
      ),
    );
  }
}
