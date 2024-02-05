import 'package:flutter/material.dart';
import 'package:ncc_apps/Utils/colors.dart';

class GroupResultView extends StatelessWidget {
  final String roomName;
  final String point;
  final String time;
  const GroupResultView(
      {super.key,
        required this.roomName,
        required this.point,
        required this.time});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
          color: grey.withOpacity(0.3),
          border: Border.all(),
          borderRadius: BorderRadius.circular(10)
      ),

      child: ListTile(
        title: Text(roomName),
        subtitle: Text('Remaining : $time min',style: textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),),
        trailing: Text('Score: $point',style: textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),),
      ),
    );
  }
}