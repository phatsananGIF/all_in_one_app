import 'package:all_in_one_app/src/data/database_people.dart';
import 'package:all_in_one_app/src/models/People.dart';
import 'package:flutter/material.dart';

class PeopleForm extends StatefulWidget {
  PeopleForm({Key key, this.rowPeople}) : super(key: key);
  People rowPeople;

  @override
  _PeopleFormState createState() => _PeopleFormState();
}

class _PeopleFormState extends State<PeopleForm> {
  TextEditingController tfNameController = TextEditingController();
  TextEditingController tfPhoneController = TextEditingController();
  TextEditingController tfEmailController = TextEditingController();
  GlobalKey<FormState> key = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tfNameController.text = widget.rowPeople != null
        ? widget.rowPeople.name
        : tfNameController.text;
    tfPhoneController.text = widget.rowPeople != null
        ? widget.rowPeople.phone
        : tfPhoneController.text;
    tfEmailController.text = widget.rowPeople != null
        ? widget.rowPeople.email
        : tfEmailController.text;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade300,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 18,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        padding: EdgeInsets.all(20),
        color: Colors.indigo.shade300,
        child: SingleChildScrollView(
          child: dataForm(),
        ),
      ),
    );
  }

  dataForm() {
    return Form(
      key: key,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 24),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
            ),
            child: TextFormField(
              controller: tfNameController,
              validator: (value) {
                return value.isEmpty ? "Required *" : null;
              },
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                icon: Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: "Name",
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 24),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
            ),
            child: TextFormField(
              controller: tfPhoneController,
              keyboardType: TextInputType.phone,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                icon: Icon(
                  Icons.phone,
                  color: Colors.black,
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: "Phone",
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 24),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
            ),
            child: TextFormField(
              controller: tfEmailController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                icon: Icon(
                  Icons.email,
                  color: Colors.black,
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: "Email",
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 24, right: 24, top: 20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton(
              child: Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              onPressed: () async {
                if (key.currentState.validate()) {
                  print(tfNameController.text);
                  print(tfPhoneController.text);
                  print(tfEmailController.text);
                  People newPeople = People(
                    name: tfNameController.text,
                    phone: tfPhoneController.text,
                    email: tfEmailController.text,
                  );
                  tfNameController.text = '';
                  tfPhoneController.text = '';
                  tfEmailController.text = '';
                  if (widget.rowPeople == null) {
                    newPeople.id = await DataBasePeople.instance.insertData({
                      DataBasePeople.columnName: newPeople.name,
                      DataBasePeople.columnPhone: newPeople.phone,
                      DataBasePeople.columnEmail: newPeople.email,
                    });
                    print(' >>>>>>>> the id of new people ${newPeople.id}');
                  } else {
                    newPeople.id = widget.rowPeople.id;
                    int result = await DataBasePeople.instance.updateData({
                      DataBasePeople.columnId: newPeople.id,
                      DataBasePeople.columnName: newPeople.name,
                      DataBasePeople.columnPhone: newPeople.phone,
                      DataBasePeople.columnEmail: newPeople.email,
                    });
                    print(' >>>>>>>> row updated $result');
                  }
                  Navigator.pop(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
