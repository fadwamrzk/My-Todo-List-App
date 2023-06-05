import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'todo_list_provider.dart';
import 'todo_add.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';

class MyHomePage2 extends StatelessWidget {
  const MyHomePage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My App'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20, left: 0, right: 0),
            child: Container(
              width: 500,
              height: 150,
              child: Image.asset('assets/images/img.png'),
            ),
          ),
          Expanded(
            child: Consumer<TodoListProvider>(
              builder: (context, provider, _) {
                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection("tasks").snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error'));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {

                        DocumentSnapshot document = snapshot.data!.docs[index];
                        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                        DateTime taskDate = (data['date'] as Timestamp).toDate();
                        String formattedDate = DateFormat('yyyy-MM-dd').format(taskDate);

                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          margin: EdgeInsets.all(8),
                          padding: EdgeInsets.all(8),
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['name'],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (data['description'].isNotEmpty)
                                  Text(
                                    data['description'],
                                    style: TextStyle(
                                      color: Colors.blue,
                                    ),
                                  ),
                                Text(
                                  'Date: $formattedDate',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value: data['completed'] ?? false,
                                  onChanged: (value) {
                                    if (value != null) {
                                      provider.changeCompleteness(document.id);
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    provider.deleteTodo(document.id);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    _showEditDialog(context, document.id, data['name']);
                                  },
                                ),
                              ],
                            ),
                            onTap: () {
                              _showDescriptionDialog(context, document.id, data['description']);
                            },
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Colors.indigo,
        onPressed: () async {
          final result = await Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: NewItemView(),
                );
              },
            ),
          );

          Provider.of<TodoListProvider>(context, listen: false).addNewTask(result);
        },
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context, String taskId, String currentName) async {
    String newName = currentName;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modifier la tâche'),
          content: TextField(
            onChanged: (value) {
              newName = value;
            },
            controller: TextEditingController(text: currentName),
            decoration: const InputDecoration(hintText: 'Nouveau nom'),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Provider.of<TodoListProvider>(context, listen: false).updateName(taskId, newName);
                Navigator.pop(context);
              },
              child: const Text('Modifier'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Annuler'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDescriptionDialog(BuildContext context, String taskId, String currentDescription) async {
    String newDescription = currentDescription;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modifier la catégorie'),
          content: TextField(
            onChanged: (value) {
              newDescription = value;
            },

          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Provider.of<TodoListProvider>(context, listen: false).updateDescription(taskId, newDescription);
                Navigator.pop(context);
              },
              child: const Text('Modifier'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Annuler'),
            ),
          ],
        );
      },
    );
  }
}