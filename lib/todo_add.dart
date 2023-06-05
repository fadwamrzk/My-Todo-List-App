import 'package:flutter/material.dart';

class NewItemView extends StatelessWidget {
  final TextEditingController textFieldController = TextEditingController();

  NewItemView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('new task'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: textFieldController,
                onEditingComplete: () => save(context),
              ),
              TextButton(
                  onPressed: () => save(context), child: const Text('Save'))
            ],
          ),
        ));
  }

  void save(BuildContext context) {
    if (textFieldController.text.isNotEmpty) {
      Navigator.of(context).pop(textFieldController.text);
    }
  }
}
