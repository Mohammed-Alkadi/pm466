import 'package:flutter/material.dart';
import 'package:pm/screens/addresource.dart';
import 'package:pm/screens/addtask.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 67, 228, 115),
      body: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 0),
                child: Text(
                  'Getting',
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 48),
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 48),
                child: Text(
                  'Things',
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 32,
                      ),
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 80),
                child: Text(
                  'Done',
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 64,
                      ),
                ),
              ),
            ],
          ),
          //buttons
          SizedBox(
            width: 16,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 20),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddTask(),
                      ),
                    );
                  },
                  child: Text(
                    'Add Task',
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 5, 3, 21)),
                  ),
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 20),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddResource(),
                      ),
                    );
                  },
                  child: Text(
                    'Add Resource',
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 5, 3, 21)),
                  ),
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 20),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Manage Tasks',
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 221, 66, 221)),
                  ),
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 20),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'View Resources',
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 83, 66, 221)),
                  ),
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 20),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'View Tasks',
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 83, 66, 221)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
