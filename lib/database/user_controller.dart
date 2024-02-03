import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rupee_app/model/db_user.dart';

final ValueNotifier<List<UserModel>> userModelsNotifier =
    ValueNotifier<List<UserModel>>([]);

class UserProfileFunctions {
  final box = Hive.box<UserModel>('userProfileBox');

  Future<void> addProfileDetails(UserModel details) async {
    await box.put(details.id, details);
    userModelsNotifier.value = getAllProfileDetails();
  }

  List<UserModel> getAllProfileDetails() {
    return box.values.toList();
  }

  Future<void> updateUserDetails(UserModel updatedUser) async {
    await box.put(updatedUser.id, updatedUser);
    userModelsNotifier.value = getAllProfileDetails();
  }
}
