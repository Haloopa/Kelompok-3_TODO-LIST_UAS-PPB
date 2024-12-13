import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_list/extensions/space_exs.dart';
import 'package:todo_list/main.dart';
import 'package:todo_list/models/task.dart';
import 'package:todo_list/utils/app_colors.dart';
import 'package:todo_list/utils/app_str.dart';
import 'package:todo_list/utils/constants.dart';
import 'package:todo_list/views/home/components/home_app_bar.dart';
import 'package:todo_list/views/home/components/slider_drawer.dart';
import 'package:todo_list/views/home/widget/task_widget.dart';
import 'components/fab.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  GlobalKey<SliderDrawerState> drawerKey = GlobalKey<SliderDrawerState>();

  dynamic valueOfIndicator(List<Task> task) {
    if (task.isNotEmpty) {
      return task.length;
    } else {
      return 3;
    }
  }

  int checkDoneTask(List<Task> tasks) {
    int i = 0;
    for (Task doneTask in tasks) {
      if (doneTask.isCompleted) {
        i++;
      }
    }
    return i;
  }
  
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    final base = BaseWidget.of(context);

    return ValueListenableBuilder(
      valueListenable: base.dataStore.listenToTask(), 
      builder: (ctx, Box<Task> box, Widget? child) {
        var tasks = box.values.toList();

        tasks.sort((a, b) => a.createdAtDate.compareTo(b.createdAtDate));

        return Scaffold(
          backgroundColor: Colors.white,

          //Floating ActionButton
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: const Fab(),
          ),

          //Body
          body: SafeArea(
            child: SliderDrawer(
              key:  drawerKey,
              isDraggable: false,
              animationDuration: 1000,
            
              //Drawer
              slider: CustomDrawer(),
            
            
                appBar: HomeAppBar(drawerKey: drawerKey,),
            
              //Main body
              child: _bulidHomeBody(
                textTheme,
                base,
                tasks
              ),
            ),
          ),
        );
      }
    );
  }

  //Home Body
  Widget _bulidHomeBody(
      TextTheme textTheme,
      BaseWidget base,
      List<Task> tasks
    ) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [

          //Custom App Bar
          Container(
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.05),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                //Progress Indicator
                SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    value: checkDoneTask(tasks) / valueOfIndicator(tasks),
                    backgroundColor: Colors.grey,
                    valueColor: const AlwaysStoppedAnimation(
                      AppColors.primaryColor,
                    ),
                  ),
                ),
                
                //Space
                25.w,

                //Top Level Task Info
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStr.mainTitle,
                      style: textTheme.displayLarge,
                    ),
                    3.h,
                    Text(
                      "${checkDoneTask(tasks)} of ${tasks.length} task",
                      style: textTheme.titleMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          //Divider
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Divider(
              thickness: 2,
              indent: MediaQuery.of(context).size.width * 0.25,
            ),
          ),
        
          // Task List or Empty State //BARU
          Expanded(
            child: tasks.isNotEmpty
            
            // Task list is not empty
            ? ListView.builder(
              itemCount: tasks.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                var task = tasks[index];
                return Dismissible(
                  direction: DismissDirection.horizontal,
                  onDismissed: (_) {
                    base.dataStore.deleteTask(task: task);
                  },
                  background: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.delete_outline,
                        color: Colors.grey,
                      ),
                      8.w,
                      const Text(
                        AppStr.deletedTask,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  key: Key(task.id),
                  child: TaskWidget(task: task),
                );
              })

          //Task list is empty
          : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              //Lottie Anime
              FadeIn(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Lottie.asset(
                    lottieURL, 
                    animate:tasks.isNotEmpty? false : true,
                  ),
                ),
              ),
              
              //Sub Text
              FadeInUp(
                from: 30,
                child: const Text(
                  AppStr.doneAllTask,
                ),
              ),
            ],
          ),
          ),
        ],
      ),
    );
  }
}

