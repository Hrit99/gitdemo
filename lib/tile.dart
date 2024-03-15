import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertasks/commit.dart';
import 'package:fluttertasks/repo.dart';

class Tile extends StatelessWidget {
  final Repo repo;
  final int index;
  final SlidableController? controller;
  const Tile(
      {super.key, required this.repo, required this.index, this.controller});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      controller: controller,
      key: const ValueKey(0),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {},
            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.remove_red_eye_outlined,
            label: repo.watchers.toString(),
            padding: EdgeInsets.all(0),
          ),
          SlidableAction(
            onPressed: (context) {},
            backgroundColor: Color(0xFF21B7CA),
            foregroundColor: Colors.white,
            icon: Icons.adjust_sharp,
            label: repo.open_issues.toString(),
            padding: EdgeInsets.all(0),
          ),
          SlidableAction(
            onPressed: (context) {},
            backgroundColor: Color(0xFF21B7CA),
            foregroundColor: Colors.white,
            icon: Icons.fork_right_sharp,
            label: repo.forks.toString(),
            padding: EdgeInsets.all(0),
          ),
        ],
      ),
      endActionPane:
          ActionPane(motion: const ScrollMotion(), extentRatio: 0.8, children: [
        ValueListenableBuilder<Commit>(
          valueListenable: repo.lastCommit!,
          builder: (context, value, child) {
            return SlidableAction(
              onPressed: (context) {},
              backgroundColor: Colors.brown,
              foregroundColor: Colors.white,
              label: value.message,
              padding: const EdgeInsets.all(5),
            );
          },
        ),
      ]),
      child: ListTile(
        tileColor: Colors.white,
        titleAlignment: ListTileTitleAlignment.top,
        contentPadding: EdgeInsets.all(5.0),
        title: Text(
          repo.name!,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        subtitle: Text(
          repo.description ?? "",
          style: TextStyle(
            color: Colors.black,
            fontSize: 10.0,
          ),
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
              color: repo.private ?? false
                  ? Colors.red.withOpacity(0.5)
                  : Colors.green.withOpacity(0.5),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Text(
            repo.private ?? false ? "Private" : "Public",
            style: TextStyle(fontSize: 10.0),
          ),
        ),
      ),
    );
  }
}
