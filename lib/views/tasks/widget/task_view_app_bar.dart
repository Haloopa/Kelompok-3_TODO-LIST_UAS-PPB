import 'package:flutter/material.dart';

class TaskViewAppBar extends StatefulWidget implements PreferredSizeWidget {
  const TaskViewAppBar({super.key});

  @override
  State<TaskViewAppBar> createState() => _TaskViewAppBarState();
  
  @override
  Size get preferredSize => const Size.fromHeight(150);
}

class _TaskViewAppBarState extends State<TaskViewAppBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 150,
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back_ios_new_rounded)),
          )
        ],),
      ),
    );
  }

  
}