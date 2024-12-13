import 'package:flutter/material.dart';

class DateTimeSelectionWidget extends StatelessWidget {
  const DateTimeSelectionWidget({
    super.key,
    required this.onTap,
    required this.title,
    required this.time,
    this.isTime = false,
  });

  final VoidCallback onTap;
  final String title;
  final String time;
  final bool isTime;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        height: 55,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Icon(
                    isTime ? Icons.access_time : Icons.calendar_today,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 10),
              width: isTime ? 150 : 80,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade100,
              ),
              child: Center(
                child: Text(
                  time.isEmpty ? "Select $title" : time,
                  style: textTheme.titleSmall?.copyWith(
                    color: time.isEmpty ? Colors.grey.shade400 : Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}