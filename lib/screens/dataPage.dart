import 'package:flutter/material.dart';
import 'package:taskmanaging/database_helper.dart';
import 'package:taskmanaging/model.dart';

class DataPge extends StatefulWidget {

  final Function updateTaskList;

  final Task task;



  DataPge({this.updateTaskList,this.task});

  @override
  _DataPgeState createState() => _DataPgeState();
}

class _DataPgeState extends State<DataPge> {
  String _details="";
  String _priority="";
  String _date="";
 final List <String> priolist=['today','week plan'];


  @override
  void initState() {
    if(widget.task != null){
      _details= widget.task.details;
      _priority=widget.task.priority;
      _date=widget.task.date;

      _updateTaskList();
    }
  }

  Future<List<Task>> _taskList;
  _updateTaskList(){

    setState(() {

      _taskList=DataBaseHelper.instance.getTaskList();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Task Details"),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              SizedBox(height: 50,),
      TextFormField(
        // obscureText: true,
        maxLines: 1,
        onChanged: (text){
          _details=text;
        },
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: Colors.blue,
              ),
              borderRadius: BorderRadius.circular(50)
          ),
          helperText: "Task Details",
          hintStyle: TextStyle(fontSize: 15),
          labelText: "Task Details",
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        validator: (input){
          return input.trim().isEmpty ? 'pls select a priority' : null ;
        },
      ),
              SizedBox(height: 20,),
        DropdownButtonFormField(
          items: priolist.map((String prio){
            return DropdownMenuItem(
              value: prio,
              child: Text(prio, ),
            );
          }).toList(),
          iconSize: 20,
          // obscureText: true,
          //maxLines: 5,
          onChanged: (text){
            _priority=text;
            },
         // keyboardType: TextInputType.text,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: Colors.blue,
                ),
                borderRadius: BorderRadius.circular(50)
            ),
            helperText: "Priority",
            hintStyle: TextStyle(fontSize: 15),
            labelText: "Priority",
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          validator: (input){
            return input.trim().isEmpty ? 'pls select a priority' : null ;
          },
        ),
              SizedBox(height: 20,),
              TextField(
                // obscureText: true,
                maxLines: 1,
                onChanged: (text){
                 _date =text;
                },
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Colors.blue,
                      ),
                      borderRadius: BorderRadius.circular(50)
                  ),
                  helperText: "Date",
                  hintStyle: TextStyle(fontSize: 15),
                  labelText: "Date",
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              RaisedButton(onPressed: (){

                print("checking");
                print(_details+"  "+_priority+"  "+_date);
                //insert the task to our users database
                Task task=Task(details: _details,priority: _priority,date: _date);

                if(widget.task== null){
                  task.status=0;
                  print(task.status);
                  DataBaseHelper.instance.insert(task);
                }
                else
                  {
                    print("idchecking"+widget.task.id.toString());
                    task.status=0;
                    task.id=widget.task.id;
                    DataBaseHelper.instance.update(task);
                   //widget.updateTaskList();


                  }
                 widget.updateTaskList();
                 Navigator.pop(context);
              },
                padding: EdgeInsets.all(10),
                child: Text("ADD",
                  style: TextStyle(fontSize: 20),),)
            ],
          ),
        ],
      ),
    );



  }
}
