import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:ncc_apps/Users%20UI/Cards/news_View.dart';
import 'package:ncc_apps/Users%20UI/post_screen.dart';
import '../Utils/colors.dart';

class NewsFeed extends StatefulWidget {
  final bool isAdmin;
  const NewsFeed({Key? key, required this.isAdmin}) : super(key: key);

  @override
  State<NewsFeed> createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  DatabaseReference ref = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL: 'https://ncc-apps-47109-default-rtdb.firebaseio.com')
      .ref("post");
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    Size screenSize = MediaQuery.of(context).size;
    EdgeInsets padding = MediaQuery.of(context).padding;
    double appBarHeight = AppBar().preferredSize.height;
    double bottomNavigationBarHeight = kBottomNavigationBarHeight;
    double availableHeight = screenSize.height -
        padding.vertical -
        appBarHeight -
        bottomNavigationBarHeight -
        5;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: white,
        title: Text(
          'News Feed',
          style: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
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
              SizedBox(
                height: availableHeight,
                width: width,
                child: FirebaseAnimatedList(
                    query: ref,
                    sort: (DataSnapshot a, DataSnapshot b) {
                      return b.key!.compareTo(a.key!);
                    },
                    itemBuilder: (context, snapshot, animation, index) {
                      return NewsView(
                        time: snapshot.child('Time').value.toString(),
                        image: snapshot.child('image').value.toString(),
                        postContent:
                            snapshot.child('postContent').value.toString(),
                        userId: snapshot.child('userId').value.toString(),
                        postKey: snapshot.child('postKey').value.toString(),
                        like: snapshot.child('like').children.indexed.length.toString(),
                        isLiked: snapshot.child('like').child(uid!).exists,
                        isAdmin: widget.isAdmin,
                        token: snapshot.child('token').value.toString(),
                        code: snapshot.child('code').value.toString(),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PostScreen(
                        isAdmin: widget.isAdmin,
                      )));
        },
        child: Container(
          height: height * 0.05,
          width: width * 0.30,
          decoration: BoxDecoration(
              color: bgGreen.withOpacity(0.7),
              border: Border.all(),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                FontAwesomeIcons.circlePlus,
                color: black,
              ),
              Gap(width * 0.02),
              const Text('Add Post')
            ],
          ),
        ),
      ),
    );
  }
}
