import 'package:all_in_one_app/src/data/database_helper.dart';
import 'package:all_in_one_app/src/models/Task.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class MyToDoPage extends StatefulWidget {
  const MyToDoPage({Key key}) : super(key: key);

  @override
  _MyToDoPageState createState() => _MyToDoPageState();
}

class _MyToDoPageState extends State<MyToDoPage> {
  CalendarController calController;
  final dateFormat = new DateFormat("EEE d MMM yyyy");
  DateTime _selectedDate = DateTime.now();
  List taskList = [];
  TextEditingController tfTitleController = TextEditingController();
  TextEditingController tfDecController = TextEditingController();
  GlobalKey<FormState> key = GlobalKey();

  Map<DateTime, List> _events = {};

  @override
  void initState() {
    super.initState();
    calController = CalendarController();
    getAllTasksByDate();
  }

  Future getAllTasks() async {
    List<Map<String, dynamic>> queryAll =
        await DataBaseHelper.instance.allTasks();
    _events.clear();
    queryAll.forEach((item) {
      _events[dateFormat.parse(item[DataBaseHelper.columnDate])] = [''];
    });
    setState(() {});
  }

  Future getAllTasksByDate() async {
    List<Map<String, dynamic>> queryRows = await DataBaseHelper.instance
        .onDateTasks(dateFormat.format(_selectedDate));
    queryRows.forEach((item) {
      Task toBeAdd = new Task();
      toBeAdd.id = item[DataBaseHelper.columnId];
      toBeAdd.title = item[DataBaseHelper.columnTitle];
      toBeAdd.description = item[DataBaseHelper.columnDescription];
      toBeAdd.completed = item[DataBaseHelper.columnCompleted] == 1;
      toBeAdd.date = dateFormat.parse(item[DataBaseHelper.columnDate]);
      taskList.add(toBeAdd);
    });
    setState(() {});
  }

  removeTask(index) async {
    Task tobeRemoved = taskList.removeAt(index);
    int i = await DataBaseHelper.instance
        .deleteTask({DataBaseHelper.columnId: tobeRemoved.id});
    setState(() {
      print('row deleted $i');
    });
  }

  removeTaskFromList(index) async {
    taskList.removeAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    getAllTasks();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TableCalendar(
                calendarController: calController,
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  centerHeaderTitle: true,
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekendStyle: TextStyle(color: Colors.grey),
                ),
                calendarStyle: CalendarStyle(
                  markersColor: Colors.grey,
                  weekendStyle: TextStyle(color: Colors.grey),
                  outsideDaysVisible: false,
                ),
                events: _events,
                onDaySelected: (date, events, holiday) {
                  print(date);

                  setState(() {
                    taskList = [];
                    _selectedDate = date;
                    getAllTasksByDate();
                  });
                },
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10, top: 20),
                height: size.height * 0.85,
                width: size.width,
                decoration: BoxDecoration(
                  color: Colors.indigo.shade300,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                ),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titleDateSelect(),
                        style: Theme.of(context).textTheme.headline5.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      listToDo(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        child: const Icon(Icons.add, color: Colors.black),
        backgroundColor: Colors.grey.shade300,
        onPressed: () async {
          print("เพิ่ม");
          await showToDoDialog(context, null, null);
          setState(() {});
        },
      ),
    );
  }

  titleDateSelect() {
    var now = DateTime.now();
    if (dateFormat.format(_selectedDate) == dateFormat.format(now))
      return "Today";
    return dateFormat.format(_selectedDate).toString();
  }

  Container listToDo() {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Expanded(
        child: ListView.builder(
          itemCount: taskList.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: Key(taskList[index].id.toString()),
              onDismissed: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  print("ลบ");
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('${taskList[index].title} task deleted'),
                    duration: Duration(seconds: 1),
                  ));
                  removeTask(index);
                } else {
                  print("แก้ไข");
                  Task task = taskList[index];
                  int taskIndex = taskList.indexOf(task);
                  removeTaskFromList(index);
                  await showToDoDialog(context, task, taskIndex);
                  setState(() {});
                }
              },
              secondaryBackground: Container(
                alignment: Alignment.centerRight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.only(right: 10),
                child: Icon(Icons.delete),
              ),
              background: Container(
                padding: EdgeInsets.only(left: 10),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(Icons.edit),
              ),
              child: Card(
                color: Colors.indigo.shade200,
                elevation: 0,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: taskList[index].completed
                          ? Icon(
                              Icons.assignment_turned_in,
                              color: Colors.green.shade100,
                              size: 30,
                            )
                          : Icon(
                              Icons.watch_later,
                              color: Colors.orange.shade100,
                              size: 30,
                            ),
                    ),
                    Container(
                      width: size.width * 0.75,
                      padding: EdgeInsets.only(
                          left: 0, right: 0, top: 12, bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${taskList[index].title}',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            taskList[index].description,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  showToDoDialog(BuildContext context, Task task, int index) async {
    bool isCompleted = task != null ? task.completed : false;
    tfTitleController.text = task != null ? task.title : tfTitleController.text;
    tfDecController.text =
        task != null ? task.description : tfDecController.text;

    return showDialog(
      context: context,
      barrierDismissible: task == null,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
            content: Container(
              child: Form(
                key: key,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: tfTitleController,
                      validator: (value) {
                        return value.isEmpty ? "Required *" : null;
                      },
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                          hintText: "title",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.black,
                          ))),
                    ),
                    SizedBox(height: 10),
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: 100,
                      ),
                      child: TextFormField(
                        controller: tfDecController,
                        maxLines: null,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                        decoration: InputDecoration(
                            hintText: "Description",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.black,
                            ))),
                      ),
                    ),
                    SizedBox(height: 10),
                    task == null
                        ? SizedBox()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Completed",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              Checkbox(
                                value: isCompleted,
                                onChanged: (value) {
                                  setState(() {
                                    isCompleted = value;
                                  });
                                },
                                activeColor: Colors.green.shade300,
                                checkColor: Colors.white,
                              )
                            ],
                          ),
                  ],
                ),
              ),
            ),
            actions: [
              Container(
                padding: EdgeInsets.only(right: 10),
                child: TextButton(
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () async {
                    if (key.currentState.validate()) {
                      Task newTask = Task(
                        title: tfTitleController.text,
                        description: tfDecController.text,
                        completed: isCompleted,
                        date: _selectedDate,
                      );
                      tfTitleController.text = '';
                      tfDecController.text = '';
                      if (task == null) {
                        newTask.id = await DataBaseHelper.instance.insertTask({
                          DataBaseHelper.columnTitle: newTask.title,
                          DataBaseHelper.columnDescription: newTask.description,
                          DataBaseHelper.columnCompleted:
                              newTask.completed ? 1 : 0,
                          DataBaseHelper.columnDate:
                              dateFormat.format(newTask.date).toString(),
                        });
                        print(' >>>>>>>> the id of new task ${newTask.id}');
                        taskList.add(newTask);
                      } else {
                        newTask.id = task.id;
                        int result = await DataBaseHelper.instance.updateTask({
                          DataBaseHelper.columnId: newTask.id,
                          DataBaseHelper.columnTitle: newTask.title,
                          DataBaseHelper.columnDescription: newTask.description,
                          DataBaseHelper.columnCompleted:
                              newTask.completed ? 1 : 0,
                          DataBaseHelper.columnDate:
                              dateFormat.format(newTask.date).toString(),
                        });
                        print('row updated $result');

                        taskList.insert(index, newTask);
                      }
                      Navigator.of(context).pop();
                    }
                  },
                ),
              )
            ],
          );
        });
      },
    );
  }
}
