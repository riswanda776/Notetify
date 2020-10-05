import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {
  //note reference
  static CollectionReference noteReference =
      Firestore.instance.collection("Note");

//url reference
  static CollectionReference urlReference =
      Firestore.instance.collection("Url");

// todoList reference
  static CollectionReference todoReference =
      Firestore.instance.collection("Todo");

// get data from note document
  static Stream<QuerySnapshot> noteList(String email) {
    return Firestore.instance
        .collection("Note")
        .where("email", isEqualTo: email).orderBy("tanggal", descending: true)
        .snapshots();
  }

// add note to document
  static Future<void> addData(
    String email,
    DateTime tanggal,
    String title,
    String note,
    String colors,
  ) async {
    await noteReference.add({
      'email': email,
      'tanggal': tanggal,
      'title': title,
      'note': note,
      'color': colors,
    });
  }

//update note
  static Future<void> updateData(
      DateTime tanggal, String title, String note, DocumentReference id) async {
    await noteReference.document(id.documentID).updateData({
      'title': title,
      'note': note,
      'tanggal': tanggal,
    });
  }

//delete note
  static Future<void> deleteDate(DocumentReference id) async {
    await noteReference.document(id.documentID).delete();
  }

// add url
  static Future<void> addUrl(DateTime date,String email, String url) async {
    await urlReference.add(({
      'Date' : date,
      'Email': email,
      'Url': url,
    }));
  }

// get url
  static Stream<QuerySnapshot> getUrlList(String email) {
    return Firestore.instance
        .collection("Url")
        .where("Email", isEqualTo: email).orderBy("Date", descending: true)
        .snapshots();
  }

// delete url;
  static Future<void> deleteUrl(DocumentReference id) async {
    await urlReference.document(id.documentID).delete();
  }

// add todo list
  static Future<void> addTodoList(String email,int notifID, DateTime date, String category,
      String title, String details) async {
    await todoReference.add(({
      "Email": email,
      "NotificationID" : notifID,
      "Date": date,
      "Category": category,
      "Title": title,
      "Details": details,
    }));
  }

//get todoList data
  static Stream<QuerySnapshot> getTodoList(String email) {
    return Firestore.instance
        .collection("Todo")
        .where("Email", isEqualTo: email).orderBy("Date", descending: true)
        .snapshots();
  }


// edit todoList
  static Future<void> updateTodoList(
      
      DateTime date,
      String category,
      String title,
      String details,
      DocumentReference id) async {
    await todoReference.document(id.documentID).updateData({
      "Date": date,
      "Category": category,
      "Title": title,
      "Details": details,
    });
  }

  //delete todoList
  static Future<void> deleteTodo(DocumentReference id) async {
    await todoReference.document(id.documentID).delete();
  }
}
