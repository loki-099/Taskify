import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:taskify/utils/colors.dart';

class PrioTaskCard extends StatefulWidget {
  final String taskTitle;
  final String taskDueDate;
  final String taskDueTime;
  final String taskPrio;
  final String taskStatus;

  const PrioTaskCard(
    this.taskTitle,
    this.taskDueDate,
    this.taskDueTime,
    this.taskPrio,
    this.taskStatus, {
    super.key,
  });

  @override
  State<PrioTaskCard> createState() => _PrioTaskCardState();
}

class _PrioTaskCardState extends State<PrioTaskCard> {
  bool taskStatus = false;

  Map<String, bool> taskStatuses = {"inp": false, "com": true};
  // TODO

  Map<String, LinearGradient> gradientClass = {
    "level3": LinearGradient(
      colors: [Color(0xeeBD1919), Color(0xffEF4444)],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    ),
    "level2": LinearGradient(
      colors: [Color(0xeeF59E0B), Color(0xffF2D200)],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    ),
    "level1": LinearGradient(
      colors: [Color(0xff00BA4D), Color(0xee10B984)],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      width: double.maxFinite,
      decoration: BoxDecoration(
        gradient: gradientClass[widget.taskPrio],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.taskTitle,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "Due: ${widget.taskDueDate} | ${widget.taskDueTime}",
                  style: TextStyle(fontSize: 14, color: AppColors.white),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 2,
            child: Checkbox(
              activeColor: Colors.transparent,
              checkColor: Colors.white,
              value: taskStatus,
              side: BorderSide(color: AppColors.white),
              onChanged:
                  (value) => {
                    setState(() {
                      taskStatus = value!;
                    }),
                  },
            ),
          ),
        ],
      ),
    );
  }
}
