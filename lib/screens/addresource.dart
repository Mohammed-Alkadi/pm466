import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class AddResource extends StatefulWidget {
  const AddResource({Key? key}) : super(key: key);

  @override
  State<AddResource> createState() => _AddResourceState();
}

class _AddResourceState extends State<AddResource> {
  TextEditingController _resourceNameController = TextEditingController();
  String _selectedResourceType = 'Cost';
  TextEditingController _resourceValueController = TextEditingController();
  TextEditingController _materialController = TextEditingController();
  TextEditingController _stRateController = TextEditingController();

  FocusNode _resourceNameFocusNode = FocusNode();

  void _saveResourceToFirestore() async {
    // Get a reference to the Firestore database
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Construct the resource data object
    Map<String, dynamic> resourceData = {
      'name': _resourceNameController.text,
      'type': _selectedResourceType,
    };

    // Add additional fields based on the selected resource type
    if (_selectedResourceType == 'Cost') {
      resourceData['value'] = double.parse(_resourceValueController.text);
    } else if (_selectedResourceType == 'Material') {
      resourceData['material'] = _materialController.text;
      resourceData['stRate'] = double.parse(_stRateController.text);
    } else if (_selectedResourceType == 'Work') {
      resourceData['stRate'] = double.parse(_stRateController.text);
    }

    // Add the resource data to Firestore
    try {
      await firestore.collection('resources').add(resourceData);
      // Display a success message or navigate to a new screen
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color.fromARGB(255, 67, 228, 115),
            title: Text('Resource Added',
                style: TextStyle(color: Color.fromARGB(255, 5, 3, 21))),
            content: Text('The resource has been successfully added.',
                style: TextStyle(color: Color.fromARGB(255, 5, 3, 21))),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Handle any errors that occur during the operation
      print('Error adding resource: $e');
      // Optionally, show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    var _isLoading = false;
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Resource'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(children: [
              SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        focusNode: _resourceNameFocusNode,
                        controller: _resourceNameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              width: 2,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                          fillColor: Color.fromARGB(255, 67, 228, 115),
                          labelText: 'Resource Name',
                        ),
                        style: TextStyle(
                          color: Color.fromARGB(255, 83, 66, 221),
                        ),
                        keyboardType: TextInputType.text,
                        onEditingComplete: () {
                          // Add any logic you want to execute when editing is complete
                        },
                      ),
                      SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: _selectedResourceType,
                        onChanged: (value) {
                          setState(() {
                            _selectedResourceType = value!;
                          });
                        },
                        items: ['Cost', 'Material', 'Work']
                            .map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        dropdownColor: Color.fromARGB(255, 67, 228, 115),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              width: 2,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                          fillColor: Color.fromARGB(255, 67, 228, 115),
                          labelText: 'Resource Type',
                        ),
                        style: TextStyle(
                          color: Color.fromARGB(255, 83, 66, 221),
                        ),
                      ),
                      SizedBox(height: 20),
                      if (_selectedResourceType == 'Cost')
                        TextFormField(
                          controller: _resourceValueController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                width: 2,
                                style: BorderStyle.none,
                              ),
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 67, 228, 115),
                            labelText: 'Cost/User',
                          ),
                          style: TextStyle(
                            color: Color.fromARGB(255, 83, 66, 221),
                          ),
                        )
                      else if (_selectedResourceType == 'Material')
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: _materialController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    width: 2,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                filled: true,
                                fillColor: Color.fromARGB(255, 67, 228, 115),
                                labelText: 'Material',
                              ),
                              style: TextStyle(
                                color: Color.fromARGB(255, 83, 66, 221),
                              ),
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: _stRateController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    width: 2,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                filled: true,
                                fillColor: Color.fromARGB(255, 67, 228, 115),
                                labelText: 'St Rate',
                              ),
                              style: TextStyle(
                                color: Color.fromARGB(255, 83, 66, 221),
                              ),
                            ),
                          ],
                        )
                      else if (_selectedResourceType == 'Work')
                        TextFormField(
                          controller: _stRateController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                width: 2,
                                style: BorderStyle.none,
                              ),
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 67, 228, 115),
                            labelText: 'St Rate',
                          ),
                          style: TextStyle(
                            color: Color.fromARGB(255, 83, 66, 221),
                          ),
                        ),
                      SizedBox(height: 20),
                      _isLoading
                          ? CircularProgressIndicator()
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                //add the logic here for confirming the addition of a task
                                onPressed: _saveResourceToFirestore,
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                ),
                                child: Text(
                                  'Save Resource',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                ),
                              ),
                            )
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
