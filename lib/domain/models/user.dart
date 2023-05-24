// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_database/firebase_database.dart';

class User {
  String uid;
  String fullName;
  String email;
  String phone;

  User({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.phone,
  });

  factory User.fromSnapshot(DataSnapshot snapshot) => User(
        uid: snapshot.key!,
        fullName: (snapshot.value as Map)['fullname']!,
        email: (snapshot.value as Map)['email']!,
        phone: (snapshot.value as Map)['phone']!,
      );

  @override
  String toString() {
    return 'User(id: $uid, fullName: $fullName, email: $email, phone: $phone)';
  }
}
