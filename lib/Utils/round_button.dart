import 'package:flutter/material.dart';

import 'colors.dart';
class RoundButton extends StatelessWidget {
  final String inputText;
  const RoundButton({Key? key, required this.inputText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      height: height*0.06,
      width: width*0.4,
      decoration:  BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(child: Text(inputText,style: textTheme.bodyLarge!.copyWith(color: white),)),
    );
  }
}
