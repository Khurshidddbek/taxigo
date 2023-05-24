import 'package:flutter/material.dart';
import 'package:taxigo/domain/models/user.dart';
import 'package:taxigo/domain/repositories/profile_repository.dart';

class ProfileState extends ChangeNotifier {
  ProfileState() {
    fetchUser();
  }

  User? user;

  Future<void> fetchUser() async {
    try {
      user = await ProfileRepository.fetchUser();
      debugPrint(user.toString());
    } catch (e) {
      debugPrint("ProfileState.fetchUser() error: $e");
    }
  }
}
