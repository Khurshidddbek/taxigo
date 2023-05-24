import 'package:flutter/material.dart';
import 'package:taxigo/domain/repositories/profile_repository.dart';

class ProfileState extends ChangeNotifier {
  ProfileState() {
    fetchUser();
  }

  Future<void> fetchUser() async {
    try {
      final user = await ProfileRepository.fetchUser();
      debugPrint(user.toString());
    } catch (e) {
      debugPrint("ProfileState.fetchUser() error: $e");
    }
  }
}
