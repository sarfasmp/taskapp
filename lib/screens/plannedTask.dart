import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:taskmanaging/database_helper.dart';
import 'package:taskmanaging/model.dart';
import 'package:taskmanaging/screens/dataPage.dart';

class PlannedTask extends StatefulWidget {



  @override
  _PlannedTaskState createState() => _PlannedTaskState();
}

class _PlannedTaskState extends State<PlannedTask> {
  Future<List<Task>> _taskList;


  @override
  void initState() {
    super.initState();
    _updateTaskList();

  }
  _updateTaskList(){

    setState(() {
      _taskList=DataBaseHelper.instance.getPlannedTwo();
    });
  }


  Widget todaytask(Task task){
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio:0.25,
      child: ListTile(
        trailing: OutlineButton(onPressed: (){
          print('complete');
          DataBaseHelper.instance.updateStatus(task);
          _updateTaskList();
          print(task.status);
        },
          child: Text("Complete"),

        ),
        onTap: (){
          print(task.status);
        },
        title: Text(task.details),
        subtitle: Text(task.priority+"  "+task.date+"  id "+task.id.toString()),
      ),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Edit',
          icon: Icons.edit,
          color: Colors.black,
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return DataPge(
                task: task,
                updateTaskList: _updateTaskList,

              );
            },
            ),//MaterialpageRoute
            );//push
          },
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: "delete",
          color: Colors.black,
          icon: Icons.delete,
          onTap: (){
            DataBaseHelper.instance.delete(task.id);
            _updateTaskList();
          }
          ,
        )
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        splashColor: Colors.black,
        elevation: 20,
        child: IconButton(icon: Icon(Icons.add),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return DataPge(

                updateTaskList: _updateTaskList,
              );
            },
            ),//MaterialpageRoute
            );//push
          },
        ),

      ),
      body: FutureBuilder(
        future: _taskList,
        builder: (context,snapshot) {
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator(),);
          }
          return
            ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context,int index) {
                return todaytask(snapshot.data[index]);
              },
            );
        },
      ),
    );
  }
}
