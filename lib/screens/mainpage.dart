import 'package:flutter/material.dart';
import 'package:taskmanaging/screens/completedTAsk.dart';
import 'package:taskmanaging/screens/plannedTask.dart';
import 'package:taskmanaging/screens/todaysTask.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Tasks"),
            bottom: TabBar(
                tabs: [
                  Tab(text: "Todays Task",),
                  Tab(text: "Planned Task",),
                  Tab(text: "Completed Task",),
                ],
            ),
          ),
          body: TabBarView(
              children: [
                TodaysTask(),
                PlannedTask(),
                CompletedTask(),

          ]
          ),
        ),
    );
  }
}

