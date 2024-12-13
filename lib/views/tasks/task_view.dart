import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/extensions/space_exs.dart';
import 'package:todo_list/main.dart';
import 'package:todo_list/models/task.dart';
import 'package:todo_list/utils/app_colors.dart';
import 'package:todo_list/utils/app_str.dart';
import 'package:todo_list/utils/constants.dart';
import 'package:todo_list/views/tasks/components/date_time_selection.dart';
import 'package:todo_list/views/tasks/components/rep_textfield.dart';
import 'package:todo_list/views/tasks/widget/task_view_app_bar.dart';

class TaskView extends StatefulWidget {
  const TaskView({
    super.key,
    required this.titleTaskController,
    required this.descriptionTaskController,
    required this.task,
  });

  final TextEditingController? titleTaskController;
  final TextEditingController? descriptionTaskController;
  final Task? task;

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  var title;
  var subTitle;
  DateTime? time;
  DateTime? date;

  String showTime(DateTime? time) {
    if (time != null) {
      return DateFormat('hh:mm a').format(time).toString();
    } else if (widget.task?.createdAtTime != null) {
      return DateFormat('hh:mm a').format(widget.task!.createdAtTime).toString();
    } else {
      return DateFormat('hh:mm a').format(DateTime.now()).toString();
    }
  }

  String showDate(DateTime? date) {
    if (date != null) {
      return DateFormat.yMMMEd().format(date).toString();
    } else if (widget.task?.createdAtDate != null) {
      return DateFormat.yMMMEd().format(widget.task!.createdAtDate).toString();
    } else {
      return DateFormat.yMMMEd().format(DateTime.now()).toString();
    }
  }

  DateTime showDateAsDateTime(DateTime? date) {
    if (date != null) {
      return date;
    } else if (widget.task?.createdAtDate != null) {
      return widget.task!.createdAtDate;
    } else {
      return DateTime.now();
    }
  }

  bool isTaskAlreadyExist() {
    return widget.task != null;
  }

  dynamic isTaskAlreadyExistUpdateOtherwiseCreate() {
    if (isTaskAlreadyExist()) {
      try {
        // Update hanya data yang diubah
        if (title != null && title.isNotEmpty) {
          widget.task!.title = title;
        }
        if (subTitle != null && subTitle.isNotEmpty) {
          widget.task!.subTitle = subTitle;
        }
        if (date != null) {
          widget.task!.createdAtDate = date!;
        }
        if (time != null) {
          widget.task!.createdAtTime = time!;
        }

        widget.task?.save();

        Navigator.pop(context);
      } catch (e) {
        updateTaskWarning(context);
      }
    } else {
      if (title != null && title.isNotEmpty && subTitle != null && subTitle.isNotEmpty) {
        var task = Task.create(
          title: title,
          subTitle: subTitle,
          createdAtDate: date ?? DateTime.now(),
          createdAtTime: time ?? DateTime.now(),
        );

        BaseWidget.of(context).dataStore.addTask(task: task);

        Navigator.pop(context);
      } else {
        emptyWarning(context);
      }
    }
  }

  dynamic deleteTask() {
    return widget.task?.delete();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        // AppBar
        appBar: const TaskViewAppBar(),

        // Body
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTopSideTexts(textTheme),
                _buildMainTaskViewActivity(
                  textTheme,
                  context,
                ),
                _buildBottomSideButtons()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSideButtons() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: isTaskAlreadyExist()
            ? MainAxisAlignment.spaceEvenly
            : MainAxisAlignment.center,
        children: [
          isTaskAlreadyExist()
              ? MaterialButton(
                  onPressed: () {
                    deleteTask();
                    Navigator.pop(context);
                  },
                  minWidth: 150,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  height: 55,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.close,
                        color: AppColors.primaryColor,
                      ),
                      5.w,
                      const Text(
                        AppStr.deleteTask,
                        style: TextStyle(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),

          // Add or Update Task
          MaterialButton(
            onPressed: () {
              isTaskAlreadyExistUpdateOtherwiseCreate();
            },
            minWidth: 150,
            color: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            height: 55,
            child: Text(
              isTaskAlreadyExist()
                  ? AppStr.updateTaskString
                  : AppStr.addTaskString,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  SizedBox _buildMainTaskViewActivity(
      TextTheme textTheme, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 530,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Text(AppStr.titleOfTitleTextField,
                style: textTheme.headlineMedium),
          ),

          // Task Title
          RepTextField(
            controller: widget.titleTaskController,
            onChanged: (String inputTitle) {
              title = inputTitle;
            },
            onFieldSubmitted: (String inputTitle) {
              title = inputTitle;
            },
          ),

          10.h,

          // Task Description
          RepTextField(
            controller: widget.descriptionTaskController,
            isForDescription: true,
            onFieldSubmitted: (String inputSubTitle) {
              subTitle = inputSubTitle;
            },
            onChanged: (String inputSubTitle) {
              subTitle = inputSubTitle;
            },
          ),

          // Time Selection
          DateTimeSelectionWidget(
            onTap: () async {
              final pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(
                    time ?? widget.task?.createdAtTime ?? DateTime.now()),
              );
              if (pickedTime != null) {
                setState(() {
                  time = DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                    pickedTime.hour,
                    pickedTime.minute,
                  );
                });
              }
            },
            title: "Time",
            time: showTime(time), // memastikan waktu ter-update
          ),

          // Date Selection
          DateTimeSelectionWidget(
            onTap: () {
              DatePicker.showDatePicker(
                context,
                maxDateTime: DateTime(2030, 4, 5),
                minDateTime: DateTime.now(),
                initialDateTime: showDateAsDateTime(date),
                onConfirm: (dateTime, _) {
                  setState(() {
                    date = dateTime;
                  });
                },
              );
            },
            title: AppStr.dateString,
            isTime: true,
            time: showDate(date), // memastikan tanggal ter-update
          ),
        ],
      ),
    );
  }

  Widget _buildTopSideTexts(TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 70,
            child: Divider(
              thickness: 2,
            ),
          ),
          RichText(
              text: TextSpan(
            text: isTaskAlreadyExist()
                ? AppStr.updateCurrentTask
                : AppStr.addNewTask,
            style: textTheme.titleLarge,
            children: const [
              TextSpan(
                text: AppStr.taskStrnig,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          )),
          const SizedBox(
            width: 70,
            child: Divider(
              thickness: 2,
            ),
          ),
        ],
      ),
    );
  }
}