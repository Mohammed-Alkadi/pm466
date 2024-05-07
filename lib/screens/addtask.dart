import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController startDateInput = TextEditingController();
  TextEditingController endDateInput = TextEditingController();
  TextEditingController _durationController = TextEditingController();
  TextEditingController _taskNameController = TextEditingController();

  var _enteredDuration = '';
  var _isLoading = false;

  void _calculateEndDate() {
    if (_durationController.text.isNotEmpty && startDateInput.text.isNotEmpty) {
      final int duration = int.parse(_durationController.text);
      final DateTime startDate =
          DateFormat('yyyy-MM-dd').parse(startDateInput.text);

      int remainingDuration = duration - 1;
      DateTime endDate = startDate;

      // Iterate over each day in the duration
      // Iterate over each day in the duration
      while (remainingDuration > 0) {
        // If the current day is a weekend (Friday or Saturday), skip it by adding 1 extra day to the duration
        if (endDate.weekday == DateTime.friday ||
            endDate.weekday == DateTime.saturday) {
          endDate = endDate.add(Duration(days: 1));
        } else {
          remainingDuration--;
        }
        // Move to the next day
        endDate = endDate.add(Duration(days: 1)); // Moved inside the else block
      }

      setState(() {
        endDateInput.text = DateFormat('yyyy-MM-dd').format(endDate);
      });
    }
  }

  void _saveTaskToFirestore() {
    // Get the values from the input fields
    String taskName = _taskNameController.text;
    int taskDuration = int.parse(_durationController.text);
    String startDate = startDateInput.text;
    String endDate = endDateInput.text;

    // Prepare a map with the task data
    Map<String, dynamic> taskData = {
      'taskName': taskName,
      'taskDuration': taskDuration,
      'startDate': startDate,
      'endDate': endDate,
    };

    FirebaseFirestore.instance.collection('tasks').add(taskData).then((value) {
      // Task added successfully
      print('Task added to Firestore');
      // Show a dialog to inform the user
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color.fromARGB(255, 67, 228, 115),
            title: Text(
              'Task Added',
              style: TextStyle(color: Color.fromARGB(255, 5, 3, 21)),
            ),
            content: Text('The task has been successfully added.',
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
    }).catchError((error) {
      // Error occurred while adding the task
      print('Error adding task to Firestore: $error');
      // You can show an error message here
    });
  }

  FocusNode _durationFocusNode = FocusNode();
  FocusNode _taskNameFocusNode = FocusNode();
  void initState() {
    super.initState();
    _durationFocusNode.addListener(() {
      if (!_durationFocusNode.hasFocus) {
        _calculateEndDate();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Add a Task',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  color: Color.fromARGB(255, 83, 66, 221),
                ),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            focusNode: _taskNameFocusNode,
                            controller: _taskNameController,
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
                              labelText: 'Task Name',
                            ),
                            style: TextStyle(
                              color: Color.fromARGB(255, 83, 66, 221),
                            ),
                            keyboardType: TextInputType.text,
                            onEditingComplete: () {
                              // Add any logic you want to execute when editing is complete
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            focusNode: _durationFocusNode,
                            controller: _durationController,
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
                              labelText: 'Task Duration',
                            ),
                            style: TextStyle(
                              color: Color.fromARGB(255, 83, 66, 221),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(2),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onEditingComplete: () => _calculateEndDate(),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: startDateInput,
                            enabled: !_isLoading,
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
                              labelText: 'Start Date',
                            ),
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(DateTime.now().year + 5,
                                    DateTime.now().month, DateTime.now().day),
                              );

                              if (pickedDate != null) {
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                setState(() {
                                  startDateInput.text = formattedDate;
                                  _calculateEndDate();
                                });
                              } else {
                                setState(() {
                                  startDateInput.text = '';
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: endDateInput,
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
                              enabled: false,
                              labelText: 'End Date',
                            ),
                          ),
                          const SizedBox(height: 20),
                          _isLoading
                              ? CircularProgressIndicator()
                              : SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    //add the logic here for confirming the addition of a task
                                    onPressed: _saveTaskToFirestore,
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    child: Text(
                                      'Save Task',
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
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
