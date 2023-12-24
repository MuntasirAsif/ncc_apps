import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ncc_apps/Utils/colors.dart';

class NCCMemberRequest extends StatefulWidget {
  final String photo;
  const NCCMemberRequest({Key? key, required this.photo}) : super(key: key);

  @override
  State<NCCMemberRequest> createState() => _NCCMemberRequestState();
}

class _NCCMemberRequestState extends State<NCCMemberRequest> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'NCC Membership',
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.03),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Gap(height * 0.01),
                Container(
                  height: height * 0.15,
                  width: width * 0.31,
                  decoration: BoxDecoration(
                      color: black,
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(100)),
                  child: Center(
                    child: Container(
                      height: height * 0.145,
                      width: width * 0.305,
                      decoration: BoxDecoration(
                          color: white,
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(100)),
                      child: const Icon(
                        Icons.person,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                Gap(height * 0.02),
                Text(
                  '* To get NCC membership fill-up the form & submit',
                  style: textTheme.bodyMedium,
                ),
                Gap(height * 0.01),
                TextFormField(
                  decoration: InputDecoration(
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
                Gap(height * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: height * 0.07,
                      width: width * 0.45,
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Age',
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
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * .03, vertical: height * 0.02),
                      height: height * 0.07,
                      width: width * 0.45,
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(20)),
                      child: const Text('Gender'),
                    ),
                  ],
                ),
                Gap(height * 0.01),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * .03, vertical: height * 0.02),
                  height: height * 0.07,
                  width: width * 0.95,
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(20)),
                  child: const Text('Computer Science & engineering'),
                ),
                Gap(height * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: height * 0.07,
                      width: width * 0.45,
                      child: TextFormField(
                        decoration: InputDecoration(
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
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * .03, vertical: height * 0.02),
                      height: height * 0.07,
                      width: width * 0.45,
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(20)),
                      child: const Text('Section'),
                    ),
                  ],
                ),
                Gap(height * 0.01),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Best Skill',
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
                Gap(height * 0.01),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Present Address',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
