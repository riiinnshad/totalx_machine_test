import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:totalx_machine_test/core/providers/typedef.dart';
import 'dart:io';
import 'failure.dart';
import 'firebase_providers.dart';

final storageRepositoryProvider=Provider((ref) =>
    StorageRepository(firebaseStorage:ref.watch(storageProvider)));
class StorageRepository{
  final FirebaseStorage _firebaseStorage;
  StorageRepository({required FirebaseStorage firebaseStorage}):_firebaseStorage=firebaseStorage;

  FutureEither<String> storeFile({
    required String path,
    required File? file
  })async{
    try{
      final ref=_firebaseStorage.ref().child(path);
      UploadTask uploadTask=ref.putFile(file!);
      final snapshot =await uploadTask;
      return right(await snapshot.ref.getDownloadURL());
    }catch(e){
     return left(Failure(e.toString()));
    }
  }
}