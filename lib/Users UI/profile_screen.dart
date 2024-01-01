import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ncc_apps/Auth_Service/login_screen.dart';
import 'package:ncc_apps/Auth_Service/reset_password.dart';
import 'package:ncc_apps/Users%20UI/Cards/news_View.dart';
import 'package:ncc_apps/Users%20UI/ncc_membership_request.dart';
import 'package:ncc_apps/Users%20UI/post_screen.dart';
import 'package:ncc_apps/Utils/colors.dart';
import 'dart:io';
import '../Utils/utils.dart';

class ProfileScreen extends StatefulWidget {
  final bool isAdmin;
  final String uid;
  const ProfileScreen({Key? key, required this.isAdmin, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late bool member;
  String photo = '';
  late String url;
  File? image;
  final picker = ImagePicker();
  TextEditingController nameController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController positionController = TextEditingController();

  DatabaseReference ref = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL: 'https://ncc-apps-47109-default-rtdb.firebaseio.com')
      .ref("post");
  DatabaseReference ref2 = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL: 'https://ncc-apps-47109-default-rtdb.firebaseio.com')
      .ref("user");
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final uId = user?.uid;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Profile',
            style: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
        actions: [
          uId.toString()==widget.uid?PopupMenuButton(
            icon: const Icon(Icons.more_horiz_outlined),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: InkWell(
                  onTap: () {
                    member?Utils().toastMessages('Your are a member of NCC'):Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NCCMemberRequest(
                                  photo: photo,
                                  name: nameController.text,
                                  dept: departmentController.text,
                                  id: idController.text,
                                  position: positionController.text,
                                )));
                  },
                  child: SizedBox(
                    height: height * 0.04,
                    width: width * 0.3,
                    child: Text('NCC Membership',
                        style: textTheme.titleSmall!
                            .copyWith(fontWeight: FontWeight.w400)),
                  ),
                ),
              ),
              PopupMenuItem(
                value: 1,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ResetPassword()));
                  },
                  child: SizedBox(
                    height: height * 0.04,
                    width: width * 0.3,
                    child: Text('Change password',
                        style: textTheme.titleSmall!
                            .copyWith(fontWeight: FontWeight.w400)),
                  ),
                ),
              ),
              PopupMenuItem(
                value: 1,
                child: InkWell(
                  onTap: () {
                    logOut();
                  },
                  child: SizedBox(
                    height: height * 0.04,
                    width: width * 0.3,
                    child: Text('Log out',
                        style: textTheme.titleSmall!
                            .copyWith(fontWeight: FontWeight.w400)),
                  ),
                ),
              ),
            ],
          ):const SizedBox(),
          Gap(width * 0.03),
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
            stream: ref2.child(widget.uid.toString()).onValue,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasData) {
                final DataSnapshot data = snapshot.data!.snapshot;
                final Map<dynamic, dynamic>? map =
                    data.value as Map<dynamic, dynamic>?;
                nameController.text = map?['userName'];
                idController.text = map?['id'];
                departmentController.text = map?['department'];
                positionController.text = map?['position'];
                photo = map?['profileImage'];
                member=(map?['position']!='');
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: width,
                      padding: EdgeInsets.symmetric(horizontal: width * 0.015),
                      decoration: BoxDecoration(
                          color: grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          Gap(height * 0.02),
                          Row(
                            children: [
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  Container(
                                      width: 118,
                                      height: 118,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Colors.black87, width: 3)),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: map?['profileImage']
                                                      .toString() ==
                                                  ""
                                              ? const Icon(Icons.person)
                                              : Image(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                      map?['profileImage'])))),
                                  widget.uid==uId?InkWell(
                                    onTap: () {
                                      getImageGallery();
                                    },
                                    child: CircleAvatar(
                                        radius: 18,
                                        backgroundColor: black.withOpacity(0.7),
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: white,
                                        ))
                                  ):const SizedBox(),
                                ],
                              ),
                              Gap(width * 0.02),
                              Stack(
                                children: [
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minHeight: height * 0.15,
                                    ),
                                    child: SizedBox(
                                      width: width * 0.61,
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            top: 2, left: 10),
                                        decoration: BoxDecoration(
                                            color: grey.withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              map?['userName'],
                                              style: textTheme.titleMedium!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                            Text('ID :  ${map?['id'] ?? ''}',
                                                style: textTheme.bodyMedium),
                                            Text(
                                                'Department : ${map?['department'] ?? ''}',
                                                style: textTheme.bodyMedium),
                                            Text(
                                                'Position : ${map?['position'] ?? ''}',
                                                style: textTheme.bodyMedium),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  widget.isAdmin||(uId.toString()==widget.uid)? Positioned(
                                      right: 4,
                                      bottom: 4,
                                      child: InkWell(
                                        onTap: () {
                                          eidDialog();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: const Row(
                                            children: [
                                              Gap(2),
                                              Icon(
                                                Icons.edit,
                                                size: 15,
                                              ),
                                              Gap(2),
                                              Text("Edit"),
                                              Gap(2)
                                            ],
                                          ),
                                        ),
                                      )):const SizedBox(),
                                ],
                              )
                            ],
                          ),
                          Gap(height * 0.02),
                        ],
                      ),
                    ),
                    Gap(height * 0.01),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PostScreen(
                                            isAdmin: widget.isAdmin,
                                          )));
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: height * 0.015, left: width * 0.02),
                              height: height * 0.06,
                              width: width * 0.7,
                              decoration: BoxDecoration(
                                  color: transparent,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all()),
                              child: Text('Write Something',
                                  style: textTheme.bodyMedium),
                            ),
                          ),
                          Gap(width * 0.02),
                          Container(
                            height: height * 0.06,
                            width: width * 0.22,
                            decoration: BoxDecoration(
                                color: black,
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                                child: Text(
                              'Post',
                              style: textTheme.titleMedium!
                                  .copyWith(color: white.withOpacity(.50)),
                            )),
                          )
                        ],
                      ),
                    ),
                    Gap(height * 0.01),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                      child: SizedBox(
                        height: height * 0.52,
                        child: FirebaseAnimatedList(
                            scrollDirection: Axis.vertical,
                            query: ref,
                            sort: (DataSnapshot a, DataSnapshot b) {
                              return b.key!.compareTo(a.key!);
                            },
                            itemBuilder: (context, snapshot, animation, index) {
                              return SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child:
                                    snapshot.child('userId').value.toString() ==
                                            widget.uid
                                        ? NewsView(
                                            time: snapshot
                                                .child('Time')
                                                .value
                                                .toString(),
                                            image: snapshot
                                                .child('image')
                                                .value
                                                .toString(),
                                            postContent: snapshot
                                                .child('postContent')
                                                .value
                                                .toString(),
                                            userId: snapshot
                                                .child('userId')
                                                .value
                                                .toString(),
                                            postKey: snapshot
                                                .child('postKey')
                                                .value
                                                .toString(),
                                            like: snapshot
                                                .child('like')
                                                .children
                                                .indexed
                                                .length
                                                .toString(),
                                            isLiked: snapshot
                                                .child('like')
                                                .child(widget.uid)
                                                .exists, isAdmin: widget.isAdmin,
                                          )
                                        : const SizedBox(),
                              );
                            }),
                      ),
                    )
                  ],
                );
              } else {
                return const Text('Wrong Something');
              }
            },
          ),
        ),
      ),
    );
  }

  eidDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          final height = MediaQuery.of(context).size.height;
          final width = MediaQuery.of(context).size.width;
          final textTheme = Theme.of(context).textTheme;
          return AlertDialog(
            backgroundColor: white,
            title: const Text('Edit profile'),
            content: SizedBox(
              height: height * 0.4,
              width: width * 0.8,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      hintText: 'Name',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: black),
                          borderRadius: BorderRadius.circular(20)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: black),
                          borderRadius: BorderRadius.circular(20)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: black),
                          borderRadius: BorderRadius.circular(20)),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: black),
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                  Gap(height * 0.02),
                  TextFormField(
                    controller: idController,
                    decoration: InputDecoration(
                      labelText: 'ID',
                      hintText: 'ID',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: black),
                          borderRadius: BorderRadius.circular(20)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: black),
                          borderRadius: BorderRadius.circular(20)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: black),
                          borderRadius: BorderRadius.circular(20)),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: black),
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                  Gap(height * 0.02),
                  widget.isAdmin
                      ? TextFormField(
                          controller: positionController,
                          decoration: InputDecoration(
                            labelText: 'Position',
                            hintText: 'Position',
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: black),
                                borderRadius: BorderRadius.circular(20)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: black),
                                borderRadius: BorderRadius.circular(20)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: black),
                                borderRadius: BorderRadius.circular(20)),
                            disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: black),
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            actions: [
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: textTheme.titleSmall!.copyWith(color: red),
                  )),
              InkWell(
                onTap: () {
                  updateProfile();
                },
                child: Container(
                  height: height * 0.05,
                  width: width * 0.2,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15), color: black),
                  child: Center(
                      child: Text(
                    'Update',
                    style: textTheme.titleMedium!.copyWith(color: white),
                  )),
                ),
              )
            ],
          );
        });
  }

  void logOut() async {
    try {
      await FirebaseAuth.instance.signOut().then((value) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
        Utils().toastMessages('SignOut');
      });
    } catch (error) {
      Utils().toastMessages(error.toString());
    }
  }

  updateProfile() {
    ref2.child(widget.uid.toString()).update({
      'userName': nameController.text.toString(),
      'id': idController.text.toString(),
      'position': positionController.text.toString()
    }).then((value) {
      Navigator.pop(context);
      Utils().toastMessages('Updated');
    }).onError((e, stackTrace) {
      Utils().toastMessages(e.toString());
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
    final User? user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    FirebaseStorage storage =
        FirebaseStorage.instanceFor(bucket: 'gs://ncc-apps-47109.appspot.com');
    Reference storageRef = storage.ref().child("image $uid");
    UploadTask uploadTask = storageRef.putFile(image);
    Future.value(uploadTask).then((value) async {
      url = await storageRef.getDownloadURL();
      addPost(url);
    }).catchError((onError) {
      Utils().toastMessages(onError);
    });
  }

  void addPost(String url) {
    final User? user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    ref2.child(uid!).update({
      'profileImage': url,
    }).then((value) {
      Utils().toastMessages('Profile image updated');
    }).onError((error, stackTrace) {
      Utils().toastMessages(error.toString());
    });
  }
}
