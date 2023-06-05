import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
class TodoListProvider with ChangeNotifier {

  List<Todo> list = [];
  List<Todo> get todos => list;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference todosCollection = FirebaseFirestore.instance.collection('tasks');

  // Add todo to Firestore
  Future<void> addNewTask(String des) async {

    try {
      final docRef = await todosCollection.add({
        'name': des,
        'completed': false,
        'date': Timestamp.now(),
        'description': '',

      });
      Timestamp date=Timestamp.now();
      final newTodo = Todo(
        des,
        docRef.id,
        date,
        '',

      );

      //list.add(newTodo);
      list.add(newTodo);
      notifyListeners();
    } catch (e) {
      print(e);
    }

  }

  // Delete todo from Firestore
  Future<void> deleteTodo(String id) async {
    try {
      await todosCollection.doc(id).delete();
      todos.removeWhere((t) => t.id == id);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateDescription(String taskId, String newDescription) async {
    try {
      await FirebaseFirestore.instance.collection("tasks").doc(taskId).update({
        'description': newDescription,
      });
    } catch (error) {
      // Handle the error
      print('Error updating description: $error');
    }
  }

  Future<void> changeCompleteness(String id) async {
    Todo t=Todo("", id,Timestamp.fromDate(DateTime.now()), "");

    for (int i = 0; i < todos.length; i++) {
      if (todos[i].id == id) {
        t = todos[i];
        break;
      }
    }

    if (t != null) {
      bool newCompletedValue = !t.complete;
      await todosCollection.doc(t.id).update({'completed': newCompletedValue});
      t.complete = newCompletedValue;

    }
  }

  void updateName(String taskId, String newName) {
    FirebaseFirestore.instance.collection('tasks').doc(taskId).update({
      'name': newName,
    }).then((_) {
      notifyListeners();
    }).catchError((error) {
      print('Erreur lors de la mise à jour du nom de la tâche: $error');
    });
  }

  String getTitle(int index) {
    return list[index].title;
  }

  bool getCompleteness(int index) {
    return list[index].complete;
  }

  Todo getElement(index) {
    return list[index];
  }

  int getSize() {
    return list.length;
  }
}

class Todo {
  final String id;
  String title;
  bool complete = false;
  String description = '';
  Timestamp date  ;
  Todo(this.title, this.id, this.date,[this.description = '']);
}

