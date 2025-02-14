import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ncc_apps/Users%20UI/Cards/commentScreen.dart';
import 'package:ncc_apps/Users%20UI/profile_screen.dart';
import 'package:ncc_apps/Utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Utils/utils.dart';

class NewsView extends StatefulWidget {
  final String time;
  final bool isAdmin;
  final String image;
  final String postContent;
  final String code;
  final String userId;
  final String postKey;
  final String token;
  final String like;
  final bool isLiked;
  const NewsView({
    Key? key,
    required this.time,
    required this.image,
    required this.postContent,
    required this.userId,
    required this.postKey,
    required this.like,
    required this.isLiked,
    required this.isAdmin,
    required this.token,
    required this.code,
  }) : super(key: key);

  @override
  State<NewsView> createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    bool isAction = (widget.userId == uid);
    DatabaseReference ref = FirebaseDatabase.instanceFor(
            app: Firebase.app(),
            databaseURL: 'https://ncc-apps-47109-default-rtdb.firebaseio.com')
        .ref("user/${widget.userId}");
    DatabaseReference ref2 = FirebaseDatabase.instanceFor(
            app: Firebase.app(),
            databaseURL: 'https://ncc-apps-47109-default-rtdb.firebaseio.com')
        .ref("post/${widget.postKey}");
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: height * 0.1,
        minWidth: width * 0.95,
      ),
      child: Container(
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          border: Border.all(),
          color: white.withOpacity(0.4),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder(
              stream: ref.onValue,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  final DataSnapshot data = snapshot.data!.snapshot;
                  final Map<dynamic, dynamic>? map =
                      data.value as Map<dynamic, dynamic>?;
                  if (widget.isAdmin == true) {
                    isAction = true;
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: width * 0.8,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileScreen(
                                        isAdmin: widget.isAdmin,
                                        uid: widget.userId)));
                          },
                          child: ListTile(
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.black87, width: 3)),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: map?['profileImage'].toString() == ""
                                      ? const Icon(Icons.person)
                                      : Image(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              map?['profileImage']))),
                            ),
                            title: Text(map?['userName']),
                            subtitle: Text(
                                '${widget.time.substring(0, 11)} at ${widget.time.substring(11, 16)}'),
                          ),
                        ),
                      ),
                      isAction
                          ? PopupMenuButton(
                              icon: const Icon(Icons.more_horiz_outlined),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 1,
                                  child: InkWell(
                                    onTap: () {
                                      showDeleteDialog(ref2);
                                    },
                                    child: Text('Delete',
                                        style: textTheme.titleSmall!.copyWith(
                                            fontWeight: FontWeight.w400)),
                                  ),
                                ),
                              ],
                            )
                          : PopupMenuButton(
                              icon: const Icon(Icons.more_horiz_outlined),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 1,
                                  child: InkWell(
                                    onTap: () {
                                      Utils().toastMessages(
                                          "You can't access this post");
                                      Navigator.pop(context);
                                    },
                                    child: Text('Delete',
                                        style: textTheme.titleSmall!.copyWith(
                                            fontWeight: FontWeight.w400)),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  );
                } else {
                  return const Text('Wrong Something');
                }
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        minHeight: 0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onLongPress: () {
                              Utils().toastMessages('Copied');
                              Clipboard.setData(ClipboardData(text: widget.postContent));
                            },
                            child: Linkify(
                              text: widget.postContent,
                              onOpen: (link) => _launchURL(Uri.parse(link.url)),
                              maxLines: isExpanded ? null : 2,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isExpanded = !isExpanded;
                              });
                            },
                            child: Text(
                              isExpanded ? 'Read Less' : '..Read More',
                              style: TextStyle(
                                color: black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    widget.code != ''
                        ? ConstrainedBox(
                            constraints: const BoxConstraints(
                              minHeight: 0,
                            ),
                            child: Container(
                              padding: EdgeInsets.only(left: width*0.02),
                              width: width,
                              decoration: BoxDecoration(
                                border: Border.all(),
                              ),
                              child:  SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SizedBox(
                                  child: SelectableText(widget.code,style: GoogleFonts.courierPrime()),
                                ),
                              ),
                            ),
                          )
                        : const Gap(0.0001),
                    Gap(height * 0.01),
                    widget.image != ''
                        ? Image(image: NetworkImage(widget.image))
                        : const Gap(0.0001),
                    Gap(height * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            final User? user =
                                FirebaseAuth.instance.currentUser;
                            final uid = user?.uid;
                            if (widget.isLiked) {
                              ref2.child('like').child(uid!).remove();
                            } else {
                              ref2.child('like').update({
                                uid.toString(): uid,
                              }).then((value) {
                                Utils().toastMessages('Liked');
                              }).onError((error, stackTrace) {
                                Utils().toastMessages(error.toString());
                              });
                            }
                          },
                          child: SizedBox(
                              child: Row(
                            children: [
                              widget.isLiked
                                  ? Icon(
                                      Icons.thumb_up_alt_sharp,
                                      color: green,
                                    )
                                  : Icon(
                                      Icons.thumb_up_alt_sharp,
                                      color: black,
                                    ),
                              Gap(width * 0.03),
                              Text(widget.like.toString()),
                            ],
                          )),
                        ),
                        const Gap(2),
                        InkWell(
                            onTap: () {
                              showBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CommentScreen(
                                      postKey: widget.postKey,
                                      token: widget.token,
                                    );
                                  });
                            },
                            child: const Icon(Icons.mode_comment)),
                      ],
                    ),
                    Gap(height * 0.01),
                  ],
                ),
              ),
            )
          ],
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

  showDeleteDialog(DatabaseReference ref2) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(
                  Icons.delete,
                ),
                Gap(10),
                SizedBox(child: Text('Delete Post'))
              ],
            ),
            content: const Text('Are sure?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    ref2.remove();
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text('delete')),
            ],
          );
        });
  }
}
