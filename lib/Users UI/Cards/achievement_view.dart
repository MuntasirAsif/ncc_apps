import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ncc_apps/Full%20View/achievement_view_Screen.dart';
import 'package:ncc_apps/Utils/colors.dart';

class AchievementView extends StatelessWidget {
  final String title;
  final String ranking;
  final String image;
  final String postContent;
  const AchievementView({
    Key? key,
    required this.title,
    required this.ranking,
    required this.image,
    required this.postContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => AchievementScreen(image: image, title: title, postContent: postContent,)));
      },
      child: Container(
        width: width * .6,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
        decoration: BoxDecoration(
            border: Border.all(),
            color: white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: height * 0.3,
              decoration: BoxDecoration(
                  color: bgGreen,
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: NetworkImage(image),
                    fit: BoxFit.cover,
                  )),
            ),
            Row(
              children: [
                const Icon(Icons.auto_graph_outlined),
                Gap(height * 0.01),
                Text(
                  'Rank: $ranking',
                  style: textTheme.titleLarge,
                ),
              ],
            ),
            SizedBox(
                height: height * 0.09,
                child: Text(
                  title,
                  style: textTheme.titleMedium,
                )),
            Gap(height * 0.01),
          ],
        ),
      ),
    );
  }
}
