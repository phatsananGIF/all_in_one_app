import 'package:all_in_one_app/src/data/database_people.dart';
import 'package:all_in_one_app/src/models/People.dart';
import 'package:all_in_one_app/src/screen/people/people_form.dart';
import 'package:all_in_one_app/src/screen/people/view_people.dart';
import 'package:flutter/material.dart';

class PeoPleList extends StatefulWidget {
  PeoPleList({Key key}) : super(key: key);

  @override
  _PeoPleListState createState() => _PeoPleListState();
}

class _PeoPleListState extends State<PeoPleList> {
  List peopleList = [];

  @override
  void initState() {
    super.initState();
    getAllPeople();
  }

  Future getAllPeople() async {
    peopleList = [];
    List<Map<String, dynamic>> queryAll =
        await DataBasePeople.instance.allData();
    queryAll.forEach((item) {
      People toBeAdd = new People();
      toBeAdd.id = item[DataBasePeople.columnId];
      toBeAdd.name = item[DataBasePeople.columnName];
      toBeAdd.phone = item[DataBasePeople.columnPhone];
      toBeAdd.email = item[DataBasePeople.columnEmail];
      peopleList.add(toBeAdd);
    });
    setState(() {});
  }

  removePeople(index) async {
    People tobeRemoved = peopleList.removeAt(index);
    int i = await DataBasePeople.instance
        .deleteData({DataBasePeople.columnId: tobeRemoved.id});
    setState(() {
      print('row deleted $i');
    });
  }

  removeFromList(index) async {
    peopleList.removeAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.indigo.shade300,
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _rowTitle(),
              SizedBox(height: 10),
              listPeople(),
            ],
          ),
        ),
      ),
    );
  }

  _rowTitle() {
    return Row(
      children: [
        Text(
          "Personal information",
          style: Theme.of(context)
              .textTheme
              .headline5
              .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Spacer(),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PeopleForm(),
              ),
            ).then(
              (value) => setState(() {
                print("set State");
                getAllPeople();
              }),
            );
          },
          icon: Icon(
            Icons.person_add,
            color: Colors.white,
          ),
        )
      ],
    );
  }

  listPeople() {
    return Expanded(
      child: ListView.builder(
        itemCount: peopleList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Dismissible(
              key: Key(peopleList[index].id.toString()),
              onDismissed: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  print("ลบ");
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('${peopleList[index].name} deleted'),
                    duration: Duration(seconds: 1),
                  ));
                  removePeople(index);
                } else {
                  print("แก้ไข");
                  People rowPeople = peopleList[index];
                  removeFromList(index);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PeopleForm(rowPeople: rowPeople),
                    ),
                  ).then(
                    (value) => setState(() {
                      print("set State");
                      getAllPeople();
                    }),
                  );
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
              child: InkWell(
                onTap: () {
                  People rowPeople = peopleList[index];
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewPeople(
                        infoPeople: rowPeople,
                      ),
                    ),
                  );
                },
                child: Card(
                  color: Colors.indigo.shade200,
                  elevation: 16,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8,right: 8,top: 14,bottom: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            '${peopleList[index].name}',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.only(left: 20),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.call,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    '${peopleList[index].phone}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .copyWith(color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.email,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    '${peopleList[index].email}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .copyWith(color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
