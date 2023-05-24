import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:taxigo/domain/models/user.dart' as models;

class ProfileRepository {
  static Future<models.User?> fetchUser() async {
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    String? userUid = firebaseUser?.uid;

    if (userUid == null) throw Exception("UnauthorizedException");

    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('users/$userUid').get();

    if (snapshot.exists) {
      return models.User.fromSnapshot(snapshot);
    }

    return null;
  }
}
