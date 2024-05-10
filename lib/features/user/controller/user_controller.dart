import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/global.dart';
import '../../../core/providers/storage_repository_provider.dart';
import '../../../model/user_model.dart';
import '../repository/user_repository.dart';

final userControllerProvider = NotifierProvider<UserController,bool>(() {
  return UserController();
});

final getUserProvider = StreamProvider.family((ref,String data){
  return ref.watch(userControllerProvider.notifier).getUsers(data);
});

class UserController extends Notifier<bool> {
  @override
  bool build() {
    // TODO: implement build
    throw UnimplementedError();
  }
  UserRepository get _userRepository => ref.read(userRepositoryProvider);
  StorageRepository get _storageRepository => ref.read(storageRepositoryProvider);

  addUsers({
    required String name,
    required int age,
    required File file,
    required String phoneNumber,
    required BuildContext context,
  }) async {
    state = true;
    final imageRes = await _storageRepository.storeFile(
      path: 'users/$name',
      file: file,
      // webFile: webFile,
    );
    imageRes.fold((l) =>
        showMessage(context, text: l.message, color: Colors.red), (r) async {
      final user = await _userRepository.addUsers(name: name, age: age,
          image: r, phoneNumber: phoneNumber);
      state = false;
      user.fold((l) => null, (r) {
        showMessage(context,text:"User Created successfully..!",color: Colors.green);
        Navigator.of(context).pop();
      });
    });
  }

  Stream<List<UserModel>> getUsers(String data){
    Map map=jsonDecode(data);
    return _userRepository.getUsers( search: map["search"], sort:map["sort"]);
  }
}