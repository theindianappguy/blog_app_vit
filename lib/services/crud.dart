import 'package:cloud_firestore/cloud_firestore.dart';

class CrudMethods {
  Future<void> addData(Map<String, String> blogData) async {
    await FirebaseFirestore.instance
        .collection("blogs")
        .add(blogData)
        .then((value) => print(value))
        .catchError((e) {
      print(e);
    });
  }
}
