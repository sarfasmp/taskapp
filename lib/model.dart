class Task{
  int id;
  String details;
  String priority;
  String date;
  int status;





  Task({this.details,this.priority,this.date,this.status});
  Task.withId({this.id,this.details,this.priority,this.date,this.status});
//convert a note object into map object
  Map<String, dynamic> toMap(){
    final map=Map <String, dynamic>();
    if(id!=null ) {
      map['id'] = id;
    }
    map['details']=details;
    map['priority']=priority;
    map['date']=date;
    map['status']=status;
    return map;
  }

// Extract a Note object from a Map object
  factory Task.fromMap(Map<String,dynamic> map){
    return Task.withId(
        id: map['id'],
      details: map['details'],
      priority: map['priority'],
      date: map['date'],
      status: map['status']

    );
  }
}