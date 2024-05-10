import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/common/firebase_constants.dart';
import '../../../core/common/search.dart';
import '../../../core/providers/failure.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/providers/typedef.dart';
import '../../../model/user_model.dart';

final userRepositoryProvider =Provider((ref) {
  return UserRepository(firestore: ref.watch(firestoreProvider));
});

class UserRepository {
  final FirebaseFirestore _firestore;
  UserRepository({required FirebaseFirestore firestore})
      :_firestore=firestore;

  FutureVoid addUsers({
    required String name,
    required int age,
    required String image,
    required String phoneNumber,
  }) async{
    try{
      var userDoc = await _users.doc(name).get();
      if (userDoc.exists){
        throw "User with the same name exist!";
      }
      UserModel user =UserModel(name: name, phoneNumber: phoneNumber,
          image: image, age: age, delete: false,
          search: setSearchParam("${name.toUpperCase().trim()} ${phoneNumber.trim()}"),
          date: DateTime.now());
      return right(_users.doc().set(user.toJson()));
    }on FirebaseException catch(e){
      throw e.message!;
    } catch(e){
      return left(Failure(e.toString()));
    }
  }


  Stream<List<UserModel>> getUsers({required String search,required String sort}){
    if(search.isNotEmpty){
     return _users
          .where('delete', isEqualTo: false)
          .orderBy('date', descending: true)
          .where('search', arrayContains: search.toUpperCase().trim())
          .snapshots().map((event) => event.docs
          .map((e) => UserModel.fromJson(e.data() as Map<String, dynamic>,),).toList(),
      );
    }else{
      if(sort=="Elder"){
        return _users
            .where('delete', isEqualTo: false)
            .where('age', isGreaterThanOrEqualTo: 60 )
            .orderBy('date', descending: true)
            .snapshots().map((event) => event.docs
            .map((e) => UserModel.fromJson(e.data() as Map<String, dynamic>,),).toList(),
        );
      }else if(sort=="Younger"){
        return _users
            .where('delete', isEqualTo: false)
            .where('age', isLessThan: 60 )
            .orderBy('date', descending: true)
            .snapshots().map((event) => event.docs
            .map((e) => UserModel.fromJson(e.data() as Map<String, dynamic>,),).toList(),
        );
      }else{
        return _users
            .where('delete', isEqualTo: false)
            .orderBy('date', descending: true)
            .snapshots().map((event) => event.docs
            .map((e) => UserModel.fromJson(e.data() as Map<String, dynamic>,),).toList(),
        );
      }
    }
  }


  CollectionReference get _users => _firestore.collection(Constants.users);
}