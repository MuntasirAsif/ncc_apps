import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ncc_apps/Utils/colors.dart';
import 'package:ncc_apps/Utils/round_button.dart';
import '../Utils/utils.dart';
import '../notifications_services.dart';
import 'package:http/http.dart' as http;

class PostScreen extends StatefulWidget {
  final bool isAdmin;
  const PostScreen({Key? key, required this.isAdmin}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  NotificationServices notificationServices = NotificationServices();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  bool addAchievement = false;
  late String url;
  File? _image;
  final picker = ImagePicker();
  final postKey = DateTime.now().microsecondsSinceEpoch.toString();
  late final postController = TextEditingController();
  late final rankController = TextEditingController();
  late final titleController = TextEditingController();
  String token = '';
  Future getImageGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        Utils().toastMessages('No image Selected');
      }
    });
  }

  uploadPic(File image) async {
    FirebaseStorage storage =
        FirebaseStorage.instanceFor(bucket: 'gs://ncc-apps-47109.appspot.com');
    Reference storageRef = storage.ref().child("image_$postKey");
    UploadTask uploadTask = storageRef.putFile(image);
    Future.value(uploadTask).then((value) async {
      url = await storageRef.getDownloadURL();
      addPost(url);
    }).catchError((onError) {
      Utils().toastMessages(onError);
    });
  }

  void addPost(url) {
    final User? user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    ref.child(postKey).set({
      'image': url,
      'postKey': postKey,
      'Time': DateTime.now().toString(),
      'userId': uid,
      'postContent': postController.text.toString(),
      'token': token,
    }).then((value) {
      if (addAchievement) {
        addAchievementPost(url);
      } else {
        subscribeToNotificationTopic('New Post',postController.text.toString(),'post');
        Navigator.pop(context);
      }
      Utils().toastMessages('Post added Successfully');
    }).onError((error, stackTrace) {
      Utils().toastMessages(error.toString());
    });
  }

  void addAchievementPost(url) {
    ref2.child(postKey).set({
      'image': url,
      'postKey': postKey,
      'rank': rankController.text.toString(),
      'postContent': postController.text.toString(),
      'title': titleController.text.toString(),
    }).then((value) {
      subscribeToNotificationTopic('New Achievement',postController.text.toString(),'Achievement');
      Navigator.pop(context);
      Utils().toastMessages('Also added Achievement');
    }).onError((error, stackTrace) {
      Utils().toastMessages(error.toString());
    });
  }

  DatabaseReference ref = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL: 'https://ncc-apps-47109-default-rtdb.firebaseio.com')
      .ref("post");
  DatabaseReference ref2 = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL: 'https://ncc-apps-47109-default-rtdb.firebaseio.com')
      .ref("Achievement");
  DatabaseReference ref3 = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: 'https://ncc-apps-47109-default-rtdb.firebaseio.com')
      .ref("Device");
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    notificationServices.getDeviceToken().then((value) {
      setState(() {
        token = value.toString();
      });
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        centerTitle: true,
        title: Text(
          'Post',
          style: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/images/Background.png',
                ),
                fit: BoxFit.fill)),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: width * 0.02),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Form(
                          key: _formKey2,
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: white.withOpacity(0.5),
                                  border: Border.all(),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('  Add:'),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Gap(width * 0.1),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  postController.text =
                                                      "${postController.text}''''\n//Write your Code\n\n''''";
                                                });
                                              },
                                              child: Text(
                                                "<Add_Code>",
                                                style: textTheme.titleMedium,
                                              ),
                                            ),
                                            Gap(width * 0.04),
                                            InkWell(
                                              onTap: () {
                                                getImageGallery();
                                              },
                                              child: const Icon(
                                                Icons.image,
                                                size: 30,
                                              ),
                                            ),
                                            Gap(width * 0.04),
                                          ],
                                        ),
                                      ],
                                    ),
                                    TextFormField(
                                      controller: postController,
                                      maxLines: 15,
                                      minLines: 3,
                                      keyboardType: TextInputType.multiline,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Write Something';
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Write Here...',
                                        border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: bgGreen),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: black),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: bgGreen),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: black),
                                        ),
                                      ),
                                    ),
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxHeight: height * 0.3,
                                        minHeight: 0,
                                      ),
                                      child: Container(
                                        child: _image != null
                                            ? Image.file(_image!.absolute)
                                            : const Gap(0.0001),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Gap(height * 0.0),
                              const Text(
                                  "* If you want to add code write ''''  //code  '''' or click on <Add_Code>."),
                              Gap(height * 0.005),
                            ],
                          ),
                        ),
                        widget.isAdmin
                            ? InkWell(
                                onTap: () {
                                  setState(() {
                                    if (addAchievement == true) {
                                      addAchievement = false;
                                    } else {
                                      addAchievement = true;
                                    }
                                  });
                                },
                                child: Row(
                                  children: [
                                    Container(
                                        height: height * 0.02,
                                        width: width * 0.04,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            border: Border.all()),
                                        child: Center(
                                          child: Container(
                                            height: height * 0.01,
                                            width: width * 0.02,
                                            decoration: BoxDecoration(
                                              color: addAchievement
                                                  ? deepGreen
                                                  : transparent,
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                          ),
                                        )),
                                    Gap(width * .02),
                                    const Text('Is it an Achievement of NCC?'),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                        Gap(height * 0.01),
                        addAchievement
                            ? Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('Please Enter the Rank'),
                                      Gap(width * .02),
                                      SizedBox(
                                        width: width * 0.2,
                                        height: height * 0.1,
                                        child: TextFormField(
                                          controller: rankController,
                                          style: textTheme.bodyLarge,
                                          keyboardType: TextInputType.number,
                                          cursorHeight: height * 0.03,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Enter Rank';
                                            } else {
                                              return null;
                                            }
                                          },
                                          decoration: InputDecoration(
                                            hintText: 'Rank',
                                            hintStyle: textTheme.bodyMedium,
                                            border: OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: black),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: black),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: black),
                                            ),
                                            disabledBorder: OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: black),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Gap(height * 0.02),
                                  TextFormField(
                                    controller: titleController,
                                    style: textTheme.bodyLarge,
                                    keyboardType: TextInputType.text,
                                    cursorHeight: height * 0.03,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter Title';
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Add Title',
                                      hintStyle: textTheme.bodyMedium,
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
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        Gap(height * 0.03),
                      ],
                    )),
                Center(
                    child: InkWell(
                        onTap: () {
                          if (addAchievement) {
                            if (_formKey.currentState!.validate() &&
                                _formKey2.currentState!.validate()) {
                              if (_image != null) {
                                uploadPic(_image!);
                              } else {
                                Utils().toastMessages(
                                    'You have to Add Image for Achievement');
                              }
                            }
                          } else if (_formKey2.currentState!.validate()) {
                            _image != null ? uploadPic(_image!) : addPost('');
                          }
                        },
                        child: const RoundButton(inputText: 'Add Post')))
              ],
            ),
          ),
        ),
      ),
    );
  }
  void subscribeToNotificationTopic(String title,String body,String type) async {
    try {
      await FirebaseMessaging.instance.subscribeToTopic('all_users');
      sendNotificationToAllUsers(title,body,type);
    } catch (e) {
      if (kDebugMode) {
        print('Error subscribing to the "all_users" topic: $e');
      }
    }
  }
  Future<void> sendNotificationToAllUsers(String title, String body,String type) async {
    var data = {
      'to': '/topics/all_users',
      'priority': 'high',
      'notification': {
        'title': title,
        'body': body,
      },
      'data':{
        'type': type,
        'id' : postKey
      }
    };

    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'key=AAAA0btYFoE:APA91bHKoncgrtKxzGpfG7a-7iLZ-_icwj2ttzA0jEpUZuaFvNN2Xry2uP81Vf7a6iKk4V-4A4zs3is8EaRtci264zTuEkQHmIRVQcse3lf6_ruuB7se26Hhse21mMq2brAi2DGWS7Uo',
        },
      );
      if (kDebugMode) {
        print('Notification sent to all users');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error sending notification to all users: $e');
      }
    }
  }
}
