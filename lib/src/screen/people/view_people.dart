import 'package:all_in_one_app/src/models/People.dart';
import 'package:flutter/material.dart';

class ViewPeople extends StatelessWidget {
  const ViewPeople({Key key, this.infoPeople}) : super(key: key);

  final People infoPeople;

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
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              Container(
                margin: EdgeInsets.only(top: 40),
                padding: EdgeInsets.only(top: 10),
                height: size.height * 0.2,
                width: double.infinity,
                alignment: AlignmentDirectional.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.call,
                          color: Colors.black,
                          size: 18,
                        ),
                        SizedBox(width: 10),
                        Text(
                          '${infoPeople.phone}',
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                              fontWeight: FontWeight.bold, color: Colors.black),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.email,
                          color: Colors.black,
                          size: 18,
                        ),
                        SizedBox(width: 10),
                        Text(
                          '${infoPeople.email}',
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                              fontWeight: FontWeight.bold, color: Colors.black),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                alignment: AlignmentDirectional.center,
                padding: EdgeInsets.all(10),
                height: size.height * 0.1,
                width: size.width * 0.7,
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.indigo.shade300,
                      offset: Offset(0, 5),
                      blurRadius: 8.0,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Text(
                  '${infoPeople.name}',
                  style: Theme.of(context).textTheme.headline6.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
