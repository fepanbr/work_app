import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  int id;
  String email;
  String name;

  User(this.id, this.email, this.name);

  User.fromSnapshot(DocumentSnapshot documentSnapshot)
      : this.id = (documentSnapshot.data() as Map<String, dynamic>)['id'],
        this.email = (documentSnapshot.data() as Map<String, dynamic>)['email'],
        this.name = (documentSnapshot.data() as Map<String, dynamic>)['name'];

  toJson() {
    return {"id": id, "email": email, "name": name};
  }
}
