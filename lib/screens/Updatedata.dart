
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:offlinestorage/models/hivemodel.dart';
import 'package:offlinestorage/screens/feedscreen.dart';

class UpdateData extends StatefulWidget {
  bool isEdit;
  int position = -1;
  GetService? getServicemodel = null;
  UpdateData( {Key? key, required this.isEdit,required this.position, required this.getServicemodel}) : super(key: key);

  @override
  _UpdateDataState createState() => _UpdateDataState();
}

class _UpdateDataState extends State<UpdateData> {
  var firstNameController =  TextEditingController();
  var lastNameController =  TextEditingController();
  var statusController =  TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.isEdit) {
      firstNameController.text = widget.getServicemodel!.name;
      lastNameController.text = widget.getServicemodel!.lastname;
      statusController.text = widget.getServicemodel!.status;
    }

    return Scaffold(
        appBar: AppBar(
        title: Text('ADD and Update')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 30),
              Row(
                children: [
                  Text("FIRSTNAME :", style: TextStyle(fontSize: 18, color:  Colors.black)),
                  SizedBox(width: 20),
                  Expanded(
                    child:
                  TextField(controller: firstNameController,
                    textInputAction: TextInputAction.next,
                  )),
                ],
              ),
              Row(
                children: [
                  Text("LASTNAME :", style: TextStyle(fontSize: 18,color:  Colors.black)),
                  SizedBox(width: 20),
                  Expanded(
                    child:
                  TextField(controller: lastNameController,
                    textInputAction: TextInputAction.next,
                  )),
                ],
              ),
              Row(
                children: [
                  Text("STATUS    :",style: TextStyle(fontSize: 18,color:  Colors.black)),
                  SizedBox(width: 40),
                  Expanded(
                    child:
                  TextField(controller: statusController,
                    textInputAction: TextInputAction.next,
                  )),
                ],
              ),
                 SizedBox(height: 20,),
              MaterialButton(
                color: Colors.blue,
                child: Text("SAVE",
                    style: TextStyle(color: Colors.white, fontSize: 18, )),
                onPressed: () async {
                  var firstName = firstNameController.text;
                  var lastName = lastNameController.text;
                  var status = statusController.text;
                  if (firstName.isNotEmpty &
                  lastName.isNotEmpty &
                  status.isNotEmpty) {
                    GetService updatedata = new GetService(
                        name: firstName,
                        lastname: lastName,
                        status: status);

                     if (widget.isEdit) {
                     var box = await Hive.openBox<GetService>('service');
                       box.putAt(widget.position, updatedata);
                    } else {
                      var box = await Hive.openBox<GetService>('service');
                      box.add(updatedata);
                    }

                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (_) => FeedScreen()),
                            (r) => false);
                 }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
