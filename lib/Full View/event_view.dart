import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Utils/colors.dart';
import '../Utils/utils.dart';

class EventScreen extends StatefulWidget {
  final bool isAdmin;
  const EventScreen(
      {Key? key,
      required this.isAdmin})
      : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  String photo = '';
  late String url;
  File? image;
  final picker = ImagePicker();
  bool isEditable = false;
  TextEditingController detailsController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  DatabaseReference ref = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL: 'https://ncc-apps-47109-default-rtdb.firebaseio.com')
      .ref("Event");
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        title: Text('Event',
            style: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
        actions: [
          widget.isAdmin
              ? InkWell(
                  onTap: () {
                    setState(() {
                      if (isEditable) {
                        isEditable = false;
                      } else {
                        isEditable = true;
                      }
                    });
                  },
                  child: isEditable
                      ? InkWell(
                          onTap: () {
                            updateEvent();
                          },
                          child: Container(
                            height: height * 0.04,
                            width: width * 0.15,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: black),
                            child: Center(
                                child: Text(
                              'Save',
                              style:
                                  textTheme.titleMedium!.copyWith(color: white),
                            )),
                          ),
                        )
                      : const Icon(Icons.edit))
              : const SizedBox(),
          Gap(width * .03),
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
          child: StreamBuilder(
            stream: ref.child('Event').onValue,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                final DataSnapshot data = snapshot.data!.snapshot;
                final Map<dynamic, dynamic>? map =
                    data.value as Map<dynamic, dynamic>?;
                detailsController.text = map?['details'];
                titleController.text = map?['title'];
                return Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                              height: height * 0.3,
                              width: width,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(map?['image']),
                                      fit: BoxFit.cover))),
                          isEditable
                              ? Positioned(
                                  right: 10,
                                  bottom: 10,
                                  child: InkWell(
                                    onTap: (){
                                      getImageGallery();
                                    },
                                    child: Container(
                                      height: height * 0.06,
                                      width: width * 0.2,
                                      decoration: BoxDecoration(
                                          color: black.withOpacity(0.7),
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: Icon(
                                        Icons.camera_alt,color: white,
                                        size: 40,
                                      ),
                                    ),
                                  ))
                              : const SizedBox(),
                        ],
                      ),
                      Gap(height * 0.02),
                      SizedBox(
                          child: isEditable
                              ? TextFormField(
                                  controller: titleController,
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
                                )
                              : Text(
                                  map?['title'],
                                  style: textTheme.titleLarge!
                                      .copyWith(fontWeight: FontWeight.bold),
                                )),
                      Gap(height * 0.02),
                      Text(
                        'Event Details',
                        style: textTheme.bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      isEditable
                          ? TextFormField(
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
                            )
                          : GestureDetector(
                        onLongPress: () {
                          Utils().toastMessages('Copied');
                          Clipboard.setData(
                              ClipboardData(text: map?['details']));
                        },
                        child: Linkify(
                          text: map?['details'],
                          onOpen: (link) =>
                              _launchURL(Uri.parse(link.url)),
                        ),
                      )
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
    );
  }
  Future<void> _launchURL(Uri url) async {
    try {
      await launchUrl(url);
    } catch (e) {
      if (kDebugMode) {
        print("Error launching URL: $e");
      }
    }
  }

  updateEvent() {
    ref.child('Event').update({
      'details': detailsController.text.toString(),
      'title': titleController.text.toString(),
    }).then((value) {
      setState(() {
        isEditable = false;
      });
      Utils().toastMessages('Updated');
    }).onError((error, stackTrace) {
      Utils().toastMessages(error.toString());
    });
  }
  addPost(String url) {
    ref.child('Event').update({
      'image': url,
    }).then((value) {
      Utils().toastMessages('Updated');
    }).onError((error, stackTrace) {
      Utils().toastMessages(error.toString());
    });
  }
  Future getImageGallery() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
        uploadPic(image!);
      } else {
        Utils().toastMessages('No image Selected');
      }
    });
  }
  uploadPic(File image) async {
    FirebaseStorage storage =
    FirebaseStorage.instanceFor(bucket: 'gs://ncc-apps-47109.appspot.com');
    Reference storageRef = storage.ref().child("event");
    UploadTask uploadTask = storageRef.putFile(image);
    Future.value(uploadTask).then((value) async {
      url = await storageRef.getDownloadURL();
      addPost(url);
    }).catchError((onError) {
      Utils().toastMessages(onError);
    });
  }
}
