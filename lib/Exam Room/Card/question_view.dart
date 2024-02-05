import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:gap/gap.dart';
import 'package:ncc_apps/Utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Utils/utils.dart';

class QuestionView extends StatefulWidget {
  final String question;
  final String correctAns;
  final String questionNo;
  final String ans;
  final String name;
  const QuestionView(
      {super.key,
      required this.question,
      required this.correctAns,
      required this.questionNo,
      required this.ans, required this.name});

  @override
  State<QuestionView> createState() => _QuestionViewState();
}

class _QuestionViewState extends State<QuestionView> {
  TextEditingController ansController = TextEditingController();
  bool isOpenSheet = false;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 10),
      child: InkWell(
        onTap: () {
          setState(() {
            isOpenSheet = true;
          });
        },
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: width * 0.01, vertical: height * 0.002),
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.01, vertical: height * 0.005),
          width: width,
          color: grey.withOpacity(0.3),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Q.No ${widget.questionNo} : ',
                    style: textTheme.titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: width * 0.73,
                    child: Linkify(text: widget.question, style: textTheme.titleMedium,onOpen: (link) => _launchURL(Uri.parse(link.url))),
                  )
                ],
              ),
              isOpenSheet
                  ? Row(
                      children: [
                        SizedBox(
                          width: width * 0.7,
                          child: TextFormField(
                            controller: ansController,
                            decoration: InputDecoration(
                              hintText: 'Answer',
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
                        ),
                        Gap(width * 0.01),
                        InkWell(
                          onTap: () {
                            setState(() {
                              isOpenSheet = false;
                              submitAns();
                            });
                          },
                          child: Container(
                            height: height * 0.075,
                            width: width * 0.2,
                            decoration: BoxDecoration(
                              color: black,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                                child: Text(
                              'Submit',
                              style:
                                  textTheme.titleMedium!.copyWith(color: white),
                            )),
                          ),
                        )
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ans : ',
                          style: textTheme.titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: width * 0.78,
                          child: Text(widget.ans,
                              style: textTheme.titleMedium!.copyWith(
                                  color: widget.correctAns.toLowerCase() ==
                                          widget.ans.toLowerCase()
                                      ? deepGreen
                                      : red)),
                        )
                      ],
                    ),
            ],
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

  void submitAns() {
    DatabaseReference ref = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: 'https://ncc-apps-47109-default-rtdb.firebaseio.com')
        .ref("Exam Hub/group/${widget.name}");
    ref.child('Question').child(widget.questionNo).update({
      'Ans': ansController.text.toString(),
    }).then((value) {
      Utils().toastMessages('Submitted');
    }).onError((error, stackTrace) {
      Utils().toastMessages(error.toString());
    });
  }
}
