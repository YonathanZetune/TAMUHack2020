import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tamu_hack_2020/models/form_info.dart';
import 'package:tamu_hack_2020/models/map_info.dart';
import 'package:tamu_hack_2020/utilities/constants.dart';
import 'package:tamu_hack_2020/utilities/requests.dart';

class ReportPage extends StatelessWidget {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  Future<File> getImage(BuildContext context) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    //    var formInfo = Provider.of<FormInfo>(context, listen: false);
    showAlertDialog(context, image);
    return image;
  }

  showAlertDialog(BuildContext context, File img) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () async {
        uploadImage(img);
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Image Selected"),
      content:
          Text("Image is ready to be uploaded. Would you like to proceed?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
//    AlertDialog alertSuccess = AlertDialog(
//      title: Text("Form was received and updated databse!"),
//      content:
//      Text("You report is not available on the List tab"),
//      actions: [
//        cancelButton,
//
//      ],
//    );
//
//    // show the dialog
//    showDialogSuc(
//      context: context,
//      builder: (BuildContext context) {
//        return alertSuccess;
//      },
//    );
  }

  void uploadImage(File img) {
    Requests.getImageProperties(img);
  }

  @override
  Widget build(BuildContext context) {
    var formInfo = Provider.of<FormInfo>(context, listen: false);
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Report Animal / Help"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: <Widget>[
              FormBuilder(
                key: _fbKey,
                initialValue: {
                  'date': DateTime.now(),
                  'accept_terms': false,
                },
                autovalidate: true,
                child: Column(
                  children: <Widget>[
                    FormBuilderSegmentedControl(
                      decoration: InputDecoration(labelText: "Report Type"),
                      attribute: "reporting_type",
                      options: List.generate(2, (i) => i + 1)
                          .map((number) => FormBuilderFieldOption(
                              value: number == 1 ? "Animal" : "Help"))
                          .toList(),
                    ),
                    FormBuilderTextField(
                      attribute: "Description",
                      decoration: InputDecoration(labelText: "Summary"),
                      validators: [
                        FormBuilderValidators.max(100),
                      ],
                    ),
                    FormBuilderSegmentedControl(
                      decoration: InputDecoration(labelText: "Route to organization"),
                      attribute: "org_type",
                      options: [FormBuilderFieldOption(
                          value: "Food"),FormBuilderFieldOption(
                          value: "Shelter"),FormBuilderFieldOption(
                          value: "Transport")],
                    ),
                    FormBuilderSwitch(
                      label: Text('Upload Image'),
                      attribute: "accept_terms_switch",
                      initialValue: false,
                      onChanged: (selected) async {
                        if (selected) {
                          print('selected');
                          formInfo.needUpload = true;

                          formInfo.image = await getImage(context);
                        } else {
                          print('notselected');
                          formInfo.image = null;
                        }
                      },
                    ),
                    Row(
                      children: <Widget>[
                        MaterialButton(
                          child: Text("Submit"),
                          onPressed: () async {
//                            print("SPEC");

                            await Requests.getImageProperties(formInfo.image)
                                .then((spec) async {
                              print("SPEC");

                              await Requests.postFAPIAnimal(Constants.startLat,
                                  Constants.startLong, spec).then((status){
                                    if(status == 200){
                                        print("Data received!");
                                    }
                              });


                            });
                            if (_fbKey.currentState.saveAndValidate()) {
                              print(_fbKey.currentState.value);
                            }
                            //call to post request

                          },
                        ),
                        MaterialButton(
                          child: Text("Reset"),
                          onPressed: () {
                            _fbKey.currentState.reset();
                          },
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
